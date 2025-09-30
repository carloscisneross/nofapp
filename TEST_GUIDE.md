# nofApp Test Guide - Phase 4 Complete

## Pre-Test Setup

### Environment Verification
```bash
# Verify Flutter version
flutter --version  # Should be 3.29.x

# Check dependencies
flutter pub get
flutter pub deps

# Static analysis
flutter analyze --fatal-infos
dart format . --set-exit-if-changed
```

### Build Verification
```bash
# Android
flutter build apk --debug
flutter build apk --release

# iOS (on macOS)
flutter build ios --debug --no-codesign
```

## Core Feature Testing

### 1. Onboarding & First Run
**Test Flow:**
- [ ] Launch app for first time
- [ ] Verify Material 3 theming (light/dark modes)
- [ ] Check bottom navigation: Feed, Guild, Profile tabs
- [ ] Verify app icons display correctly in device settings

**Expected Results:**
- Clean onboarding screen with nofApp branding
- Smooth navigation between tabs
- No crashes or visual glitches
- Icons match provided assets (light/dark variants)

### 2. Authentication System
**Sign Up Flow:**
- [ ] Tap "Create Account" from onboarding
- [ ] Fill email, password, confirm password
- [ ] Submit → should show profile setup screen
- [ ] Choose avatar and display name
- [ ] Complete setup → navigate to feed

**Login Flow:**
- [ ] Login with created account
- [ ] Verify lands on feed screen
- [ ] Profile data persists correctly

**Error Handling:**
- [ ] Invalid email format shows error
- [ ] Password mismatch shows error
- [ ] Network errors display user-friendly messages

### 3. Profile & Avatar System
**Profile Display:**
- [ ] Shows user avatar with edit indicator
- [ ] Displays name, email, premium status
- [ ] Streak widget shows current streak (0 initially)
- [ ] Medal section shows progress (empty initially)

**Avatar Picker:**
- [ ] Tap avatar edit → opens modal with tabs
- [ ] Free tab: all avatars selectable
- [ ] Premium tab: locked avatars show paywall
- [ ] Selection saves and updates profile

**Premium Gating:**
- [ ] Free user selecting premium avatar → shows paywall
- [ ] Paywall has correct copy and CTA buttons
- [ ] "Maybe Later" dismisses paywall
- [ ] Purchase simulation works (stub mode)

### 4. Streak & Medal System
**Check-in Flow:**
- [ ] Tap "Check In" button in profile
- [ ] Success message appears
- [ ] Streak count increments to 1
- [ ] Button changes to "Checked In" state
- [ ] Progress bar updates toward next medal

**Medal Progression:**
- [ ] First check-in awards first medal
- [ ] Medal appears in profile medals section
- [ ] Progress shows path to next medal
- [ ] Thresholds: 1, 3, 5, 7, 10, 14, 21, 30, 60, 90, 180, 365 days

**Edge Cases:**
- [ ] Cannot check in twice same day
- [ ] Streak resets if day gap > 1
- [ ] Network errors handled gracefully

### 5. Feed System
**Feed Header:**
- [ ] Shows user avatar with border
- [ ] Displays name with inline medal
- [ ] Shows current streak with flame icon
- [ ] Progress bar to next medal
- [ ] Next medals preview row

**Post Composer:**
- [ ] Tap area expands to full composer
- [ ] Character limit enforced (280 chars)
- [ ] "Post" button disabled until text entered
- [ ] "Cancel" collapses composer

**Feed Posts:**
- [ ] Posts display with author info
- [ ] Author medal and streak shown inline
- [ ] Timestamp formatted correctly
- [ ] Reaction buttons functional (👍🔥🎉)
- [ ] Guild posts show guild indicator

**Interactions:**
- [ ] Reactions increment/decrement optimistically
- [ ] Network errors revert optimistic changes
- [ ] Smooth scroll performance
- [ ] Pull-to-refresh works

### 6. Guild System
**Free User Experience:**
- [ ] Guild tab shows CTA screen
- [ ] "Create Guild" → triggers premium paywall
- [ ] "Browse Guilds" → triggers premium paywall
- [ ] Paywall copy mentions guild features

**Premium User Experience:**
- [ ] Create guild dialog appears
- [ ] Name and description validation
- [ ] Guild creation succeeds
- [ ] Navigates to guild home screen

**Guild Home Screen:**
- [ ] Header shows guild name, level, member count
- [ ] Guild medal displayed
- [ ] Notification banner if enabled
- [ ] Post composer for guild posts
- [ ] Guild feed displays correctly

**Admin Features:**
- [ ] Options icon visible only to admins
- [ ] Admin screen has guild management
- [ ] Name/description editing works
- [ ] Notification toggle functions
- [ ] Member management placeholder
- [ ] Danger zone (leave/delete guild)

### 7. Premium Integration
**Paywall Triggers:**
- [ ] Premium avatar selection
- [ ] Guild creation attempt (free user)
- [ ] Guild joining attempt (free user)

**Paywall Content:**
- [ ] Premium benefits clearly listed
- [ ] Pricing information displayed
- [ ] "Upgrade to Premium" CTA
- [ ] "Restore Purchases" option
- [ ] "Maybe Later" dismissal

