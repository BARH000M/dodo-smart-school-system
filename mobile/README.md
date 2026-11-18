# Flutter mobile
This is the actual Flutter source with `pubspec.yaml`, `lib`, `assets`, `test` and config examples. Native Android/iOS wrappers must be generated using your installed Flutter SDK (`scripts/PREPARE_MOBILE.ps1` from repo root). Flutter stable 3.35+ / Dart 3.8+ required. No Flutter SDK or Gradle binaries bundled.

From root: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\PREPARE_MOBILE.ps1` then configure backend and `.\scripts\BUILD_ANDROID.ps1`. Running `flutter` from the root will fail: use `mobile/` (contains pubspec.yaml). `flutter pub get` creates the real lockfile; commit after verification. Native wrappers are never copied over existing platform directories.
