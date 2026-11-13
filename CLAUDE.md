# KrishiSync — Project Rules

Final-year defence project (owner: Asif). Android app that connects **farmers (কৃষক)** directly with **buyers (ক্রেতা)** and **transporters (পরিবহনকারী)**, managed by **Admin** and **Moderator**. Goal: remove middlemen.

Read `PLAN.md` first (status + next step). Design tokens and screen mapping are in `DESIGN.md`.

## Non-negotiables
- **Real backend everywhere.** Every screen reads/writes real Firestore/Storage data. No mock data in screens. Only exception: payment (UI + `PaymentService` placeholder).
- **Match Figma exactly.** Never "improve" the design. If Figma is unclear or missing something, STOP and ask.
- **No hard-coded colors, text styles, spacing, radii or shadows** outside `lib/core/theme/`.
- **No hard-coded user-facing text.** All text comes from ARB files (`lib/l10n/app_bn.arb`, `app_en.arb`). Bangla is the default.
- **App must stay runnable** after every task.
- **Ask before:** adding a package, deleting files, `git reset --hard`, force push, committing `google-services.json`, anything needing a paid plan (e.g. Cloud Functions).
- If anything is ambiguous: STOP and ask. Do not guess.

## Tech stack
- Flutter (stable), Dart, Android only.
- Riverpod (state), go_router (navigation, role-based redirects).
- Firebase: Phone OTP Auth, Cloud Firestore, Firebase Storage. Cloud Functions only with approval.
- flutter_localizations + ARB (bn, en) with in-app language switch.
- Map: decided in PLAN.md (flutter_map/OSM proposed).
- Fonts: Hind Siliguri (bundled) + Noto Sans Bengali fallback.

## Architecture
Feature-first:
```
lib/
  main.dart
  app/            router, app widget, providers bootstrap
  core/           theme/, l10n helpers, utils, errors, constants
  shared/         widgets (buttons, inputs, cards, nav bars, states), models, services
  features/
    auth/  farmer/  buyer/  transporter/  admin/  moderator/
      data/        repositories (abstract + Firebase impl), DTOs
      domain/      models
      presentation/ screens, widgets, controllers (Riverpod)
```
- Repository pattern: abstract interface + `Firebase…Repository` implementation.
- Every async screen handles **loading, empty, error, offline** states (use shared state widgets that match Figma 41/212/214/215).
- Role-based permissions enforced in `firestore.rules` and `storage.rules`, not only UI.

## Per-screen workflow
1. Build screen from Figma (get_design_context + screenshot).
2. Connect real data.
3. `flutter analyze` → 0 issues.
4. Run on emulator, compare with Figma screenshot.
5. Test the flow, report visual/functional problems, fix.
6. Commit (small, clear message). Push after each group of screens.
7. Update `PLAN.md` (status + next step).

## Git
- Remote: https://github.com/asifiqbal247/KrishiSync.git, branch `main`.
- Never commit service-account keys, `.env`, keystores (`*.jks`, `key.properties`).
- Ask before committing `google-services.json` / `firebase_options.dart`.

## Communication
- Simple, short English. Asif does manual steps himself: give exact numbered steps, PowerShell-compatible commands (Windows).
- Explain errors simply, then fix.
- Prefer simple working code over clever code.
