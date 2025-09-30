import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/constants.dart';
import 'core/providers.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/auth/reset_password_screen.dart';
import 'features/home/home_shell.dart';
import 'features/feed/feed_screen.dart';
import 'features/guilds/guild_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/settings/settings_screen.dart';

class AppRouter {
  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: AppConstants.onboardingRoute,
      redirect: (context, state) {
        final user = ref.read(currentUserProvider);
        final isOnboardingCompleted = ref.read(isOnboardingCompletedProvider);
        
        // If not onboarded, redirect to onboarding
        if (!isOnboardingCompleted && state.fullPath != AppConstants.onboardingRoute) {
          return AppConstants.onboardingRoute;
        }
        
        // If onboarded but not logged in, redirect to login
        if (isOnboardingCompleted && user == null && 
            !state.fullPath!.startsWith('/auth') &&
            state.fullPath != AppConstants.onboardingRoute) {
          return AppConstants.loginRoute;
        }
        
        // If logged in but trying to access auth pages, redirect to home
        if (user != null && (state.fullPath!.startsWith('/auth') || 
            state.fullPath == AppConstants.onboardingRoute)) {
          return AppConstants.feedRoute;
        }
        
        return null; // No redirect needed
      },
      routes: [
        // Onboarding
        GoRoute(
          path: AppConstants.onboardingRoute,
          builder: (context, state) => const OnboardingScreen(),
        ),
        
        // Auth Routes
        GoRoute(
          path: AppConstants.loginRoute,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppConstants.signupRoute,
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: AppConstants.resetPasswordRoute,
          builder: (context, state) => const ResetPasswordScreen(),
        ),
        
        // Main App Shell with Bottom Navigation
        ShellRoute(
          builder: (context, state, child) => HomeShell(child: child),
          routes: [
            GoRoute(
              path: AppConstants.feedRoute,
              builder: (context, state) => const FeedScreen(),
            ),
            GoRoute(
              path: AppConstants.guildRoute,
              builder: (context, state) => const GuildScreen(),
            ),
            GoRoute(
              path: AppConstants.profileRoute,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
        
        // Settings (outside of shell)
        GoRoute(
          path: AppConstants.settingsRoute,
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(AppConstants.feedRoute),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}