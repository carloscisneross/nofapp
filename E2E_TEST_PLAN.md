# End-to-End Test Plan - nofApp iOS

## Test Environment Setup

### Prerequisites
- iOS device or simulator running iOS 13+
- App built with: `flutter run --dart-define=RC_IOS_SDK_KEY=your_key`
- Sandbox tester account configured in App Store Connect
- Firebase live configuration active
- RevenueCat configured with `premium` entitlement

### Test User Accounts
Create these test scenarios:
1. **New User** - First time installation, no account
2. **Existing Free User** - Has account, no premium
3. **Existing Premium User** - Has account, active premium subscription

---

## 1. Onboarding & Authentication Tests

### 1.1 First Launch Experience
**Steps:**
1. Launch app for the first time
2. Observe onboarding screens

**Expected:**
- [ ] App launches without crashes
- [ ] Onboarding screens display correctly
- [ ] All images and text are visible
- [ ] Navigation between onboarding screens works

### 1.2 Sign Up Flow
**Steps:**
1. From onboarding, tap "Sign Up"
2. Enter email: `test+[random]@example.com`
3. Enter password: `TestPass123!`
4. Confirm password
5. Tap "Create Account"

**Expected:**
- [ ] Form validation works (email format, password strength)
- [ ] Loading indicator shows during account creation
- [ ] Account created successfully
- [ ] User redirected to home/profile screen
- [ ] Firebase Auth shows new user in console

### 1.3 Login Flow
**Steps:**
1. Sign out from current account
2. Tap "Login"
3. Enter credentials from 1.2
4. Tap "Login"

**Expected:**
- [ ] Login successful
- [ ] User redirected to home/profile
- [ ] Previous profile data loads (if any)
- [ ] Streak data persists

### 1.4 Guest Mode
**Steps:**
1. From onboarding/login screen, tap "Continue as Guest"

**Expected:**
- [ ] Guest account created
- [ ] Basic features accessible
- [ ] Limited features prompt upgrade
- [ ] User can convert guest to account later

### 1.5 Password Reset
**Steps:**
1. From login screen, tap "Forgot Password?"
2. Enter email address
3. Tap "Send Reset Link"
4. Check email inbox
5. Click reset link
6. Enter new password

**Expected:**
- [ ] Reset email sent successfully
- [ ] Email received with reset link
- [ ] Reset link works
- [ ] New password accepted
- [ ] Can login with new password

### 1.6 Error Handling
**Test Cases:**
- [ ] Invalid email format shows error
- [ ] Weak password shows error
- [ ] Incorrect login credentials show error
- [ ] Network error handled gracefully
- [ ] Account already exists error shown

---

## 2. Profile System Tests

### 2.1 Profile Screen Display
**Steps:**
1. Navigate to Profile screen
2. Observe all elements

**Expected:**
- [ ] User avatar displays correctly
- [ ] Username/email visible
- [ ] Streak counter shows current streak
- [ ] Medal displays current progress
- [ ] Progress bar reflects completion %
- [ ] Settings/edit options available

### 2.2 Avatar Selection - Free User
**Steps:**
1. Tap on avatar to open picker
2. Navigate to "Free" avatars tab
3. Select a free avatar
4. Confirm selection

**Expected:**
- [ ] Avatar picker modal opens
- [ ] Free avatars section shows all available avatars
- [ ] Selected avatar highlighted
- [ ] Confirmation saves selection
- [ ] Profile updates with new avatar immediately
- [ ] Avatar persists after app restart

### 2.3 Avatar Selection - Premium Locked
**Steps:**
1. Tap on avatar to open picker
2. Navigate to "Premium" avatars tab
3. Tap on a locked premium avatar

**Expected:**
- [ ] Premium avatars section shows with lock icons
- [ ] Tapping locked avatar triggers action
- [ ] Paywall modal opens
- [ ] "Upgrade to Premium" message displays
- [ ] Free user cannot select premium avatar

### 2.4 Daily Check-In
**Steps:**
1. Navigate to Profile
2. If "Check In" button available, tap it
3. Observe streak counter
4. Try checking in again immediately

**Expected:**
- [ ] Check-in button visible when available
- [ ] Tapping check-in increments streak
- [ ] Visual feedback on successful check-in
- [ ] Streak counter updates (+1)
- [ ] Check-in button disabled after use
- [ ] Cannot check in multiple times same day
- [ ] Check-in status persists

