import 'package:flutter/material.dart';

import '../../../data/models/medal.dart';

class MedalWidget extends StatelessWidget {
  final Medal medal;
  final double size;
  final bool showLocked;
  final bool showTooltip;
  final VoidCallback? onTap;

  const MedalWidget({
    super.key,
    required this.medal,
    this.size = 48,
    this.showLocked = false,
    this.showTooltip = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    Widget medalContent = GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: medal.isUnlocked 
              ? null 
              : colorScheme.surface,
          border: Border.all(
            color: medal.isUnlocked 
                ? _getMedalColor(medal.level)
                : colorScheme.outline.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: medal.isUnlocked 
              ? [
                  BoxShadow(
                    color: _getMedalColor(medal.level).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Medal image or icon
            Center(
              child: medal.isUnlocked
                  ? Image.asset(
                      medal.smallAssetPath,
                      width: size * 0.7,
                      height: size * 0.7,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.emoji_events,
                        size: size * 0.6,
                        color: _getMedalColor(medal.level),
                      ),
                    )
                  : Icon(
                      showLocked ? Icons.lock : Icons.emoji_events_outlined,
                      size: size * 0.5,
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
            ),
            
            // Lock overlay
            if (!medal.isUnlocked && showLocked)
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.3),
                ),
                child: Icon(
                  Icons.lock,
                  size: size * 0.3,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );

    if (showTooltip) {
      return Tooltip(
        message: '${medal.name}\n${medal.description}',
        child: medalContent,
      );
    }

    return medalContent;
  }

  Color _getMedalColor(int level) {
    if (level <= 3) {
      return const Color(0xFFCD7F32); // Bronze
    } else if (level <= 6) {
      return const Color(0xFFC0C0C0); // Silver
    } else if (level <= 9) {
      return const Color(0xFFFFD700); // Gold
    } else {
      return const Color(0xFF9400D3); // Legendary
    }
  }
}
