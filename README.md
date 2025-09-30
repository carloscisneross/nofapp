# nofApp – Assets Pack

This repository contains the **ready-to-use assets** for *nofApp* (avatars, medals, and app icons).  
Drop this folder into your Flutter project root (or keep it as a submodule) and follow the setup below.

---

## Structure

```
assets/
  avatars/
    female/…
    male/…
    premium/…
  icons/
    android/    # launcher icons for Android
    ios/        # launcher icons for iOS (light, dark, glass, tinted)
  medals/
    personal/   # streak medals
    guild/      # guild medals
    leaderboards/ # (future) global leaderboard medals
```

### Inventory (detected)
- Avatars: 17 files
- iOS Icons: 4 files
- Android Icons: 2 files
- Medals (personal): 24 files
- Medals (guild): 20 files
- Medals (leaderboards): 0 files

> A detailed list is written to `ASSET_INVENTORY.json`.

---

## Flutter setup

Add these entries to your **pubspec.yaml** (or replace your existing `flutter.assets` list):

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/avatars/
    - assets/avatars/female/
    - assets/avatars/male/
    - assets/avatars/premium/
    - assets/medals/personal/
    - assets/medals/guild/
    - assets/medals/leaderboards/
```

Run:
```bash
flutter pub get
```

---

## Launcher icons

This repo includes a `flutter_launcher_icons.yaml` prefilled for Android & iOS.

1. Install tool:
   ```bash
   flutter pub add dev:flutter_launcher_icons
   ```
2. Generate:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

> **iOS (Glass & Tinted modes)**  
> - The standard icon is provided (**light** variant).  
> - For **Tinted** and **Glass/Liquid** modes on iOS, also include the provided **monochrome (tinted)** and **glass** variants in your Xcode asset catalog:
>   - Open your iOS project in Xcode: `ios/Runner.xcworkspace`
>   - In **Assets.xcassets → AppIcon**, add the **“Single Size”** or **“Monochrome”** variants if available for your Xcode version.
>   - Drag the corresponding files from `assets/icons/ios/`:
>     - `*_tinted.png` → Monochrome / Tintable slot
>     - `*_glass.png`   → Glass / Layered or foreground slot depending on template
>   - Keep the standard `*_light.png` as the primary icon.
>
> Tooling support for these new modes is evolving; if your Flutter toolchain doesn’t yet wire them automatically, the Xcode steps above ensure proper behavior on iOS 18+.

---

## Notes
- All icons are **1024×1024 PNG** master files. Android/iOS build systems will generate sized variants.
- Leaderboard medals are included for future releases but may be unused in v1.0.
- Keep file names stable once referenced in code to avoid cache issues.

---

## License
Assets are provided for use within the *nofApp* project.
