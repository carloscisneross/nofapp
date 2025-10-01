# Android Testing Checklist - nofApp (Base Features)

## Overview
This checklist covers testing Android functionality **without premium features**. RevenueCat integration will be completed after Play Console setup.

---

## ✅ What's Ready for Testing

### Firebase Integration
- ✅ `google-services.json` configured
- ✅ Package name: `com.nofapp.app`
- ✅ Firebase Auth enabled
- ✅ Cloud Firestore enabled

### App Features (Non-Premium)
- ✅ Authentication (email, password, guest)
- ✅ Profile system (free avatars only)
- ✅ Streak tracking & daily check-in
- ✅ Medal progression
- ✅ Feed system (posts, reactions)
- ✅ Guild viewing (premium creation/join disabled)

### Build Configuration
- ✅ Gradle 8.10.2
- ✅ AGP 8.7.0
- ✅ compileSdk 34
- ✅ minSdk 23
- ✅ targetSdk 34
- ✅ NDK 27.0.12077973
- ✅ Adaptive icons configured

---

## ⏳ Not Yet Available

### RevenueCat / Premium Features
- ❌ RevenueCat SDK key (pending Play Console)
- ❌ Premium avatars (will show locked)
- ❌ Guild creation (will show disabled/stub)
- ❌ Guild joining (will show disabled/stub)
- ❌ Premium paywall (non-functional stub)

**Note:** Premium features will be enabled after you:
1. Upload first .apk/.aab to Play Console
2. Set up Google Play billing
3. Create products in RevenueCat
4. Provide Android SDK key

---

## Setup Instructions

### Prerequisites
- Android Studio with SDK 34
- Android device or emulator (API 23+)
- Flutter SDK 3.29.x
- Java 17+

### Build Commands

#### Clean Build
```bash
cd /path/to/nofapp
flutter clean
flutter pub get
```

#### Run on Android (without RevenueCat)
```bash
flutter run -d android
```

#### Run on Android (with future RevenueCat key)
```bash
flutter run -d android --dart-define=RC_ANDROID_SDK_KEY=goog_xxxxx
```

#### Generate APK (Debug)
```bash
flutter build apk --debug
```

#### Generate AAB (Release - for Play Console)
```bash
flutter build appbundle --release
```

---

## Testing Checklist

### 1. Build & Launch Tests

#### 1.1 Clean Build
**Steps:**
1. Run `flutter clean`
2. Run `flutter pub get`
3. Run `flutter build apk --debug`

**Expected:**
- [ ] Build completes without errors
- [ ] No Gradle errors
- [ ] APK generated successfully

#### 1.2 App Launch
**Steps:**
1. Install APK on device/emulator
2. Launch app
3. Observe splash screen and initial load

**Expected:**
- [ ] App installs successfully
- [ ] App launches without crashes
- [ ] Splash screen appears
- [ ] Onboarding or home screen loads
- [ ] No red error screens

#### 1.3 Firebase Connection
**Steps:**
1. Check logcat for Firebase initialization
2. Filter logs: `adb logcat | grep -i firebase`

**Expected Output:**
```
Firebase initialized successfully
Project: nofapp-65297
```

#### 1.4 RevenueCat Status
**Steps:**
1. Check logcat for RevenueCat messages
2. Filter logs: `adb logcat | grep -i revenuecat`

**Expected Output:**
```
RevenueCat API key not provided - premium features will be mocked
```

---

### 2. Authentication Tests

#### 2.1 Sign Up Flow
**Steps:**
1. Launch app to onboarding
2. Tap "Sign Up"
3. Enter email: `test+android@example.com`
4. Enter password: `TestPass123!`
5. Tap "Create Account"

**Expected:**
- [ ] Form validation works
- [ ] Loading indicator shows
- [ ] Account created successfully
- [ ] Redirected to home/profile
- [ ] Firebase Console shows new user

#### 2.2 Login Flow
**Steps:**
1. Sign out from current account
2. Tap "Login"
3. Enter credentials from 2.1
4. Tap "Login"

**Expected:**
- [ ] Login successful
- [ ] Redirected to home/profile
- [ ] User data loads correctly

#### 2.3 Guest Mode
**Steps:**
1. From login screen, tap "Continue as Guest"

**Expected:**
- [ ] Guest account created
- [ ] Basic features accessible
- [ ] Can use app without email

#### 2.4 Password Reset
**Steps:**
1. From login, tap "Forgot Password?"
2. Enter email address
3. Tap "Send Reset Link"
4. Check email inbox

