import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/guild.dart';
import '../../../data/services/guild_service.dart';
import '../../../core/providers.dart';

class GuildAdminScreen extends ConsumerStatefulWidget {
  final Guild guild;

  const GuildAdminScreen({super.key, required this.guild});

  @override
  ConsumerState<GuildAdminScreen> createState() => _GuildAdminScreenState();
}

class _GuildAdminScreenState extends ConsumerState<GuildAdminScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _notificationsEnabled = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.guild.name;
    _descriptionController.text = widget.guild.description;
    _notificationsEnabled = widget.guild.notificationsEnabled;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guild Admin'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Guild Info Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Guild Information',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Guild name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Guild Name',
                        hintText: 'Enter guild name',
                      ),
                      maxLength: 50,
                    ),
                    const SizedBox(height: 16),
                    
                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Describe your guild...',
                      ),
                      maxLength: 200,
                    ),
                    const SizedBox(height: 16),
                    
                    // Notifications toggle
                    SwitchListTile(
                      title: const Text('Enable Notifications'),
                      subtitle: const Text('Send notifications to guild members'),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() => _notificationsEnabled = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateGuildInfo,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Members Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Members',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${widget.guild.memberCount}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Member management placeholder
                    ListTile(
                      leading: const Icon(Icons.person_add),
                      title: const Text('Invite Members'),
                      subtitle: const Text('Share invitation link'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Member invitations coming soon!'),
                          ),
                        );
                      },
                    ),
                    
                    ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text('Manage Members'),
                      subtitle: const Text('View and manage guild members'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Member management coming soon!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Danger Zone
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Danger Zone',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Leave guild
                    ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: theme.colorScheme.error,
                      ),
                      title: Text(
                        'Leave Guild',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text('You will lose admin privileges'),
                      onTap: () => _showLeaveGuildDialog(context),
                    ),
                    
                    // Delete guild
                    ListTile(
                      leading: Icon(
                        Icons.delete_forever,
                        color: theme.colorScheme.error,
                      ),
                      title: Text(
                        'Delete Guild',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text('Permanently delete this guild'),
                      onTap: () => _showDeleteGuildDialog(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateGuildInfo() async {
    setState(() => _isLoading = true);
    
    try {
      final updatedGuild = widget.guild.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        notificationsEnabled: _notificationsEnabled,
      );
      
      await GuildService.instance.updateGuild(updatedGuild);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Guild updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      
      // Refresh guild data
      ref.invalidate(currentUserGuildProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update guild: $e'),
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

  void _showLeaveGuildDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Guild'),
        content: const Text(
          'Are you sure you want to leave this guild? You will lose your admin privileges and need to be re-invited to rejoin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              try {
                final currentUser = ref.read(currentUserProvider);
                if (currentUser != null) {
                  await GuildService.instance.leaveGuild(
                    widget.guild.id,
                    currentUser.uid,
                  );
                  
                  if (mounted) {
                    Navigator.of(context).pop(); // Go back to guild screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Left guild successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  
                  // Refresh guild data
                  ref.invalidate(currentUserGuildProvider);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to leave guild: $e'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  void _showDeleteGuildDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Guild'),
        content: const Text(
          'Are you sure you want to permanently delete this guild? This action cannot be undone and all guild data will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              try {
                await GuildService.instance.deleteGuild(widget.guild.id);
                
                if (mounted) {
                  Navigator.of(context).pop(); // Go back to guild screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Guild deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                
                // Refresh guild data
                ref.invalidate(currentUserGuildProvider);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete guild: $e'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
