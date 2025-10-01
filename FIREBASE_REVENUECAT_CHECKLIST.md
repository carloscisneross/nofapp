# Firebase & RevenueCat Integration Checklist

## ✅ Completed by AI Agent

### Firebase Integration
- [x] Created `lib/firebase/firebase_options.dart` with live config
  - Project ID: `nofapp-65297`
  - iOS Bundle ID: `com.nofapp.app`
  - Android Package: `com.nofapp.app`
  
- [x] Created `ios/Runner/GoogleService-Info.plist` for iOS
  - API Key configured
  - Project ID configured
  - Bundle ID matches app
  
- [x] Updated `lib/firebase/firebase_bootstrap.dart`
  - Removed stub/conditional logic
  - Now uses live `DefaultFirebaseOptions.currentPlatform`
  - Proper error handling maintained
  
- [x] Updated `lib/main.dart`
  - Firebase initialization before app start
  - RevenueCat initialization after Firebase

### RevenueCat Integration
- [x] Updated `lib/data/services/premium_service.dart`
  - Changed to use `RC_IOS_SDK_KEY` env variable
  - Added `entitlementId: 'premium'` to config
  - Updated `isPremium` to check for `premium` entitlement specifically
  - Products: `nofapp_premium_monthly`, `nofapp_premium_yearly`
  
- [x] Verified premium gating across features
  - Avatar picker uses `isPremiumProvider`
  - Guild creation uses `isPremiumProvider`
  - Guild joining uses `isPremiumProvider`
  - Paywall modal triggers correctly

### iOS Project Configuration
- [x] Created `ios/Podfile` with proper configuration
  - Minimum iOS 13.0
  - Flutter plugins support
  - Xcode 15+ compatibility

### Documentation
- [x] Created `IOS_SETUP.md` - Complete iOS setup guide
- [x] Created `E2E_TEST_PLAN.md` - Comprehensive testing guide
- [x] Created `INTEGRATION_SUMMARY.md` - Integration overview
- [x] Created this checklist
- [x] Updated `README.md` with live status

---

## ⏳ User Action Required

### 1. Install iOS Dependencies
```bash
cd /path/to/nofapp
flutter pub get
cd ios
pod install
cd ..
```

**Why:** Install Firebase, RevenueCat, and other iOS dependencies via CocoaPods.

**Expected Output:**
```
Analyzing dependencies
Downloading dependencies
Installing Firebase...
Installing RevenueCat...
Generating Pods project
Pod installation complete!
```

### 2. Configure Xcode Project

#### A. Open Workspace (Not Project!)
```bash
cd ios
open Runner.xcworkspace
```

⚠️ **Critical:** Open `Runner.xcworkspace`, NOT `Runner.xcodeproj`

#### B. Add GoogleService-Info.plist
1. In Xcode Project Navigator, right-click `Runner` folder
2. Select "Add Files to Runner..."
3. Navigate to `ios/Runner/GoogleService-Info.plist`
4. ✅ Check "Copy items if needed"
5. ✅ Ensure "Runner" target is checked
6. Click "Add"

**Verify:** File appears in Xcode under Runner folder with proper target membership

#### C. Enable In-App Purchase
1. Select Runner project in navigator
2. Select Runner target
3. Go to "Signing & Capabilities" tab
4. Click "+ Capability" button
5. Search for and add "In-App Purchase"

**Verify:** "In-App Purchase" appears in capabilities list

#### D. Verify Bundle Identifier
1. In "General" tab, check Bundle Identifier
2. Should be: `com.nofapp.app`
3. Must match Firebase and RevenueCat configuration

**Verify:** Matches exactly (case-sensitive)

#### E. Set Deployment Target
1. In "General" tab, find "Minimum Deployments"
2. Set to: `iOS 13.0`

**Verify:** Matches Podfile setting

#### F. Configure App Icons (Optional but Recommended)
1. Open `Assets.xcassets` in Xcode
2. For each AppIcon variant (Light, Dark, Glass, Tinted):
   - Drag appropriate images from `assets/icons/ios/`
   - Ensure all required sizes are filled

**Verify:** All icon slots filled, no warnings

### 3. Build and Run (First Time)

#### A. Clean Build
```bash
flutter clean
flutter pub get
```

#### B. Run with RevenueCat Key
```bash
flutter run --dart-define=RC_IOS_SDK_KEY=your_actual_ios_sdk_key_here
```

**Replace** `your_actual_ios_sdk_key_here` with the real iOS SDK key from RevenueCat Dashboard.

**Expected Console Output:**
```
Launching lib/main.dart on iPhone...
Running pod install...
Running Xcode build...
✓ Built build/ios/Debug-iphonesimulator/Runner.app

Firebase initialized successfully
Project: nofapp-65297
RevenueCat initialized successfully
Premium status: false
```

#### C. Verify App Launches
- [ ] App opens without crashes
- [ ] No red error screens
- [ ] Onboarding or home screen appears
- [ ] Console shows successful Firebase initialization
- [ ] Console shows successful RevenueCat initialization

### 4. Run Sandbox Purchase Tests

#### A. Create Sandbox Tester
1. Go to App Store Connect
2. Navigate to Users and Access > Sandbox Testers
3. Click "+" to add new tester
4. Fill in details (use unique email like `test+sandbox1@yourdomain.com`)
5. Choose region (recommend: United States)
6. Save

#### B. Sign Out of App Store on Device
1. On iOS device/simulator
2. Settings > App Store > Sign Out
3. Do NOT sign in yet

