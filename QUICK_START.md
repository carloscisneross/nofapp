# Quick Start - iOS Testing

## ✅ Integration Complete - Ready for Testing

---

## 30-Second Overview

All Firebase and RevenueCat integration code is complete. You need to:
1. Run `pod install`
2. Configure Xcode
3. Build with RevenueCat key
4. Test the app

Total time: ~2-3 hours

---

## Commands You'll Run

```bash
# 1. Install dependencies
cd /path/to/nofapp
flutter pub get
cd ios && pod install && cd ..

# 2. Open Xcode
cd ios && open Runner.xcworkspace

# 3. Build and run
flutter clean
flutter run --dart-define=RC_IOS_SDK_KEY=appl_your_actual_key
```

---

## In Xcode (5 Actions)

1. Add `GoogleService-Info.plist` to project (right-click Runner > Add Files)
2. Enable "In-App Purchase" capability (Signing & Capabilities tab)
3. Verify Bundle ID: `com.nofapp.app`
4. Set Deployment Target: iOS 13.0
5. Build and run (⌘R)

---

## Expected Console Output

```
Firebase initialized successfully
Project: nofapp-65297
RevenueCat initialized successfully
Premium status: false
```

---

## Quick Test (5 Minutes)

1. **Launch app** → Should open without crashes
2. **Sign up** → Creates Firebase account
3. **Open paywall** → Shows 2 offerings (monthly, yearly)
4. **Purchase** → Use sandbox tester, completes successfully
5. **Check premium** → Avatars and guilds unlock

If all 5 work → Integration successful! ✅

---

## What If Something Breaks?

### "Pod install failed"
```bash
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
```

### "No offerings available"
- Wait 2-3 minutes
- Check RevenueCat Dashboard
- Verify products exist and are active

### "Firebase error"
- Check `GoogleService-Info.plist` is in Xcode project
- Verify Bundle ID matches

### Other issues?
See **INTEGRATION_VERIFICATION.md** (full troubleshooting guide)

---

## Documents Reference

| Document | Purpose | When to Use |
|----------|---------|-------------|
| **QUICK_START.md** (this) | Fast reference | Always start here |
| **INTEGRATION_VERIFICATION.md** | Complete guide | For detailed steps |
| **IOS_SETUP.md** | iOS-specific setup | Xcode configuration |
| **E2E_TEST_PLAN.md** | Testing checklist | Full testing |
| **FIREBASE_REVENUECAT_CHECKLIST.md** | Step-by-step | Systematic approach |

---

## Status Check

### ✅ Done (by AI)
- Firebase integration code
- RevenueCat integration code
- iOS project configuration
- All documentation

### ⏳ Your Turn
- Run pod install
- Configure Xcode
- Build and test
- Report results

---

## Need Help?

After testing, share:
1. Build output (success or errors)
2. Console logs
3. Any error messages
4. Screenshots (if helpful)

I'll help fix any issues! 🛠️

---

## Quick Links

**RevenueCat Dashboard:** https://app.revenuecat.com  
**Firebase Console:** https://console.firebase.google.com/project/nofapp-65297  
**App Store Connect:** https://appstoreconnect.apple.com

---

**You're ready to go!** Follow the commands above and test the app. The integration is complete on the code side. 🚀
