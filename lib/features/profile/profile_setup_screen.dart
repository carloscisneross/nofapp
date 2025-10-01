import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../data/models/user_profile.dart';
import '../../data/services/profile_repository.dart';
import 'widgets/avatar_picker_modal.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  final String userId;
  final String email;

  const ProfileSetupScreen({
    super.key,
    required this.userId,
    required this.email,
  });

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  
  String _selectedAvatarKey = AppConstants.defaultAvatarKey;
  bool _isLoading = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _createProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final profile = UserProfile(
        uid: widget.userId,
        email: widget.email,
        displayName: _displayNameController.text.trim(),
        avatarKey: _selectedAvatarKey,
        isPremium: false,
        streak: StreakData.initial(),
        personalMedals: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await ProfileRepository.instance.createUserProfile(profile);
      
      if (mounted) {
        context.go(AppConstants.feedRoute);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile creation failed: $e'),
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

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AvatarPickerModal(
        currentAvatarKey: _selectedAvatarKey,
        onAvatarSelected: (avatarKey) {
          setState(() => _selectedAvatarKey = avatarKey);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                
                // Welcome text
                Text(
                  'Complete Your Profile',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your avatar and display name',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // Avatar selection
                Center(
                  child: GestureDetector(
                    onTap: _showAvatarPicker,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          _selectedAvatarKey,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 120,
                            height: 120,
                            color: colorScheme.surface,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Avatar selection hint
                Center(
                  child: TextButton.icon(
                    onPressed: _showAvatarPicker,
                    icon: const Icon(Icons.edit),
                    label: const Text('Choose Avatar'),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Display name field
                TextFormField(
                  controller: _displayNameController,
                  textInputAction: TextInputAction.done,
                  enabled: !_isLoading,
                  onFieldSubmitted: (_) => _createProfile(),
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    hintText: 'Enter your display name',
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Display name is required';
                    }
                    if (value.trim().length < 2) {
                      return 'Display name must be at least 2 characters';
                    }
                    if (value.trim().length > AppConstants.maxDisplayNameLength) {
                      return 'Display name must be less than ${AppConstants.maxDisplayNameLength} characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 48),
                
                // Create profile button
                ElevatedButton(
                  onPressed: _isLoading ? null : _createProfile,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Complete Setup'),
                ),
                const SizedBox(height: 16),
                
                // Skip for now (guest users)
                if (widget.email.contains('guest')) ...[
                  TextButton(
                    onPressed: _isLoading ? null : () {
                      // Use default values for guest
                      _displayNameController.text = 'Guest User';
                      _createProfile();
                    },
                    child: const Text('Skip for now'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
