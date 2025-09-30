import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/guild.dart';
import 'widgets/guild_not_joined.dart';
import 'widgets/guild_home.dart';
import '../profile/widgets/premium_paywall_modal.dart';

class GuildScreen extends ConsumerWidget {
  const GuildScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentGuild = ref.watch(currentUserGuildProvider);
    final isPremium = ref.watch(isPremiumProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guild'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: currentGuild.when(
        data: (guild) {
          if (guild == null) {
            // User is not in a guild
            return GuildNotJoined(
              onCreateGuild: () => _handleCreateGuild(context, ref),
              onJoinGuild: () => _handleJoinGuild(context, ref),
            );
          } else {
            // User is in a guild
            return GuildHome(guild: guild);
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
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
                'Failed to load guild',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(currentUserGuildProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCreateGuild(BuildContext context, WidgetRef ref) {
    final isPremium = ref.read(isPremiumProvider);
    
    if (!isPremium) {
      // Show premium paywall first
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const PremiumPaywallModal(
          feature: 'Guild Creation',
        ),
      );
    } else {
      // Show guild creation dialog
      _showCreateGuildDialog(context, ref);
    }
  }

  void _handleJoinGuild(BuildContext context, WidgetRef ref) {
    final isPremium = ref.read(isPremiumProvider);
    
    if (!isPremium) {
      // Show premium paywall first
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const PremiumPaywallModal(
          feature: 'Guild Joining',
        ),
      );
    } else {
      // Show guild browser
      _showGuildBrowser(context, ref);
    }
  }

  void _showCreateGuildDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Guild'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Guild Name',
                  hintText: 'Enter guild name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Guild name is required';
                  }
                  if (value.trim().length > 50) {
                    return 'Guild name must be less than 50 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe your guild...',
                ),
                validator: (value) {
                  if (value != null && value.length > 200) {
                    return 'Description must be less than 200 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop();
                
                try {
                  final currentUser = ref.read(currentUserProvider);
                  if (currentUser != null) {
                    await ref.read(guildServiceProvider).createGuild(
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim(),
                      creatorId: currentUser.uid,
                    );
                    
                    // Refresh guild data
                    ref.invalidate(currentUserGuildProvider);
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Guild created successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create guild: $e'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showGuildBrowser(BuildContext context, WidgetRef ref) {
    // TODO: Implement guild browser
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Guild browser coming soon!'),
      ),
    );
  }
}