**Expected:**
- [ ] Reset email sent message appears
- [ ] Email received with reset link
- [ ] Link works to reset password

#### 2.5 Sign Out
**Steps:**
1. Navigate to Settings/Profile
2. Tap "Sign Out"

**Expected:**
- [ ] User signed out successfully
- [ ] Redirected to login/onboarding
- [ ] Local data cleared appropriately

---

### 3. Profile System Tests

#### 3.1 Profile Display
**Steps:**
1. Navigate to Profile screen
2. Observe all elements

**Expected:**
- [ ] User avatar displays
- [ ] Username/email visible
- [ ] Streak counter shows
- [ ] Medal displays
- [ ] Progress bar shows completion %

#### 3.2 Avatar Selection - Free Only
**Steps:**
1. Tap on avatar to open picker
2. Navigate to "Free" avatars
3. Select a free avatar
4. Confirm selection

**Expected:**
- [ ] Avatar picker opens
- [ ] Free avatars displayed
- [ ] Selected avatar highlighted
- [ ] Selection saves successfully
- [ ] Profile updates immediately

#### 3.3 Premium Avatars (Locked)
**Steps:**
1. Open avatar picker
2. Navigate to "Premium" section
3. Observe premium avatars

**Expected:**
- [ ] Premium avatars show lock icon
- [ ] Tapping locked avatar shows message
- [ ] Cannot select premium avatar
- [ ] Message indicates feature unavailable

**Note:** Premium unlock will be available after Play Console setup.

#### 3.4 Daily Check-In
**Steps:**
1. Navigate to Profile
2. Tap "Check In" button (if available)
3. Observe streak counter

**Expected:**
- [ ] Check-in button appears when available
- [ ] Tapping increments streak
- [ ] Visual feedback shown
- [ ] Streak counter updates (+1)
- [ ] Button disabled after use
- [ ] Cannot check in twice same day

#### 3.5 Streak Persistence
**Steps:**
1. Check in today
2. Force close app
3. Reopen app
4. Check streak counter

**Expected:**
- [ ] Streak persists after restart
- [ ] Check-in status preserved
- [ ] Counter shows correct value

#### 3.6 Medal Progress
**Steps:**
1. View current medal
2. Perform actions (posts, check-ins)
3. Observe progress bar

**Expected:**
- [ ] Medal displays correctly
- [ ] Progress bar shows percentage
- [ ] Progress updates with actions
- [ ] Medal upgrades when threshold reached

---

### 4. Feed System Tests

#### 4.1 Feed Display
**Steps:**
1. Navigate to Feed screen
2. Scroll through posts

**Expected:**
- [ ] Feed loads successfully
- [ ] Posts display chronologically
- [ ] Each post shows avatar, username, content
- [ ] Post cards show medal badge
- [ ] Post cards show streak counter
- [ ] Post cards show progress bar
- [ ] Smooth scrolling

#### 4.2 Create Post
**Steps:**
1. Tap "Create Post" button
2. Enter text: "Testing Android feed #test"
3. Tap "Post"

**Expected:**
- [ ] Create post screen opens
- [ ] Text input works
- [ ] Character count displays
- [ ] Loading indicator during creation
- [ ] Post appears in feed immediately
- [ ] Post shows current avatar
- [ ] Post shows current medal
- [ ] Post shows current streak

#### 4.3 React to Post
**Steps:**
1. Find a post in feed
2. Tap reaction (like, support, celebrate)
3. Tap same reaction again (unreact)

**Expected:**
- [ ] Reaction buttons visible
- [ ] Tapping updates UI immediately
- [ ] Reaction count increments
- [ ] User's reaction highlighted
- [ ] Tapping again removes reaction
- [ ] Count decrements

#### 4.4 Pull to Refresh
**Steps:**
1. In feed, pull down to refresh
2. Wait for refresh to complete

**Expected:**
- [ ] Pull gesture works
- [ ] Loading indicator shows
- [ ] Feed updates with new posts
- [ ] Scroll position maintained

---

### 5. Guild System Tests (View Only)

#### 5.1 Guild Screen Access
**Steps:**
1. Navigate to Guilds screen
2. Observe UI

**Expected:**
- [ ] Guild screen accessible
- [ ] Shows "Premium Feature" indicator
- [ ] Displays explanation of guilds
- [ ] Shows disabled/locked state

#### 5.2 Create Guild (Disabled)
**Steps:**
1. Tap "Create Guild" button
2. Observe response

**Expected:**
- [ ] Button shows disabled state OR
- [ ] Tapping shows "Coming Soon" message OR
- [ ] Message indicates premium required
- [ ] Cannot proceed with creation

