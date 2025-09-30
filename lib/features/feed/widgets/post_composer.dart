import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants.dart';
import '../../../core/providers.dart';
import '../../../data/services/post_service.dart';

class PostComposer extends ConsumerStatefulWidget {
  final String? guildId; // null for global posts

  const PostComposer({super.key, this.guildId});

  @override
  ConsumerState<PostComposer> createState() => _PostComposerState();
}

class _PostComposerState extends ConsumerState<PostComposer> {
  final _textController = TextEditingController();
  bool _isExpanded = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final userProfile = ref.read(currentUserProfileProvider).valueOrNull;
    if (userProfile == null) return;

    setState(() => _isLoading = true);

    try {
      await PostService.instance.createPost(
        authorId: userProfile.uid,
        authorName: userProfile.displayName,
        authorAvatarKey: userProfile.avatarKey,
        text: text,
        guildId: widget.guildId,
      );

      _textController.clear();
      setState(() => _isExpanded = false);
      
      // Refresh the appropriate feed
      if (widget.guildId == null) {
        ref.invalidate(globalFeedProvider);
      } else {
        ref.invalidate(guildFeedProvider(widget.guildId!));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create post: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(currentUserProfileProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return userProfile.when(
      data: (profile) {
        if (profile == null) {
          return const SizedBox.shrink();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with avatar
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(profile.avatarKey),
                      onBackgroundImageError: (_, __) {},
                      child: profile.avatarKey.isEmpty
                          ? const Icon(Icons.person, size: 20)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _isExpanded = true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: colorScheme.outline.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            _isExpanded ? '' : "What's on your mind?",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Expanded composer
                if (_isExpanded) ..[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _textController,
                    maxLines: 4,
                    maxLength: AppConstants.maxPostLength,
                    enabled: !_isLoading,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: widget.guildId == null 
                          ? "Share something with the community..."
                          : "Share something with your guild...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      counterText: '${_textController.text.length}/${AppConstants.maxPostLength}',
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isLoading ? null : () {
                          _textController.clear();
                          setState(() => _isExpanded = false);
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isLoading || _textController.text.trim().isEmpty
                            ? null
                            : _createPost,
                        child: _isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Post'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
