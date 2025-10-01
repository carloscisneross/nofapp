import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../data/models/medal.dart';
import '../../profile/widgets/medal_widget.dart';

class FeedHeader extends ConsumerWidget {
  const FeedHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProfileProvider);
    final currentMedal = ref.watch(currentMedalProvider);
    final nextMedal = ref.watch(nextMedalProvider);
    final progress = ref.watch(medalProgressProvider);
    final personalMedals = ref.watch(personalMedalsProvider);

    return userProfile.when(
      data: (profile) {
        if (profile == null) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Status Row - matches sketch layout
              Row(
                children: [
                  // Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(profile.avatarKey),
                      onBackgroundImageError: (_, __) {},
                      child: profile.avatarKey.isEmpty
                          ? const Icon(Icons.person, size: 28)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // User info with medal inline
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                profile.displayName,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Current Medal inline with name
                            if (currentMedal != null)
                              MedalWidget(
                                medal: currentMedal,
                                size: 24,
                                showTooltip: true,
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              size: 16,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${profile.streak.current} day streak',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Progress to next medal
              if (nextMedal != null) ...[
                Text(
                  'Progress to ${nextMedal.name}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${profile.streak.current}/${nextMedal.threshold}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              
              // Next medals preview
              if (personalMedals.isNotEmpty) ...[
                Text(
                  'Next Medals',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: personalMedals.length > 5 ? 5 : personalMedals.length,
                    itemBuilder: (context, index) {
                      final medal = personalMedals[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: MedalWidget(
                          medal: medal,
                          size: 48,
                          showLocked: !medal.isUnlocked,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => Container(
        margin: const EdgeInsets.all(16),
        height: 150,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
