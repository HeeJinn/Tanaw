// Checks firestore.rules against the local emulator. Run:
//   firebase emulators:exec --only firestore --project demo-tanaw "node tool/rules_test.mjs"
const host = process.env.FIRESTORE_EMULATOR_HOST ?? '127.0.0.1:8080';
const root = 'projects/demo-tanaw/databases/(default)/documents';
const base = `http://${host}/v1/${root}`;

// The emulator accepts unsigned tokens; "owner" bypasses rules for setup.
// Uids starting with "new" have not clicked their email verification link.
const b64 = (o) => Buffer.from(JSON.stringify(o)).toString('base64url');
const token = (uid) => uid === 'owner' ? 'owner'
  : `${b64({ alg: 'none', typ: 'JWT' })}.${b64({ sub: uid, user_id: uid, email_verified: !uid.startsWith('new'), iat: 0, exp: 9999999999, aud: 'demo-tanaw', iss: 'https://securetoken.google.com/demo-tanaw' })}.`;
const headers = (uid) => ({ 'Content-Type': 'application/json', ...(uid ? { Authorization: `Bearer ${token(uid)}` } : {}) });

const val = (v) => typeof v === 'string' ? { stringValue: v }
  : typeof v === 'boolean' ? { booleanValue: v }
  : Number.isInteger(v) ? { integerValue: String(v) } : { doubleValue: v };
const fields = (data) => Object.fromEntries(Object.entries(data).map(([k, v]) => [k, val(v)]));

// One write via commit; `now` lists fields set to the server timestamp.
async function write(uid, path, data, { now = [], mask } = {}) {
  const res = await fetch(`${base}:commit`, {
    method: 'POST', headers: headers(uid),
    body: JSON.stringify({ writes: [{
      update: { name: `${root}/${path}`, fields: fields(data) },
      ...(mask ? { updateMask: { fieldPaths: mask } } : {}),
      updateTransforms: now.map((f) => ({ fieldPath: f, setToServerValue: 'REQUEST_TIME' })),
    }] }),
  });
  return res.ok;
}
const read = async (uid, path) => (await fetch(`${base}/${path}`, { headers: headers(uid) })).ok;
async function list(uid, collection, where, parent) {
  const res = await fetch(`${base}${parent ? `/${parent}` : ''}:runQuery`, {
    method: 'POST', headers: headers(uid),
    body: JSON.stringify({ structuredQuery: { from: [{ collectionId: collection }],
      ...(where ? { where: { fieldFilter: { field: { fieldPath: where[0] }, op: 'EQUAL', value: val(where[1]) } } } : {}) } }),
  });
  return res.ok;
}

let failed = 0;
async function expect(label, allowed, promise) {
  const ok = await promise;
  if (ok !== allowed) failed++;
  console.log(`${ok === allowed ? 'ok  ' : 'FAIL'} ${allowed ? 'allow' : 'deny '} ${label}`);
}

await fetch(`http://${host}/emulator/v1/${root}`, { method: 'DELETE' });
await write('owner', 'barangays/bued', { name: 'Bued' });
await write('owner', 'users/admin', { uid: 'admin', name: 'Staff', email: 'a@x.ph', phone: '0917', role: 'admin', createdAt: 1 });
const profile = (uid) => ({ uid, name: 'Ana', email: `${uid}@x.ph`, phone: '09171234567', createdAt: 1 });
const report = (uid, extra = {}) => ({ reporterUid: uid, reporterName: 'Ana', reporterPhone: '0917', type: 'flood',
  barangayName: 'Bued', details: 'Knee-deep water', status: 'pending', ...extra });
const message = (uid, fromAdmin) => ({ text: 'Hi', senderUid: uid, fromAdmin });

