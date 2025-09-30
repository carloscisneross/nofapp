import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../data/models/avatar.dart';

class AvatarPickerModal extends ConsumerStatefulWidget {
  final String currentAvatarKey;
  final Function(String) onAvatarSelected;
  final VoidCallback? onPremiumRequired;

  const AvatarPickerModal({
    super.key,
    required this.currentAvatarKey,
    required this.onAvatarSelected,
    this.onPremiumRequired,
  });

  @override
  ConsumerState<AvatarPickerModal> createState() => _AvatarPickerModalState();
}

class _AvatarPickerModalState extends ConsumerState<AvatarPickerModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedAvatarKey = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedAvatarKey = widget.currentAvatarKey;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final freeAvatars = ref.watch(freeAvatarsProvider);
    final premiumAvatars = ref.watch(premiumAvatarsProvider);
    final isPremium = ref.watch(isPremiumProvider);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Choose Avatar',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          // Tabs
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Free'),
              Tab(text: 'Premium'),
            ],
          ),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Free avatars
                freeAvatars.when(
                  data: (avatars) => _buildAvatarGrid(avatars, false),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(child: Text('Failed to load avatars')),
                ),
                
                // Premium avatars
                premiumAvatars.when(
                  data: (avatars) => _buildAvatarGrid(avatars, true),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(child: Text('Failed to load avatars')),
                ),
              ],
            ),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedAvatarKey != widget.currentAvatarKey
                        ? () {
                            widget.onAvatarSelected(_selectedAvatarKey);
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('Select'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarGrid(List<Avatar> avatars, bool isPremiumTab) {
    final isPremium = ref.watch(isPremiumProvider);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: avatars.length,
        itemBuilder: (context, index) {
          final avatar = avatars[index];
          final isSelected = _selectedAvatarKey == avatar.assetPath;
          final canSelect = !avatar.isPremium || isPremium;
          
          return GestureDetector(
            onTap: () {
              if (canSelect) {
                setState(() => _selectedAvatarKey = avatar.assetPath);
              } else if (isPremiumTab && widget.onPremiumRequired != null) {
                Navigator.of(context).pop();
                widget.onPremiumRequired!();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Stack(
                children: [
                  ClipOval(
                    child: Image.asset(
                      avatar.assetPath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      colorBlendMode: canSelect ? null : BlendMode.saturation,
                      color: canSelect ? null : Colors.grey,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.person, size: 40),
                      ),
                    ),
                  ),
                  
                  // Premium lock overlay
                  if (!canSelect)
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
