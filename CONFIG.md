# nofApp Configuration Guide

## Firestore Schema

### Collections Overview
```
users/{uid}                                   # User profiles and account data
├── displayName: string                       # User's display name
├── email: string                            # User's email address
├── avatarKey: string                        # Path to selected avatar asset
├── isPremium: boolean                       # Premium subscription status
├── streak: object                           # Streak tracking data
│   ├── current: number                      # Current streak count
│   ├── lastCheckInAt: timestamp             # Last check-in time
│   ├── totalDays: number                    # Total days checked in
│   └── longestStreak: number                # Longest streak achieved
├── personalMedals: array<string>            # Array of earned medal IDs
├── guildId: string?                         # ID of joined guild (nullable)
├── createdAt: timestamp                     # Account creation time
└── updatedAt: timestamp                     # Last profile update

guilds/{guildId}                             # Guild information
├── name: string                             # Guild display name
├── description: string                      # Guild description
├── level: number                            # Guild level (1-10)
├── medalKey: string                         # Path to guild medal asset
├── admins: array<string>                    # Array of admin user IDs
├── members: array<string>                   # Array of member user IDs
├── notificationsEnabled: boolean            # Guild notifications setting
├── createdAt: timestamp                     # Guild creation time
└── updatedAt: timestamp                     # Last guild update

posts/{postId}                               # Global and guild posts
├── authorId: string                         # Author's user ID
├── authorName: string                       # Author's display name (cached)
├── authorAvatarKey: string                  # Author's avatar (cached)
├── text: string                            # Post content (max 280 chars)
├── reactions: map<string, number>           # Emoji reactions with counts
├── commentsCount: number                    # Number of comments
├── guildId: string?                        # Guild ID (null for global posts)
├── createdAt: timestamp                     # Post creation time
└── updatedAt: timestamp                     # Last post update
```

### Security Rules (Firestore)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Guild access rules
    match /guilds/{guildId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        (resource == null || request.auth.uid in resource.data.admins);
    }
    
    // Post access rules
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.authorId;
      allow update, delete: if request.auth != null && 
        request.auth.uid == resource.data.authorId;
    }
  }
}
```

## Riverpod Provider Architecture

### Core Providers
```dart
// Authentication & User State
authStateProvider              # Firebase Auth state stream
currentUserProvider           # Current Firebase user
currentUserProfileProvider    # User's Firestore profile document

// Premium & Subscription  
premiumServiceProvider        # RevenueCat service singleton
premiumStatusProvider         # Premium status stream from RevenueCat
isPremiumProvider            # Boolean premium status

// Profile & Streak
streakServiceProvider        # Streak management service
currentStreakProvider        # User's current streak data
canCheckInTodayProvider      # Whether user can check in today
medalProgressProvider       # Progress toward next medal

// Feed & Posts
postServiceProvider          # Post management service
globalFeedProvider           # Global posts stream
guildFeedProvider(guildId)   # Guild-specific posts stream
postComposerProvider         # Post composer text state

// Guilds & Communities
guildServiceProvider         # Guild management service
currentUserGuildProvider     # User's current guild stream
publicGuildsProvider         # Available guilds stream

// Assets & UI State
assetManifestServiceProvider # Asset loading and management
availableAvatarsProvider     # Available avatars based on premium status
themeModeProvider           # App theme mode (light/dark/system)
selectedBottomNavIndexProvider # Bottom navigation state
```

### Provider Dependencies
```
currentUserProfileProvider
├── depends on: authStateProvider
└── provides to: currentStreakProvider, personalMedalsProvider

isPremiumProvider  
├── depends on: premiumStatusProvider, currentUserProfileProvider
└── provides to: availableAvatarsProvider, guildAccessProviders

currentUserGuildProvider
├── depends on: currentUserProfileProvider, guildServiceProvider
└── provides to: guildFeedProvider, guildAdminProviders

