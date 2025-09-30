import 'package:flutter/material.dart';

import '../../../data/models/user_profile.dart';

class StreakWidget extends StatelessWidget {
  final StreakData streak;
  final bool canCheckIn;
  final VoidCallback? onCheckIn;

  const StreakWidget({
    super.key,
    required this.streak,
    required this.canCheckIn,
    this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'Streak',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (canCheckIn && onCheckIn != null)
                  Semantics(
                    label: 'Check in to continue your streak',
                    hint: 'Tap to record today\'s check-in',
                    child: ElevatedButton(
                      onPressed: onCheckIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(88, 44), // Minimum tap target size
                      ),
                      child: const Text('Check In'),
                    ),
                  )
                else if (!canCheckIn)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Checked In',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Streak stats
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Current',
                    value: streak.current.toString(),
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Longest',
                    value: streak.longestStreak.toString(),
                    icon: Icons.trending_up,
                    color: colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Total Days',
                    value: streak.totalDays.toString(),
                    icon: Icons.calendar_today,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Last check-in info
            if (streak.lastCheckInAt != null)
              Text(
                'Last check-in: ${_formatDate(streak.lastCheckInAt!)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkInDate = DateTime(date.year, date.month, date.day);
    
    if (checkInDate == today) {
      return 'Today';
    } else if (checkInDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
