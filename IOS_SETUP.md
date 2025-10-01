# iOS Setup Guide - nofApp

## Overview
This guide covers the steps to set up and test the iOS version of nofApp with live Firebase and RevenueCat integrations.

## Prerequisites
- macOS with Xcode 15+ installed
- Flutter SDK 3.29.x
- iOS Simulator or physical iOS device
- RevenueCat iOS SDK key
- Firebase configuration files (already in repo)

## Setup Steps

### 1. Install Dependencies

```bash
cd /path/to/nofapp
flutter pub get
cd ios
pod install
cd ..
```

### 2. Configure Xcode Project

Open the project in Xcode:
```bash
open ios/Runner.xcworkspace
```

**Important:** Always open `Runner.xcworkspace`, NOT `Runner.xcodeproj`

#### Add GoogleService-Info.plist to Xcode:
1. In Xcode, right-click on the `Runner` folder in the project navigator
2. Select "Add Files to Runner..."
3. Navigate to `ios/Runner/GoogleService-Info.plist`
4. Check "Copy items if needed"
5. Ensure "Runner" target is checked
6. Click "Add"

#### Enable In-App Purchase Capability:
1. Select the Runner project in the navigator
2. Select the Runner target
3. Go to "Signing & Capabilities" tab
4. Click "+ Capability"
5. Add "In-App Purchase"

#### Verify Bundle Identifier:
1. In "General" tab, ensure Bundle Identifier is: `com.nofapp.app`
2. This must match your RevenueCat configuration

#### Configure iOS Version:
1. In "General" tab, set Deployment Target to: `iOS 13.0`

### 3. Configure App Icons

The app uses multiple icon variants for iOS:

**Asset Catalog Structure:**
- `AppIcon` - Main app icon
- `AppIcon-Dark` - Dark mode variant
- `AppIcon-Glass` - Glass/liquid effect variant
- `AppIcon-Tinted` - Monochrome tinted variant

To configure in Xcode:
1. Open `Assets.xcassets/AppIcon.appiconset`
2. Drag icon files from `assets/icons/ios/` to appropriate slots
3. Repeat for each icon variant

**Icon Requirements:**
- Light mode: `assets/icons/ios/ios light mode.png`
- Dark mode: `assets/icons/ios/ios dark mode.png`
- Glass: `assets/icons/ios/glass icon.png`
- Tinted: Uses monochrome glyph for dynamic tinting

### 4. Build and Run

#### Development Build (with RevenueCat):
```bash
flutter clean
flutter pub get
flutter run --dart-define=RC_IOS_SDK_KEY=your_ios_sdk_key_here
```

#### Development Build (without RevenueCat - stub mode):
```bash
flutter run
```

#### Release Build:
```bash
flutter build ios --release --dart-define=RC_IOS_SDK_KEY=your_ios_sdk_key_here
```

## Testing Checklist

### Authentication Flows
- [ ] Onboarding screen displays correctly
- [ ] Sign up with email/password works
- [ ] Login with email/password works
- [ ] Guest mode works
- [ ] Password reset flow works
- [ ] Error states display properly

### Profile System
- [ ] Avatar picker displays free avatars
- [ ] Avatar picker displays premium avatars (locked for free users)
- [ ] Tapping locked avatar opens paywall
- [ ] Daily check-in increments streak
- [ ] Streak counter updates correctly
- [ ] Medal progress displays correctly

### Feed System
- [ ] Global feed loads posts
- [ ] Create post works
- [ ] React to post works (like, support, celebrate)
- [ ] Post cards display user avatar, medal, streak, progress bar
- [ ] Feed refreshes correctly

### Guild System (Premium Feature)
- [ ] Free user sees guild screen with CTA
- [ ] Free user tapping Create/Join opens paywall
- [ ] Premium user can create guild
- [ ] Premium user can join guild
- [ ] Guild admin sees options icon
- [ ] Guild feed works correctly
- [ ] Guild members list displays

### Premium/IAP Flow
- [ ] Paywall displays offerings from RevenueCat
- [ ] Monthly subscription appears: `nofapp_premium_monthly`
- [ ] Yearly subscription appears: `nofapp_premium_yearly`
- [ ] Sandbox purchase flow works
- [ ] After purchase, `premium` entitlement becomes active
- [ ] Premium avatars unlock after purchase
- [ ] Guild create/join unlocks after purchase
- [ ] Restore purchases works

