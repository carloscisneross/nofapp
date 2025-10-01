# Dart Syntax Fixes - Build Runner Unblocking

## Summary
Fixed incorrect spread operator syntax in collection literals across 8 files. Changed `..[` to `...[` which is the correct Dart syntax for conditionally spreading elements into a collection.

## Files Fixed

### 1. lib/features/auth/reset_password_screen.dart
- **Line 143:** `if (!_emailSent) ..[` → `if (!_emailSent) ...[`
- **Line 179:** `] else ..[` → `] else ...[`

### 2. lib/features/feed/feed_screen.dart
- **Line 45:** `if (currentUser != null) ..[` → `if (currentUser != null) ...[`

### 3. lib/features/feed/widgets/feed_header.dart
- **Line 121:** `if (nextMedal != null) ..[` → `if (nextMedal != null) ...[`
- **Line 155:** `if (personalMedals.isNotEmpty) ..[` → `if (personalMedals.isNotEmpty) ...[`

### 4. lib/features/feed/widgets/post_card.dart
- **Line 354:** `if (count > 0) ..[` → `if (count > 0) ...[`

### 5. lib/features/feed/widgets/post_composer.dart
- **Line 140:** `if (_isExpanded) ..[` → `if (_isExpanded) ...[`

### 6. lib/features/guilds/widgets/guild_home.dart
- **Line 108:** `if (guild.description.isNotEmpty) ..[` → `if (guild.description.isNotEmpty) ...[`

### 7. lib/features/profile/profile_setup_screen.dart
- **Line 223:** `if (widget.email.contains('guest')) ..[` → `if (widget.email.contains('guest')) ...[`

### 8. lib/features/profile/widgets/premium_paywall_modal.dart
- **Line 105:** `if (widget.feature != null) ..[` → `if (widget.feature != null) ...[`

## Technical Details

### The Issue
The spread operator in Dart requires three dots followed by square brackets: `...[`
Using only two dots before the bracket `..[` is invalid syntax and causes compilation errors.

### Correct Usage
```dart
// ❌ WRONG
if (condition) ..[
  Widget1(),
  Widget2(),
]

// ✅ CORRECT
if (condition) ...[
  Widget1(),
  Widget2(),
]
```

### Why This Matters
- The spread operator `...` allows conditional insertion of multiple elements into a collection
- It's commonly used with `if` statements in Flutter widget trees
- Missing the third dot breaks Dart's parser and prevents build_runner from generating code

## Non-ASCII Characters
Checked for problematic non-ASCII characters (bullets •, emojis 🔒⭐, em/en dashes —–, smart quotes ""''):
- Found one bullet • in guild_home.dart:83, but it's inside a string literal, which is valid
- Found smart quotes in post_composer.dart, but they're inside string literals, which is valid
- No non-ASCII characters found outside of strings

## Verification Steps

### Local Testing (when available)
```bash
# Format the fixed files
dart format lib

# Run analyzer
dart analyze

# Run build_runner
dart run build_runner build --delete-conflicting-outputs

# Test the app
flutter run
```

### Expected Results
- ✅ `dart analyze` reports 0 errors
- ✅ `build_runner` completes successfully
- ✅ App compiles and runs without syntax errors

## Impact
These fixes unblock:
1. Code generation via build_runner
2. Static analysis via dart analyze
3. Compilation and running of the Flutter app
4. All development workflows that depend on valid Dart syntax

## Related
- Dart spread operator: https://dart.dev/guides/language/language-tour#spread-operator
- Collection if/for: https://dart.dev/guides/language/language-tour#collection-operators