#### C. Test Purchase Flow
1. Run app on device/simulator
2. Navigate to trigger paywall (premium avatar or guild)
3. Tap "Subscribe" on monthly or yearly
4. When prompted, sign in with sandbox tester credentials
5. Complete purchase
6. Verify premium features unlock

**Expected:**
- [ ] Offerings load from RevenueCat
- [ ] Both monthly and yearly products appear
- [ ] Sandbox purchase completes
- [ ] `premium` entitlement becomes active
- [ ] Premium avatars unlock
- [ ] Guild features unlock

### 5. Run Full E2E Tests

Follow `E2E_TEST_PLAN.md` to systematically test:
- [ ] Section 1: Authentication (signup, login, guest, reset)
- [ ] Section 2: Profile System (avatar, streak, medals)
- [ ] Section 3: Feed System (posts, reactions, refresh)
- [ ] Section 4: Guild System (create, join, admin, free vs premium)
- [ ] Section 5: Premium/IAP (paywall, purchase, restore)
- [ ] Section 6: UI/UX (themes, icons, accessibility, performance)
- [ ] Section 7: Data Persistence (restart, network interruption)

**Use the test results template** in E2E_TEST_PLAN.md to document findings.

---

## 🔍 Verification Steps

### Quick Health Check
Run these checks to verify everything is working:

#### 1. Firebase Connection
```dart
// Should see in console:
✓ Firebase initialized successfully
✓ Project: nofapp-65297
```

**Test:** Try signup/login - should work without errors

#### 2. RevenueCat Connection
```dart
// Should see in console:
✓ RevenueCat initialized successfully
✓ Premium status: false (or true if subscription active)
```

**Test:** Open paywall - should see real offerings with prices

#### 3. Firestore Operations
**Test:** 
- Create account
- Update profile
- Create post
- Check Firebase Console for data

#### 4. Premium Gating
**Test:**
- As free user, tap premium avatar → paywall opens
- As free user, tap Create Guild → paywall opens
- Complete purchase → features unlock immediately

---

## 📊 Success Criteria

All of the following should be true:

### Build & Launch
- [ ] `pod install` completes without errors
- [ ] Xcode build succeeds
- [ ] App launches on simulator/device
- [ ] No crashes or red error screens

### Firebase
- [ ] Console shows "Firebase initialized successfully"
- [ ] Signup creates user in Firebase Auth
- [ ] Firestore operations work (profile, posts, guilds)
- [ ] Firebase Console shows data being created

### RevenueCat
- [ ] Console shows "RevenueCat initialized successfully"
- [ ] Paywall displays 2 offerings (monthly, yearly)
- [ ] Prices load from App Store
- [ ] Sandbox purchase completes successfully
- [ ] RevenueCat Dashboard shows transaction

### Premium Features
- [ ] Free user sees locked premium avatars
- [ ] Free user redirected to paywall for guild features
- [ ] After purchase, premium avatars unlock
- [ ] After purchase, guild features unlock
- [ ] `premium` entitlement shows as active

### E2E Tests
- [ ] All auth flows work
- [ ] Profile system functions correctly
- [ ] Feed system works (create, react, view)
- [ ] Guild system properly gated and functional for premium
- [ ] IAP flow completes end-to-end
- [ ] UI/UX polish items verified

---

## ❌ Common Issues & Solutions

### Issue: "GoogleService-Info.plist not found"
**Solution:** 
- Ensure file is added to Xcode project (not just file system)
- Check target membership includes "Runner"
- Clean and rebuild

### Issue: "RevenueCat API key not provided"
**Solution:**
- Verify `--dart-define=RC_IOS_SDK_KEY=...` is in run command
- Check key starts with `appl_` for iOS
- Ensure no typos in key

### Issue: "No offerings available"
**Solution:**
- Check RevenueCat Dashboard for products
- Verify both products attached to `premium` entitlement
- Wait 2-3 minutes for RevenueCat cache
- Try force-closing and reopening app

### Issue: "Purchase failed - Invalid Product ID"
**Solution:**
- Ensure products exist in App Store Connect
- Products must be "Ready to Submit" status
- Verify product IDs match exactly:
  - `nofapp_premium_monthly`
  - `nofapp_premium_yearly`

### Issue: "Pod install fails"
**Solution:**
```bash
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
```

### Issue: "Xcode build fails"
**Solution:**
```bash
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter pub get
```

---

## 📝 Test Results

After completing all user actions:

### Date: _______________
### Tester: _______________
### Device: _______________

### Results:
- [ ] Pod install: ✅ / ❌
- [ ] Xcode configuration: ✅ / ❌
- [ ] App launches: ✅ / ❌
- [ ] Firebase working: ✅ / ❌
- [ ] RevenueCat working: ✅ / ❌
- [ ] Sandbox purchase: ✅ / ❌
- [ ] E2E tests: ✅ / ❌

### Notes:
_____________________________________________
_____________________________________________
_____________________________________________

---

## ✅ Final Sign-Off

When all items above are complete and working:
- [ ] iOS app fully functional
- [ ] All E2E tests passing
- [ ] Ready for TestFlight upload
- [ ] Documentation reviewed and understood

**Signed:** _______________
**Date:** _______________

---

## 🎯 Next Phase

After successful iOS testing:
1. Prepare for TestFlight beta
2. Generate release build
3. Upload IPA to App Store Connect
4. Invite beta testers
5. Collect feedback
6. Begin Android setup (after Play Console)