### UI/UX Polish
- [ ] Light/dark theme switching works
- [ ] All icons display correctly (light, dark, glass, tinted)
- [ ] Smooth scrolling, no jank
- [ ] Tap targets ≥44px
- [ ] Accessibility labels present
- [ ] Respects "Reduce Motion" setting
- [ ] Proper keyboard handling
- [ ] Safe area insets respected

### Performance
- [ ] App launches quickly (< 3 seconds)
- [ ] Images load efficiently (lazy loading)
- [ ] No memory leaks
- [ ] Smooth 60fps animations
- [ ] Network requests have proper timeouts

## RevenueCat Sandbox Testing

### Setup Sandbox Tester:
1. Go to App Store Connect
2. Users and Access > Sandbox Testers
3. Add a new sandbox tester account
4. Sign out of App Store on device/simulator
5. Run the app and trigger a purchase
6. Sign in with sandbox tester credentials when prompted

### Testing Purchase Flow:
1. Launch app with RevenueCat key
2. Navigate to Profile or Guilds
3. Trigger paywall (tap locked avatar or Create Guild)
4. Verify offerings display correctly
5. Purchase monthly or yearly subscription
6. Verify purchase completes successfully
7. Check that `premium` entitlement is active
8. Verify premium features unlock immediately

### Testing Restore Purchases:
1. Complete a purchase as above
2. Delete and reinstall the app
3. Login with same account
4. Navigate to paywall
5. Tap "Restore Purchases"
6. Verify premium status restores correctly

## Troubleshooting

### Firebase Issues

**Problem:** "Firebase initialization failed"
**Solution:** 
- Verify `GoogleService-Info.plist` is added to Xcode project
- Check that Bundle ID matches: `com.nofapp.app`
- Clean build: `flutter clean && cd ios && pod install`

### RevenueCat Issues

**Problem:** "RevenueCat API key not provided"
**Solution:**
- Ensure you're passing SDK key: `--dart-define=RC_IOS_SDK_KEY=your_key`
- Verify key starts with `appl_` (Apple/iOS key)
- Check RevenueCat Dashboard for correct key

**Problem:** "No offerings available"
**Solution:**
- Verify products are configured in RevenueCat Dashboard
- Check product IDs match: `nofapp_premium_monthly`, `nofapp_premium_yearly`
- Ensure products are attached to entitlement: `premium`
- Wait a few minutes for RevenueCat cache to update

**Problem:** "Purchase failed"
**Solution:**
- Verify In-App Purchase capability is enabled
- Check sandbox tester is signed in
- Ensure products are in "Ready to Submit" status in App Store Connect
- Try different sandbox tester account

### Build Issues

**Problem:** "Pod install failed"
**Solution:**
```bash
cd ios
pod deintegrate
pod install --repo-update
```

**Problem:** "DT_TOOLCHAIN_DIR cannot be used to evaluate LIBRARY_SEARCH_PATHS"
**Solution:**
- Update CocoaPods: `sudo gem install cocoapods`
- Update pods: `cd ios && pod update`
- Clean build: `flutter clean`

**Problem:** "Module 'firebase_core' not found"
**Solution:**
```bash
flutter clean
rm -rf ios/Pods ios/Podfile.lock
cd ios && pod install
cd ..
flutter pub get
```

## Environment Variables

The app uses `--dart-define` for secure key management:

```bash
# iOS Development
flutter run --dart-define=RC_IOS_SDK_KEY=appl_xxxxx

# iOS Release Build
flutter build ios --release --dart-define=RC_IOS_SDK_KEY=appl_xxxxx

# For CI/CD
flutter build ipa \
  --dart-define=RC_IOS_SDK_KEY=appl_xxxxx \
  --export-options-plist=ios/ExportOptions.plist
```

## Next Steps

After iOS is working:
1. Generate release IPA
2. Upload to TestFlight
3. Invite beta testers
4. Collect feedback
5. Move to Android setup (after Play Console upload)

## Notes

- **Android:** Android setup is pending until an .apk is uploaded to Play Console
- **Stub Mode:** App runs without RevenueCat key but with limited premium features (mocked)
- **Firebase:** All Firebase operations are now live (Auth, Firestore)
- **Entitlement:** The premium entitlement name is `premium` (not customizable)
- **Product IDs:** Monthly=`nofapp_premium_monthly`, Yearly=`nofapp_premium_yearly`

## Support

For issues:
1. Check Firebase Console for auth/database errors
2. Check RevenueCat Dashboard for IAP errors
3. Review Xcode console logs for detailed error messages
4. Use Flutter DevTools for performance debugging
