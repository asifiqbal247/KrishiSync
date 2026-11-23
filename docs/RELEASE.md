# Golaghor — how to release an update

Every release APK is signed with the **Golaghor release key**. Phones accept an
update only when it has the same key, so the key must never be lost.

## The release key (back it up!)

| File | Where | In git? |
|---|---|---|
| Release key | `C:\Users\HP\golaghor-keys\golaghor-release.jks` | No (outside the project) |
| Passwords + path | `E:\KrishiSync\android\key.properties` (copy in `C:\Users\HP\golaghor-keys\key.properties`) | No (git-ignored) |

Back up the whole `C:\Users\HP\golaghor-keys` folder to Google Drive **and** a pen
drive. If it is lost, no future update can install over the app.

Release key fingerprints (already needed in Firebase for login OTP):

- SHA-1: `D0:72:AE:48:DF:BD:AA:CC:B8:B3:42:C9:7D:0B:27:67:F2:E9:59:A4`
- SHA-256: `00:B2:0C:51:41:0A:1A:B7:CA:7C:01:BF:D7:0D:54:2E:CA:A8:CB:B3:9B:56:87:4E:93:05:0E:19:F6:3D:CF:BB`

A release build stops with an error if `key.properties` is missing, so a wrong
key is never used by accident.

## Steps for every new release

1. **Bump the version** in `pubspec.yaml`, e.g. `version: 1.0.1+2` → `1.0.2+3`.
   The number after `+` (the build number) must go up by 1 every time.
2. **Build** (PowerShell):
   ```
   cd E:\KrishiSync
   flutter build apk --release --split-per-abi
   ```
   The phone APK is `build\app\outputs\flutter-apk\app-arm64-v8a-release.apk`.
   Rename it to e.g. `golaghor-1.0.2.apk`.
3. **GitHub Release**: github.com/asifiqbal247/KrishiSync → *Releases* →
   *Draft a new release* → tag `v1.0.2` → title `Golaghor 1.0.2` → drag in the
   APK → *Publish release*.
4. **Copy the link**: on the release page, right-click the APK → *Copy link
   address*. It looks like
   `https://github.com/asifiqbal247/KrishiSync/releases/download/v1.0.2/golaghor-1.0.2.apk`.
5. **Firebase console** → Firestore → `appConfig` → `android` → edit:
   - `latestVersionCode` (number) = the build number, e.g. `3`
   - `latestVersionName` (string) = `1.0.2`
   - `apkUrl` (string) = the link from step 4
   - `changelogBn` / `changelogEn` (string) = what is new
   - `minVersionCode` (number): leave as is for a normal update. Raise it
     (e.g. to `3`) only when older versions must not be used any more:
     they then get the update dialog without "পরে".
6. **Testers** (optional): Firebase console → *App Distribution* → upload the
   same APK → choose the *testers* group → *Distribute*.

## What users see

On the next app start (after the splash), phones with an older build get
"নতুন আপডেট এসেছে" with the changes, **এখন আপডেট** and **পরে**. Update
opens the link in the browser; Android then asks to install. The first time,
Android asks to allow "Install unknown apps" for Chrome: allow it. The app
updates over the old one, and users stay logged in.