**Note:** After Play Console setup, this will trigger paywall.

#### 5.3 Join Guild (Disabled)
**Steps:**
1. Tap "Join Guild" button
2. Observe response

**Expected:**
- [ ] Button shows disabled state OR
- [ ] Message indicates feature unavailable OR
- [ ] Message indicates premium required
- [ ] Cannot proceed with joining

**Note:** After Play Console setup, this will trigger paywall.

---

### 6. UI/UX Tests

#### 6.1 Light/Dark Theme
**Steps:**
1. Go to Settings
2. Toggle theme
3. Navigate through screens

**Expected:**
- [ ] Theme switches immediately
- [ ] All screens adapt to theme
- [ ] Colors appropriate
- [ ] Text readable in both themes
- [ ] Icons adapt correctly

#### 6.2 App Icon
**Steps:**
1. Return to home screen
2. Observe app icon
3. Enable dark mode
4. Check icon again

**Expected:**
- [ ] Adaptive icon displays
- [ ] Light mode icon correct
- [ ] Dark mode icon correct
- [ ] Icon looks good on launcher

#### 6.3 Navigation
**Steps:**
1. Navigate between screens
2. Use back button
3. Use bottom navigation (if any)

**Expected:**
- [ ] Navigation smooth
- [ ] Back button works correctly
- [ ] No navigation errors
- [ ] Proper back stack handling

#### 6.4 Keyboard Handling
**Steps:**
1. Tap text input field
2. Keyboard appears
3. Type text
4. Dismiss keyboard

**Expected:**
- [ ] Keyboard appears smoothly
- [ ] Input not obscured by keyboard
- [ ] Typing works correctly
- [ ] Dismisses properly
- [ ] Screen adjusts appropriately

#### 6.5 Performance
**Tests:**
- [ ] App launches quickly (< 3 seconds)
- [ ] Scrolling is smooth (60fps)
- [ ] No dropped frames
- [ ] Images load efficiently
- [ ] No memory leaks (use profiler)

---

### 7. Data Persistence Tests

#### 7.1 App Restart
**Steps:**
1. Use app normally (login, create post, etc.)
2. Force stop app
3. Relaunch app

**Expected:**
- [ ] User remains logged in
- [ ] Profile data persists
- [ ] Streak data persists
- [ ] Medal progress persists
- [ ] Selected avatar persists

#### 7.2 Network Interruption
**Steps:**
1. Use app normally
2. Enable airplane mode
3. Try to perform actions
4. Re-enable network

**Expected:**
- [ ] App doesn't crash
- [ ] Appropriate error messages
- [ ] Cached data still accessible
- [ ] Actions queue and retry
- [ ] Full functionality restored when online

#### 7.3 Cache Management
**Steps:**
1. Use app, load images
2. Go to Settings > Apps > nofApp
3. Clear cache (not data)
4. Reopen app

**Expected:**
- [ ] App works after cache clear
- [ ] User still logged in
- [ ] Data intact
- [ ] Images reload correctly

---

### 8. Edge Cases & Error Handling

#### 8.1 Invalid Input
**Tests:**
- [ ] Invalid email format shows error
- [ ] Weak password shows error
- [ ] Empty required fields show error
- [ ] Special characters handled correctly

#### 8.2 Network Errors
**Tests:**
- [ ] Timeout errors handled gracefully
- [ ] Connection errors show appropriate message
- [ ] Retry mechanisms work
- [ ] Offline mode functions where appropriate

#### 8.3 Authentication Errors
**Tests:**
- [ ] Wrong password shows error
- [ ] Non-existent account shows error
- [ ] Already used email shows error
- [ ] All errors user-friendly

---

## Known Limitations (Until Play Console Setup)

### Premium Features
1. **Premium Avatars:** Visible but locked, cannot select
2. **Guild Creation:** Disabled or shows "coming soon"
3. **Guild Joining:** Disabled or shows "coming soon"
4. **Paywall:** Non-functional stub (no actual offerings)

**These are expected behaviors** until RevenueCat Android is configured.

### What Works Fully
- ✅ All authentication flows
- ✅ Free avatar selection
- ✅ Streak tracking & check-ins
- ✅ Medal progression
- ✅ Feed (create, view, react)
- ✅ Profile management
- ✅ Theme switching
- ✅ Data persistence

---

## Test Results Template

### Test Session Info
- **Date:** [Date]
- **Tester:** [Name]
- **Device:** [Model, Android version]
- **Build:** [Version number]
- **APK Type:** [Debug/Release]