globalFeedProvider
├── depends on: postServiceProvider, authStateProvider
└── provides to: FeedScreen widgets
```

## Navigation Structure (go_router)

### Route Hierarchy
```
/ (redirect to onboarding or feed)
├── /onboarding                    # First-time user experience
└── /auth/                        # Authentication flows
    ├── /auth/login               # Email/password login
    ├── /auth/signup              # Account creation
    └── /auth/reset-password      # Password reset

/home (ShellRoute with bottom navigation)
├── /feed                         # Global feed (index 0)
├── /guild                        # Guild hub (index 1)  
└── /profile                      # User profile (index 2)

/settings                         # Account settings (outside shell)
```

### Route Guards & Redirects
```dart
// Redirect logic in AppRouter.createRouter()
if (!isOnboardingCompleted && currentRoute != '/onboarding') {
  return '/onboarding';
}

if (isOnboardingCompleted && user == null && !currentRoute.startsWith('/auth')) {
  return '/auth/login';
}

if (user != null && (currentRoute.startsWith('/auth') || currentRoute == '/onboarding')) {
  return '/feed';
}
```

## Asset Management

### Asset Categories
```dart
// Avatar Assets
assets/avatars/
├── female/          # Free avatars for female category
├── male/            # Free avatars for male category
└── premium/         # Premium-gated avatars

// Medal Assets  
assets/medals/
├── personal/
│   ├── normal/      # Full-size personal medals
│   └── small/       # Small personal medals for UI
└── guild/
    ├── normal/guild medals/  # Full-size guild medals
    └── small/       # Small guild medals for UI

// App Icons
assets/icons/
├── ios/             # iOS app icons (light, dark, glass, tinted)
└── android/         # Android adaptive icons (light, dark)
```

### Medal Thresholds
```dart
// Personal medal thresholds (streak days)
[1, 3, 5, 7, 10, 14, 21, 30, 60, 90, 180, 365]

// Medal naming convention
personal_1, personal_2, ..., personal_12   # Personal medals
guild_1, guild_2, ..., guild_10           # Guild medals
```

## Build Configuration

### Android (android/app/build.gradle)
```gradle
android {
    compileSdk 34
    ndkVersion "27.0.12077973"
    
    defaultConfig {
        applicationId "com.carlo.nofapp"
        minSdkVersion 23
        targetSdkVersion 34
    }
}

dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

### iOS (ios/Runner.xcodeproj)
```
PRODUCT_BUNDLE_IDENTIFIER = com.carlo.nofapp
IPHONEOS_DEPLOYMENT_TARGET = 12.0
SWIFT_VERSION = 5.0
```

### Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter_riverpod: ^2.6.1      # State management
  go_router: ^14.6.2            # Navigation
  firebase_core: ^4.1.1         # Firebase core
  firebase_auth: ^6.1.0         # Authentication
  cloud_firestore: ^6.0.2       # Database
  purchases_flutter: ^9.6.2     # RevenueCat subscriptions

dev_dependencies:
  flutter_lints: ^6.0.0         # Linting rules
  build_runner: ^2.4.13         # Code generation
```

## Environment Variables

### Development
```bash
# RevenueCat API Keys
RC_ANDROID=rcat_android_development_key
RC_IOS=rcat_ios_development_key

# Feature Flags
DEVELOPMENT=true
MOCK_PREMIUM=false
```

### Production
```bash
# RevenueCat API Keys  
RC_ANDROID=rcat_android_production_key
RC_IOS=rcat_ios_production_key

# Feature Flags
DEVELOPMENT=false
MOCK_PREMIUM=false
```

## Performance Optimizations

### Image Caching
- Avatar images cached with `cacheWidth`/`cacheHeight`
- Progressive loading with fade-in animation
- Memory-efficient sizing based on usage context

### Network Optimizations
- 10-second timeout on all Firestore operations
- Automatic retry with exponential backoff
- Optimistic UI updates with rollback on failure

### State Management
- Provider invalidation on data changes
- Efficient rebuild scoping with `select()`
- Proper disposal of streams and controllers

---

*This configuration guide reflects the current implementation as of Phase 4 completion. Update as needed when integrating live Firebase and RevenueCat services.*