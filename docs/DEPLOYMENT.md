# 🚀 CyberSprint 180 — Build & Deployment Guide

This guide details how to compile and distribute **CyberSprint 180** for Android and Web.

---

## 1. Prerequisites

- Flutter SDK 3.24+ (or Master/Main branch)
- Dart SDK 3.5+
- Android Studio / Android SDK Platform-Tools (for Android APK / App Bundle)
- Chrome or modern browser (for Flutter Web)

---

## 2. Compiling for Web

```bash
flutter build web --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

The compiled release artifacts will be placed in `build/web/` and can be deployed directly to Vercel, Netlify, Firebase Hosting, or GitHub Pages.

---

## 3. Compiling Android APK

```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

The signed release APK will be located at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 4. Compiling Android App Bundle (Play Store)

```bash
flutter build appbundle --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```