### 2.5 Streak Calculation
**Test Scenarios:**
- [ ] New user starts with 0 streak
- [ ] First check-in sets streak to 1
- [ ] Consecutive daily check-ins increment streak
- [ ] Missing a day resets streak to 0
- [ ] Streak survives app restarts

### 2.6 Medal Progress
**Steps:**
1. Check current medal display
2. Perform actions that contribute to progress
3. Observe progress bar updates

**Expected:**
- [ ] Current medal tier displays correctly
- [ ] Progress bar shows completion percentage
- [ ] Progress updates as actions complete
- [ ] Medal upgrades when threshold reached
- [ ] Medal changes reflected in feed posts

---

## 3. Feed System Tests

### 3.1 Feed Display
**Steps:**
1. Navigate to Feed screen
2. Scroll through posts

**Expected:**
- [ ] Feed loads successfully
- [ ] Posts display in chronological order
- [ ] Each post shows: avatar, username, content, reactions
- [ ] Post cards show medal badge
- [ ] Post cards show streak counter
- [ ] Post cards show progress bar
- [ ] Infinite scroll works
- [ ] Pull to refresh works

### 3.2 Create Post
**Steps:**
1. Tap "Create Post" button
2. Enter text: "This is a test post #testing"
3. Tap "Post"

**Expected:**
- [ ] Create post modal/screen opens
- [ ] Text input works correctly
- [ ] Character count displays
- [ ] Loading indicator during post creation
- [ ] Post appears in feed immediately
- [ ] New post shows user's current avatar
- [ ] New post shows user's current medal
- [ ] New post shows user's current streak

### 3.3 React to Post
**Steps:**
1. Find a post in feed
2. Tap reaction button (like, support, celebrate)
3. Tap same reaction again (unreact)

**Expected:**
- [ ] Reaction buttons visible on each post
- [ ] Tapping reaction updates UI immediately
- [ ] Reaction count increments
- [ ] User's reaction highlighted
- [ ] Tapping again removes reaction
- [ ] Reaction count decrements
- [ ] Reactions persist across app restarts

### 3.4 Feed Refresh
**Steps:**
1. View feed
2. Pull down to refresh
3. Wait for refresh to complete

**Expected:**
- [ ] Pull to refresh gesture works
- [ ] Loading indicator shows
- [ ] New posts load if available
- [ ] Feed updates with latest data
- [ ] Scroll position maintained reasonably

### 3.5 User Profile Display in Posts
**Steps:**
1. View multiple posts from different users
2. Observe avatar, medal, streak, progress

**Expected:**
- [ ] Each post shows correct user avatar
- [ ] Each post shows correct medal for that user
- [ ] Each post shows correct streak for that user
- [ ] Progress bar matches user's actual progress
- [ ] Premium avatars display correctly in feed

---

## 4. Guild System Tests (Premium Feature)

### 4.1 Guild Screen - Free User
**Steps:**
1. Login as free user (no premium)
2. Navigate to Guilds screen
3. Observe UI

**Expected:**
- [ ] Guild screen accessible
- [ ] Shows "Join or Create a Guild" CTA
- [ ] Premium badge/indicator visible
- [ ] Explanation of guild features
- [ ] "Upgrade to Premium" prompt visible

### 4.2 Create Guild - Free User (Gated)
**Steps:**
1. As free user, tap "Create Guild" button
2. Observe response

**Expected:**
- [ ] Create guild button visible
- [ ] Tapping opens paywall modal
- [ ] "Upgrade to Premium" message shows
- [ ] Cannot proceed without premium
- [ ] Modal closes without purchase

### 4.3 Join Guild - Free User (Gated)
**Steps:**
1. As free user, tap "Join Guild" button
2. Observe response

**Expected:**
- [ ] Join guild option visible
- [ ] Tapping opens paywall modal
- [ ] Premium required message shows
- [ ] Cannot join without premium

### 4.4 Create Guild - Premium User
**Steps:**
1. Login as premium user
2. Navigate to Guilds
3. Tap "Create Guild"
4. Enter guild name: "Test Guild"
5. Enter description: "Testing guild creation"
6. Tap "Create"

**Expected:**
- [ ] Create guild form opens
- [ ] All fields editable
- [ ] Form validation works
- [ ] Guild created successfully
- [ ] User becomes guild admin
- [ ] Redirected to new guild page
- [ ] Guild appears in user's guild list

### 4.5 Join Guild - Premium User
**Steps:**
1. As premium user (not guild member)
2. Find an existing guild
3. Tap "Join Guild"