await expect('signed-out read of barangays', false, read(null, 'barangays/bued'));
await expect('signed-in read of barangays', true, read('ana', 'barangays/bued'));
await expect('unverified read of barangays', false, read('newbie', 'barangays/bued'));
await expect('unverified creates own profile at sign-up', true, write('newbie', 'users/newbie', profile('newbie')));
await expect('unverified reads own profile', false, read('newbie', 'users/newbie'));
await expect('unverified submits a report', false, write('newbie', 'reports/rn', report('newbie'), { now: ['createdAt'] }));
await expect('unverified sends a message', false, write('newbie', 'chats/newbie/messages/mn', message('newbie', false), { now: ['createdAt'] }));
await expect('resident writes barangays', false, write('ana', 'barangays/x', { name: 'X' }));

await expect('create own profile', true, write('ana', 'users/ana', profile('ana')));
await expect('create profile with role admin', false, write('ben', 'users/ben', { ...profile('ben'), role: 'admin' }));
await expect('create profile for someone else', false, write('ben', 'users/cy', profile('cy')));
await expect('give self admin role', false, write('ana', 'users/ana', { role: 'admin' }, { mask: ['role'] }));
await expect('change own phone', true, write('ana', 'users/ana', { phone: '09999999999' }, { mask: ['phone'] }));
await expect('read another profile', false, read('ben', 'users/ana'));
await expect('admin reads a profile', true, read('admin', 'users/ana'));

await expect('submit own report', true, write('ana', 'reports/r1', report('ana'), { now: ['createdAt'] }));
await expect('submit earthquake report', false, write('ana', 'reports/r2', report('ana', { type: 'earthquake' }), { now: ['createdAt'] }));
await expect('submit report as someone else', false, write('ben', 'reports/r3', report('ana'), { now: ['createdAt'] }));
await expect('submit report already resolved', false, write('ana', 'reports/r4', report('ana', { status: 'resolved' }), { now: ['createdAt'] }));
await expect('submit report with fake time', false, write('ana', 'reports/r5', { ...report('ana'), createdAt: 1 }));
await expect('read own report', true, read('ana', 'reports/r1'));
await expect('read another resident\'s report', false, read('ben', 'reports/r1'));
await expect('list own reports', true, list('ana', 'reports', ['reporterUid', 'ana']));
await expect('list all reports as resident', false, list('ana', 'reports'));
await expect('admin lists all reports', true, list('admin', 'reports'));
await expect('resident resolves own report', false, write('ana', 'reports/r1', { status: 'resolved' }, { mask: ['status'] }));
await expect('admin sets status', true, write('admin', 'reports/r1', { status: 'reviewing' }, { mask: ['status'] }));
await expect('admin sets bogus status', false, write('admin', 'reports/r1', { status: 'deleted' }, { mask: ['status'] }));

await expect('message own thread', true, write('ana', 'chats/ana/messages/m1', message('ana', false), { now: ['createdAt'] }));
await expect('update own thread', true, write('ana', 'chats/ana', { userName: 'Ana', lastMessage: 'Hi' }, { now: ['updatedAt'] }));
await expect('resident poses as admin', false, write('ana', 'chats/ana/messages/m2', message('ana', true), { now: ['createdAt'] }));
await expect('message someone else\'s thread', false, write('ben', 'chats/ana/messages/m3', message('ben', false), { now: ['createdAt'] }));
await expect('read someone else\'s messages', false, list('ben', 'messages', null, 'chats/ana'));
await expect('admin replies', true, write('admin', 'chats/ana/messages/m4', message('admin', true), { now: ['createdAt'] }));
await expect('admin reply not marked admin', false, write('admin', 'chats/ana/messages/m5', message('admin', false), { now: ['createdAt'] }));
await expect('resident lists all threads', false, list('ana', 'chats'));
await expect('admin lists all threads', true, list('admin', 'chats'));
await expect('read own messages', true, read('ana', 'chats/ana/messages/m1'));
await expect('list own messages', true, list('ana', 'messages', null, 'chats/ana'));
await expect('admin lists a resident\'s messages', true, list('admin', 'messages', null, 'chats/ana'));

console.log(failed ? `\n${failed} rule check(s) failed` : '\nAll rule checks passed');
process.exit(failed ? 1 : 0);
