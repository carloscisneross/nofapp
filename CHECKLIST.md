# nofApp Phase 4 Completion Checklist

## Code Quality & Stability
- [ ] All lints fixed (`flutter analyze --fatal-infos`)
- [ ] Formatter clean (`dart format . --set-exit-if-changed`)
- [ ] No `use_build_context_synchronously` warnings
- [ ] All deprecated APIs replaced:
  - [ ] `surfaceVariant` → `surfaceContainerHighest`
  - [ ] `withOpacity()` → `.withValues()`
- [ ] Network timeouts and retry logic implemented
- [ ] Null-safe async context usage throughout

## UI/UX Polish - Sketch Alignment
- [ ] Bottom navigation: Feed, Guild, Profile tabs with proper active/idle states
- [ ] Feed card shows:
  - [ ] User avatar with border
  - [ ] Current medal inline with name
  - [ ] Streak indicator with flame icon
  - [ ] Progress bar to next medal
  - [ ] Progress text (current/threshold)
- [ ] Profile header spacing matches sketch:
  - [ ] Avatar with edit indicator
  - [ ] Name + medal inline
  - [ ] Streak widget with check-in button
  - [ ] Medal progression display
- [ ] Avatar picker gating behaviors verified:
  - [ ] Free avatars selectable for all users
  - [ ] Premium avatars show lock → paywall for free users
  - [ ] Premium users can select any avatar
- [ ] Guild tab behavior verified:
  - [ ] Free users see CTA screen → paywall on actions
  - [ ] Premium users go to guild hub
  - [ ] Admin options icon visible only to admins

## Accessibility & Motion
- [ ] All interactive elements ≥ 44px tap target size
- [ ] Semantic labels on key buttons:
  - [ ] Avatar edit button
  - [ ] Check-in button with hint
  - [ ] Paywall CTA buttons
  - [ ] Medal tooltips
- [ ] Navigation tabs have proper labels and tooltips
- [ ] Good contrast ratios in light/dark themes
- [ ] Platform-appropriate haptic feedback implemented
- [ ] Animation system with reduced motion respect

## Performance & Offline
- [ ] Optimistic UI for reactions and check-ins
- [ ] Rollback on network failure
- [ ] Image optimization with memory caching
- [ ] Lazy loading for avatar/medal assets
- [ ] Smooth scroll performance (no jank)
- [ ] Network resilience with timeout/retry
- [ ] Offline state handling

## Platform Polish
- [ ] iOS icons verified:
  - [ ] Light mode icon displays correctly
  - [ ] Dark mode icon displays correctly
  - [ ] Glass/liquid mode compatible
  - [ ] Tinted (monochrome) icon included
- [ ] Android adaptive icons verified:
  - [ ] Light foreground asset
  - [ ] Dark foreground asset
  - [ ] Neutral background color
- [ ] Build configurations verified:
  - [ ] Android: AGP 8.7.0, Gradle 8.10.2, NDK 27.0.12077973
  - [ ] iOS: Compatible with iOS 17/18
  - [ ] Kotlin JVM target 17
  - [ ] CompileSdk 34, minSdk 23

## Integration Readiness
- [ ] Firebase stub initialization ready for:
  - [ ] `lib/firebase/firebase_options.dart`
  - [ ] `android/app/google-services.json`
  - [ ] `ios/Runner/GoogleService-Info.plist`
- [ ] RevenueCat stub ready for API keys via:
  - [ ] `--dart-define=RC_ANDROID=xxx --dart-define=RC_IOS=yyy`
  - [ ] Or `lib/secrets.dart` (git-ignored)
- [ ] Sample secrets file provided (`lib/secrets.sample.dart`)
- [ ] Premium gating centralized in providers
- [ ] Firestore schema matches data models

## Testing & Validation
- [ ] Onboarding → Auth flows functional (signup, login, reset)
- [ ] Profile → avatar edit, streak check-in, medal progress
- [ ] Feed → post creation, reactions, optimistic updates
- [ ] Guild → free user CTA + paywall, premium user full access
- [ ] Paywall → triggers from correct actions, stub purchase works
- [ ] Settings → theme selection, profile management, account actions
- [ ] Error handling → network timeouts, validation errors
- [ ] Edge cases → multiple taps, offline state, day boundaries

## Documentation & Configuration
- [ ] README updated with:
  - [ ] Quickstart instructions
  - [ ] Firebase setup steps
  - [ ] RevenueCat configuration
  - [ ] Build commands with dart-define
- [ ] CONFIG.md created with:
  - [ ] Firestore schema documentation
  - [ ] Provider map and dependencies
  - [ ] Route structure (go_router + shell)
- [ ] QA NOTES.md created with:
  - [ ] Tested edge cases listed
  - [ ] Known issues/limitations noted
  - [ ] Performance benchmarks if applicable
- [ ] Bundle IDs correct: `com.carlo.nofapp`
- [ ] App name "nofApp" throughout codebase

## Final Verification
- [ ] `flutter pub get` succeeds
- [ ] `flutter analyze --fatal-infos` passes (0 issues)
- [ ] `dart format . --set-exit-if-changed` passes
- [ ] `flutter build apk --release` succeeds (Android)
- [ ] `flutter build ios --release --no-codesign` succeeds (iOS, if on macOS)
- [ ] No missing asset references
- [ ] All provided assets properly integrated
- [ ] Git repository clean (no sensitive data committed)

---

## Sign-off
- [ ] Code review completed
- [ ] All checklist items verified
- [ ] Ready for Firebase + RevenueCat integration
- [ ] Ready for production deployment

**Completed by:** `[Developer Name]`  
**Date:** `[Completion Date]`  
**Commit Hash:** `[Final Commit]`  

---

## Post-Integration Testing (After Firebase + RevenueCat keys provided)
- [ ] Firebase Auth works (signup, login, logout)
- [ ] Firestore data persistence verified
- [ ] Real-time updates functional
- [ ] RevenueCat purchase flow works
- [ ] Premium features unlock correctly
- [ ] Subscription restoration works
- [ ] End-to-end flow tested in sandbox/staging
- [ ] Production deployment ready