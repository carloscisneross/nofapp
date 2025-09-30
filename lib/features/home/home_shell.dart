import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/providers.dart';

class HomeShell extends ConsumerWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedBottomNavIndexProvider);
    final currentLocation = GoRouterState.of(context).fullPath;

    // Update selected index based on current route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int newIndex = 0;
      if (currentLocation == AppConstants.feedRoute) {
        newIndex = 0;
      } else if (currentLocation == AppConstants.guildRoute) {
        newIndex = 1;
      } else if (currentLocation == AppConstants.profileRoute) {
        newIndex = 2;
      }
      
      if (newIndex != selectedIndex) {
        ref.read(selectedBottomNavIndexProvider.notifier).state = newIndex;
      }
    });

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref.read(selectedBottomNavIndexProvider.notifier).state = index;
          
          switch (index) {
            case 0:
              context.go(AppConstants.feedRoute);
              break;
            case 1:
              context.go(AppConstants.guildRoute);
              break;
            case 2:
              context.go(AppConstants.profileRoute);
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Guild',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
