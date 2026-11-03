# Tanaw

Flood and heat risk app for the barangays of Binalonan, Pangasinan: a risk
overview, a satellite risk map, hazard alerts, resident reports, and messaging
between residents and the MDRRMO. Everyone signs in (email and password).

## Stack

- Flutter, Material 3 styled toward M3 Expressive (`material_new_shapes` for the shapes)
- Riverpod (code-generated providers) + go_router
- Firebase Auth + Cloud Firestore (project `tanaw-36b20`), Android only for now

## Run

```bash
flutter pub get
dart run build_runner build -d   # after changing any @riverpod provider
flutter run
```

Android reads its Firebase config from `android/app/google-services.json`
(package `com.example.tanaw`). Other platforms aren't configured.

## Data

| Collection  | Fields |
|-------------|--------|
| `barangays` | `name`, `lat`, `lng`, `riskLevel` (High/Medium/Low), `temperature`, `population`, `floodRisk`, `heatRisk` (0–1), `historicalTemperatures` (6 monthly averages, oldest first, last = current month) |
| `alerts`    | `title`, `description`, `severity` (High/Medium/Low), `type` (flood/heat), `barangayName` (must match a barangay), `timestamp` |
| `users/{uid}` | `uid`, `name`, `email`, `phone`, `createdAt`, optional `role` |
| `reports`   | `reporterUid`, `reporterName`, `reporterPhone`, `type` (flood/heat), `barangayName`, `details`, `status` (pending/reviewing/resolved), `createdAt` |
| `chats/{residentUid}` | `userName`, `userPhone`, `lastMessage`, `updatedAt`; messages in `chats/{residentUid}/messages` (`text`, `senderUid`, `fromAdmin`, `createdAt`) |

Staff add barangays and alerts in the Firebase console, which isn't bound by
the rules. Read/unread state for alerts is stored on each phone.

### Admins

An admin sees every report (and sets its status), gets an inbox of all
resident conversations, and can call residents. To make someone an admin, have
them register in the app, then in the Firebase console open `users/{their uid}`
and add the string field `role` = `admin`. The rules stop anyone from setting
that field from the app.

### Security rules

`firestore.rules`: signed-in users read barangays and alerts; residents only
see their own profile, reports and conversation; only admins change report
status. Check them on the emulator before deploying (needs Java 21 for the
current Firebase CLI, or firebase-tools v13 with Java 17):

```bash
firebase emulators:exec --only firestore --project demo-tanaw "node tool/rules_test.mjs"
firebase deploy --only firestore:rules
```

### Re-seeding demo data

`tool/seed/` holds the demo data (`barangays.json`, `alerts.json`; the tests
check them too) and `seed.mjs`, which uploads them. Because the live rules block
writes, seeding needs a short window:

1. In `tool/seed/seed.rules`, set `timestamp.value(...)` to a few minutes from
   now in epoch milliseconds (`node -e "console.log(Date.now()+600000)"`).
2. `firebase deploy --only firestore:rules --config tool/seed/firebase.json`
3. `node tool/seed/seed.mjs`
4. `firebase deploy --only firestore:rules` right away, to lock it again.
5. Set the value back to `0`.

## Test

```bash
flutter test
```
