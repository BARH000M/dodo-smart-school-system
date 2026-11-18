# DODO SMART SCHOOL SYSTEM — Expanded source V0.2
Independent school ERP, LMS, finance and HR platform. Arabic-first, English support; React web, Flutter Android/iOS, one Supabase database. **Development source, not production-ready.**

## Install on Windows (VS Code)
Extract the package so `E:\dodo-smart-school-system\README.md` exists. Back up any existing workspace; do not overwrite uncommitted changes. Install Git, Node.js 22+, Flutter stable 3.35+ (Dart 3.8+), Android SDK and optionally Supabase CLI/PostgreSQL tools. Docker is not required by this workflow. iOS signing requires macOS or approved cloud service.

```powershell
Set-Location 'E:\dodo-smart-school-system'
code .
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\SETUP.ps1
```
Setup installs web dependencies, creates a real web lockfile, runs web tests/build, generates missing Android and iOS wrappers using installed Flutter in a temporary folder, and runs Flutter pub get/analyze/test. Generated wrappers and real lockfiles should be reviewed then committed. If any command fails, fix it before proceeding. No remote database changes occur.

## New DODO backend
Create a new **disposable** Supabase DODO project and verify its ref. Do not use SAI projects. Run `supabase login` if CLI is available. Use the Dashboard project URL and publishable key only, never a secret/service role key.

```powershell
.\scripts\CONFIGURE_BACKEND.ps1 -ProjectRef 'YOUR_20_CHARACTER_REF' -PublishableKey 'sb_publishable_REPLACE_ME'
.\scripts\LINK_SUPABASE.ps1 -ConfirmProjectRef 'YOUR_20_CHARACTER_REF'
```
Second command links and previews migrations; it does not apply them. After reviewing target and migration output, run with `-Apply` and type exact confirmation. Production DB changes require separate approval. No destructive reset. Run `supabase/tests/catalog_checks.sql` and `rls_isolation.sql` through SQL Editor on disposable test only; tests not previously executed. Create a test Auth user in dashboard; use trusted operator `backend/provision_ADMIN.example.sql` replacing placeholders. Then optionally provision a verified linked parent/student using examples. Never grant roles from a public client.

## Start web and mobile
```powershell
npm run dev
```
In a second PowerShell terminal:
```powershell
Set-Location 'E:\dodo-smart-school-system'
.\scripts\BUILD_ANDROID.ps1
```
Successful APK expected at `mobile\build\app\outputs\flutter-apk\app-debug.apk`. Both clients use the same configured Supabase project. Test only nonproduction data. For Flutter run, `cd mobile` then `flutter run --dart-define-from-file=config/live.json`. Config files are excluded from Git.

## GitHub (new repo only)
Create an empty PRIVATE repository named `dodo-smart-school-system`. Inspect existing Git configuration first (`git status`, `git remote -v`); if this is a new folder, then:
```powershell
git init -b main
git add .
git diff --cached --stat
git status --short
git commit -m "Initialize DODO expanded V0.2"
git remote add origin YOUR_NEW_DODO_GITHUB_REPO_URL
git push -u origin main
```
Review staged files for secrets before committing. Never force push. Existing repository users should merge reviewed changes instead of reinitializing.

## Source and evidence
`web/src` canonical React; `src` shared TypeScript navigation; `mobile/lib` complete Flutter Dart application files and `mobile/pubspec.yaml`; `supabase/migrations` four sequential SQL files; `scripts` PowerShell helpers; `contracts` shared inventory/module contracts; `docs` exact 32/147 source, roadmap and feature matrix; `AGENTS.md` entrypoint. 49 shared module definitions: basic CRUD/draft registers, fee RPCs and scoped read-only records. Not 49 complete workflows. Full ledger, payroll posting, teacher scope, LMS exams, CBSE publication, CMS, Storage, realtime/offline, and many other features remain unfinished. Lists mobile and relation pickers limited to 200. Student/parent access is based on operator-verified links; term expiry not yet implemented. Do not use real children or financial records until production gates are passed. No credentials, APK, native wrappers, or dependency caches shipped. See `docs/reports/EXPANDED_VERIFICATION.md` and `docs/requirements/IMPLEMENTATION_CHECKPOINT.md`.

Run `npm test` without dependencies for structural checks; `scripts/VERIFY.ps1` for runtime build checks. Continue implementation by giving Codex or Copilot the master prompt.