**Expected:**
- [ ] Join button available
- [ ] Joining is immediate or requires approval
- [ ] User added to guild members
- [ ] Guild feed becomes accessible
- [ ] Guild appears in user's guild list

### 4.6 Guild Admin Features
**Steps:**
1. As guild admin/creator
2. Navigate to guild page
3. Look for admin options icon

**Expected:**
- [ ] Options/settings icon visible (admin only)
- [ ] Tapping opens admin menu
- [ ] Can edit guild details
- [ ] Can manage members (optional)
- [ ] Can delete guild (optional)
- [ ] Non-admins don't see these options

### 4.7 Guild Feed
**Steps:**
1. As guild member
2. Navigate to guild page
3. View guild feed
4. Create a guild post

**Expected:**
- [ ] Guild feed displays correctly
- [ ] Only guild members' posts visible
- [ ] Create post button available
- [ ] Posts work same as global feed
- [ ] Reactions work correctly

---

## 5. Premium / IAP Flow Tests

### 5.1 Paywall Display
**Steps:**
1. Trigger paywall (from avatar or guild)
2. Observe paywall modal

**Expected:**
- [ ] Modal opens with smooth animation
- [ ] "Upgrade to Premium" header visible
- [ ] Feature list displays benefits
- [ ] Subscription offerings load from RevenueCat
- [ ] Monthly option displays: `nofapp_premium_monthly`
- [ ] Yearly option displays: `nofapp_premium_yearly`
- [ ] Prices display correctly from App Store
- [ ] "Restore Purchases" button visible
- [ ] Close button works

### 5.2 Offerings Load
**Steps:**
1. Open paywall
2. Wait for offerings to load
3. Check displayed information

**Expected:**
- [ ] Loading indicator while fetching offerings
- [ ] Both monthly and yearly products appear
- [ ] Product titles correct
- [ ] Prices in correct currency for region
- [ ] Trial period info (if applicable)
- [ ] Introductory pricing (if applicable)

### 5.3 Monthly Purchase Flow
**Steps:**
1. Open paywall
2. Select monthly subscription
3. Tap "Subscribe" or "Purchase"
4. Complete sandbox purchase
5. Confirm purchase

**Expected:**
- [ ] Monthly option selectable
- [ ] Tapping triggers Apple payment sheet
- [ ] Sandbox tester credentials requested
- [ ] Purchase processes successfully
- [ ] Loading indicator during purchase
- [ ] Success message appears
- [ ] Modal closes automatically
- [ ] Premium features unlock immediately

### 5.4 Yearly Purchase Flow
**Steps:**
1. Open paywall
2. Select yearly subscription
3. Complete purchase process

**Expected:**
- [ ] Yearly option selectable
- [ ] Purchase flow same as monthly
- [ ] Correct price displayed
- [ ] Purchase completes successfully
- [ ] Premium features unlock

### 5.5 Entitlement Verification
**Steps:**
1. After successful purchase
2. Check premium status in app
3. Verify in RevenueCat Dashboard

**Expected:**
- [ ] `premium` entitlement is active
- [ ] isPremium provider returns true
- [ ] Premium avatars unlocked
- [ ] Guild create/join unlocked
- [ ] No more paywall prompts
- [ ] RevenueCat Dashboard shows active entitlement

### 5.6 Premium Avatar Unlock
**Steps:**
1. After purchase, open avatar picker
2. Navigate to Premium avatars
3. Select a premium avatar

**Expected:**
- [ ] All premium avatars unlocked
- [ ] No lock icons on premium avatars
- [ ] Can select any premium avatar
- [ ] Selection saves successfully
- [ ] Avatar displays in profile and posts

### 5.7 Guild Features Unlock
**Steps:**
1. After purchase, navigate to Guilds
2. Tap "Create Guild" or "Join Guild"

**Expected:**
- [ ] Create guild form opens (no paywall)
- [ ] Can complete guild creation
- [ ] Join guild works immediately
- [ ] Full guild features accessible

### 5.8 Restore Purchases
**Steps:**
1. Have active subscription on account
2. Delete and reinstall app
3. Login with same account
4. Open paywall
5. Tap "Restore Purchases"

**Expected:**
- [ ] Restore button triggers restore flow
- [ ] Loading indicator shows
- [ ] Purchase history retrieved
- [ ] Premium status restored
- [ ] Success message shows
- [ ] All premium features unlock
- [ ] No new charge occurs

### 5.9 Purchase Cancellation
**Steps:**
1. Start purchase flow
2. When Apple payment sheet appears
3. Tap "Cancel"