**Purchase Flow (Stub):**
- [ ] Purchase simulation works
- [ ] Premium status updates
- [ ] Previously locked features unlock
- [ ] UI reflects premium status

### 8. Settings & Account Management
**Profile Settings:**
- [ ] Change avatar shortcut works
- [ ] Display name editing functions
- [ ] Email shown (read-only)
- [ ] Theme selection (Light/Dark/System)

**Account Actions:**
- [ ] Sign out confirmation dialog
- [ ] Sign out clears session
- [ ] Delete account warning dialog
- [ ] Account deletion removes data

## Accessibility Testing

### Screen Reader Support
- [ ] Avatar edit button has semantic label
- [ ] Check-in button has descriptive hint
- [ ] Medal widgets have tooltip descriptions
- [ ] Navigation tabs have proper labels

### Touch Targets
- [ ] All interactive elements ≥ 44px tap target
- [ ] Buttons have sufficient padding
- [ ] List items easy to tap
- [ ] No accidental activations

### Visual Accessibility
- [ ] Good contrast ratios in light/dark themes
- [ ] Text scaling works properly
- [ ] Focus indicators visible
- [ ] No information conveyed by color alone

## Performance Testing

### Startup Performance
- [ ] App launches quickly (< 3 seconds)
- [ ] No visible jank during startup
- [ ] Assets load smoothly

### Scroll Performance
- [ ] Feed scrolling is smooth (60fps)
- [ ] Large lists don't cause stutters
- [ ] Images load progressively
- [ ] Memory usage stays reasonable

### Network Resilience
- [ ] Offline state handled gracefully
- [ ] Network timeouts show appropriate errors
- [ ] Retry mechanisms work
- [ ] Optimistic UI reverts on failure

## Platform-Specific Testing

### Android
- [ ] Adaptive icons display correctly
- [ ] Back button navigation works
- [ ] Material 3 theming consistent
- [ ] Build succeeds with specified versions:
  - AGP 8.7.0, Gradle 8.10.2, Kotlin JVM 17

### iOS
- [ ] Light/dark mode icons switch properly
- [ ] Glass/liquid mode icons display
- [ ] Tinted mode shows monochrome variant
- [ ] Navigation feels native
- [ ] Build succeeds on iOS 17/18

## Error Handling & Edge Cases

### Network Errors
- [ ] Connection timeouts show retry option
- [ ] Server errors display user-friendly messages
- [ ] Offline state communicated clearly
- [ ] Background sync works when connectivity restored

### Data Integrity
- [ ] Streak calculations remain accurate
- [ ] Medal awards are consistent
- [ ] Premium status syncs correctly
- [ ] Guild membership stays in sync

### UI Edge Cases
- [ ] Long usernames don't break layout
- [ ] Large avatar images scale properly
- [ ] Empty states show helpful messages
- [ ] Loading states prevent double-taps

## Pre-Production Checklist

### Code Quality
- [ ] `flutter analyze --fatal-infos` passes
- [ ] No use_build_context_synchronously warnings
- [ ] All deprecated APIs updated
- [ ] Proper error handling throughout

### Asset Integration
- [ ] All provided assets properly referenced
- [ ] Icons match exact file paths from repo
- [ ] Avatar/medal assets load correctly
- [ ] No missing asset references

### Configuration
- [ ] Bundle IDs correct: com.carlo.nofapp
- [ ] App name "nofApp" throughout
- [ ] Version numbers set properly
- [ ] Signing configurations ready

### Integration Readiness
- [ ] Firebase stub initialization works
- [ ] RevenueCat placeholder handles missing keys
- [ ] Firestore schema matches data models
- [ ] All required permissions declared

## Firebase Integration Test (When Keys Provided)

### Authentication
- [ ] Replace stub with real Firebase Auth
- [ ] Email/password signup works
- [ ] Login/logout functions properly
- [ ] Password reset emails sent

### Firestore
- [ ] User profiles save to Firestore
- [ ] Streak data persists correctly
- [ ] Guild data syncs properly
- [ ] Posts appear in real-time

### Security Rules
- [ ] Users can only edit own profile
- [ ] Guild admins can modify guild settings
- [ ] Posts require authentication
- [ ] Premium features properly gated

## RevenueCat Integration Test (When Keys Provided)

### Purchase Flow
- [ ] Real offerings load from RevenueCat
- [ ] Purchase flow completes properly
- [ ] Entitlements update correctly
- [ ] Premium features unlock

### Subscription Management
- [ ] Restore purchases works
- [ ] Subscription status syncs
- [ ] Expired subscriptions handled
- [ ] Premium status reflects in UI

---

## Success Criteria

✅ **MVP Complete When:**
- All core features functional without crashes
- Premium gating works as designed
- UI matches provided sketches
- Performance is smooth and responsive
- Accessibility requirements met
- Code quality passes all checks
- Integration points ready for live services

🚀 **Ready for Production When:**
- Firebase integration complete and tested
- RevenueCat integration complete and tested
- End-to-end flows verified
- Platform-specific features working
- App store assets and metadata ready