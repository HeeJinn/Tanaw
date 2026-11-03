// Uploads barangays.json and alerts.json to Firestore in one atomic commit.
// Re-running replaces the same documents (alert times restart from "now").
//
// The deployed rules block all client writes, so seeding needs a short write
// window: deploy tool/seed/seed.rules (edit its expiry first), run
//   node tool/seed/seed.mjs
// then immediately redeploy the real rules with `firebase deploy --only firestore:rules`.
import { readFileSync } from 'node:fs';

const project = process.argv[2] ?? 'tanaw-36b20';
const root = `projects/${project}/databases/(default)/documents`;
const load = (name) => JSON.parse(readFileSync(new URL(`./${name}.json`, import.meta.url)));

const value = (v) =>
  typeof v === 'string' ? { stringValue: v }
  : Number.isInteger(v) ? { integerValue: String(v) }
  : typeof v === 'number' ? { doubleValue: v }
  : Array.isArray(v) ? { arrayValue: { values: v.map(value) } }
  : v instanceof Date ? { timestampValue: v.toISOString() }
  : (() => { throw new Error(`Unsupported value: ${JSON.stringify(v)}`); })();

const doc = (path, data) => ({
  update: {
    name: `${root}/${path}`,
    fields: Object.fromEntries(Object.entries(data).map(([k, v]) => [k, value(v)])),
  },
});

// "Sto. Niño" -> "sto-nino"
const slug = (s) => s.normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');

const barangays = load('barangays');
const names = new Set(barangays.map((b) => b.name));
const now = Date.now();
const alerts = load('alerts').map(({ id, minutesAgo, ...a }) => {
  if (!names.has(a.barangayName)) throw new Error(`${id}: unknown barangay ${a.barangayName}`);
  return { id, ...a, timestamp: new Date(now - minutesAgo * 60_000) };
});

const writes = [
  ...barangays.map((b) => doc(`barangays/${slug(b.name)}`, b)),
  ...alerts.map(({ id, ...a }) => doc(`alerts/${id}`, a)),
];

const res = await fetch(`https://firestore.googleapis.com/v1/${root}:commit`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ writes }),
});
if (!res.ok) {
  console.error(`Seeding failed (${res.status}):`, await res.text());
  process.exit(1);
}
console.log(`Seeded ${barangays.length} barangays and ${alerts.length} alerts into ${project}.`);