### Results Summary
- **Total Tests:** [X]
- **Passed:** [X]
- **Failed:** [X]
- **Blocked:** [X]
- **Skipped (Premium):** [X]

### Build & Launch
- [ ] Clean build: ✅ / ❌
- [ ] App install: ✅ / ❌
- [ ] App launch: ✅ / ❌
- [ ] Firebase init: ✅ / ❌
- [ ] No crashes: ✅ / ❌

### Authentication
- [ ] Sign up: ✅ / ❌
- [ ] Login: ✅ / ❌
- [ ] Guest mode: ✅ / ❌
- [ ] Password reset: ✅ / ❌
- [ ] Sign out: ✅ / ❌

### Profile System
- [ ] Profile display: ✅ / ❌
- [ ] Free avatar selection: ✅ / ❌
- [ ] Premium avatars locked: ✅ / ❌
- [ ] Daily check-in: ✅ / ❌
- [ ] Streak tracking: ✅ / ❌
- [ ] Medal progress: ✅ / ❌

### Feed System
- [ ] Feed display: ✅ / ❌
- [ ] Create post: ✅ / ❌
- [ ] React to post: ✅ / ❌
- [ ] Pull to refresh: ✅ / ❌

### Guild System
- [ ] View guild screen: ✅ / ❌
- [ ] Create disabled: ✅ / ❌
- [ ] Join disabled: ✅ / ❌

### UI/UX
- [ ] Theme switching: ✅ / ❌
- [ ] App icon: ✅ / ❌
- [ ] Navigation: ✅ / ❌
- [ ] Keyboard handling: ✅ / ❌
- [ ] Performance: ✅ / ❌

### Data Persistence
- [ ] App restart: ✅ / ❌
- [ ] Network interruption: ✅ / ❌
- [ ] Cache clear: ✅ / ❌

### Issues Found
| Issue | Description | Severity | Status |
|-------|-------------|----------|--------|
| 1     |             |          |        |
| 2     |             |          |        |

### Notes
[Any additional observations]

---

## Troubleshooting

### Build Errors

**Error: "Namespace not specified"**
```
Solution: Already fixed - namespace is com.nofapp.app
```

**Error: "Google services plugin not found"**
```bash
# Verify settings.gradle has:
id "com.google.gms.google-services" version "4.4.2" apply false
```

**Error: "Package name mismatch"**
```
Solution: Verify google-services.json package_name matches com.nofapp.app
```

### Runtime Errors

**Error: "Firebase initialization failed"**
```
- Check google-services.json is in android/app/
- Verify package name matches
- Check Firebase Console project exists
```

**Error: "RevenueCat errors"**
```
Expected: RevenueCat will show "API key not provided" message
This is normal until Play Console setup
```

### Gradle Issues

**Error: "Gradle daemon timeout"**
```bash
# Increase timeout
echo "org.gradle.daemon.idletimeout=3600000" >> gradle.properties
```

**Error: "Out of memory"**
```bash
# Increase heap size
echo "org.gradle.jvmargs=-Xmx4096m" >> gradle.properties
```

---

## After Play Console Setup

Once you upload the first .apk/.aab and configure Play Console:

### 1. RevenueCat Android Setup
- Create products in RevenueCat Dashboard
- Link products to Google Play
- Get Android SDK key

### 2. Update App
- Add `--dart-define=RC_ANDROID_SDK_KEY=goog_xxxxx` to build commands
- Test premium features
- Verify IAP flow works

### 3. Full Premium Testing
- Run complete E2E test plan
- Test sandbox purchases
- Verify entitlement unlock
- Test restore purchases

---

## Success Criteria

### Base Features (Now)
- [ ] App builds and runs on Android
- [ ] Firebase Auth works
- [ ] Firestore operations work
- [ ] All non-premium features functional
- [ ] No crashes or major bugs
- [ ] UI/UX polished and responsive

### Premium Features (After Play Console)
- [ ] RevenueCat initializes
- [ ] Offerings display
- [ ] Purchases complete
- [ ] Entitlements unlock
- [ ] Premium features accessible

---

## Next Steps

### Immediate
1. Build APK: `flutter build apk --debug`
2. Install on device
3. Run through this checklist
4. Document any issues

### Short Term
1. Fix any issues found
2. Generate release AAB
3. Upload to Play Console (closed testing)
4. Set up Google Play billing

### After Play Console
1. Configure RevenueCat Android
2. Add SDK key to app
3. Test premium features
4. Release to testers

---

**Ready to test Android base features!** 🚀

All core functionality (auth, profiles, streaks, feeds) should work. Premium features will be enabled after Play Console setup.