**Expected:**
- [ ] Payment sheet dismisses
- [ ] No purchase recorded
- [ ] User remains free tier
- [ ] No error messages
- [ ] Paywall still accessible

### 5.10 Error Handling
**Test Scenarios:**
- [ ] Network error during purchase
- [ ] Invalid product ID error
- [ ] RevenueCat API error
- [ ] Subscription already active
- [ ] Payment method declined
- [ ] All errors show user-friendly messages

---

## 6. UI/UX Polish Tests

### 6.1 Theme Switching
**Steps:**
1. Go to Settings
2. Toggle between Light/Dark themes
3. Navigate through app screens

**Expected:**
- [ ] Theme switches immediately
- [ ] All screens adapt to new theme
- [ ] Colors appropriate for theme
- [ ] Text readable in both themes
- [ ] Images/icons adapt correctly

### 6.2 App Icons
**Steps:**
1. Check home screen icon
2. Enable dark mode
3. Check icon again
4. Test dynamic tinting (iOS 18+)

**Expected:**
- [ ] Light mode icon displays correctly
- [ ] Dark mode icon displays correctly
- [ ] Glass/liquid variant available
- [ ] Tinted variant uses monochrome glyph
- [ ] All variants look good

### 6.3 Accessibility
**Steps:**
1. Enable VoiceOver
2. Navigate through app
3. Check all interactive elements

**Expected:**
- [ ] All buttons have labels
- [ ] All images have descriptions
- [ ] Navigation works with VoiceOver
- [ ] Form inputs properly labeled
- [ ] Tap targets ≥44x44 points

### 6.4 Reduce Motion
**Steps:**
1. Enable "Reduce Motion" in iOS settings
2. Use app features
3. Observe animations

**Expected:**
- [ ] Excessive animations disabled
- [ ] Essential animations still work
- [ ] Transitions simplified
- [ ] App remains functional

### 6.5 Performance
**Tests:**
- [ ] App launches in < 3 seconds
- [ ] Scrolling is smooth (60fps)
- [ ] No dropped frames during animations
- [ ] Images load quickly (lazy loading)
- [ ] No memory leaks (use Instruments)
- [ ] Battery usage reasonable

### 6.6 Keyboard Handling
**Steps:**
1. Tap text input field
2. Keyboard appears
3. Type text
4. Dismiss keyboard

**Expected:**
- [ ] Keyboard appears smoothly
- [ ] Input field not obscured by keyboard
- [ ] Typing works correctly
- [ ] Return/Done button works
- [ ] Keyboard dismisses properly
- [ ] Safe area respected

### 6.7 Safe Area Insets
**Steps:**
1. Test on device with notch (iPhone X+)
2. Navigate through all screens
3. Check top and bottom insets

**Expected:**
- [ ] No content hidden by notch
- [ ] No content hidden by home indicator
- [ ] Proper padding maintained
- [ ] Gestures don't conflict

---

## 7. Data Persistence Tests

### 7.1 App Restart
**Steps:**
1. Use app normally (login, make changes)
2. Force quit app
3. Relaunch app

**Expected:**
- [ ] User remains logged in
- [ ] Profile data persists
- [ ] Streak data persists
- [ ] Medal progress persists
- [ ] Premium status persists
- [ ] Selected avatar persists

### 7.2 Network Interruption
**Steps:**
1. Use app normally
2. Enable Airplane mode
3. Try to perform actions
4. Re-enable network

**Expected:**
- [ ] App doesn't crash
- [ ] Appropriate error messages
- [ ] Cached data still accessible
- [ ] Actions queue and retry
- [ ] Full functionality restored when online

---

## Test Results Template

### Test Session Info
- **Date:** [Date]
- **Tester:** [Name]
- **Device:** [iPhone model, iOS version]
- **Build:** [Version number]
- **Environment:** [Sandbox/Production]

### Results Summary
- **Total Tests:** [X]
- **Passed:** [X]
- **Failed:** [X]
- **Blocked:** [X]

### Failed Tests
| Test ID | Test Name | Failure Description | Severity |
|---------|-----------|---------------------|----------|
|         |           |                     |          |

### Issues Found
| Issue ID | Description | Steps to Reproduce | Severity |
|----------|-------------|-------------------|----------|
|          |             |                   |          |

### Notes
[Any additional observations or comments]

---

## Sign-Off

Test completed by: __________________
Date: __________________
Status: [ ] Approved [ ] Approved with issues [ ] Rejected
