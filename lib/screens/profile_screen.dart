import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samachar_plus_ott_app/providers/auth_provider.dart';
import 'package:samachar_plus_ott_app/widgets/custom_spinner.dart';
import 'package:samachar_plus_ott_app/constants.dart';
import 'package:samachar_plus_ott_app/theme.dart';
import 'package:samachar_plus_ott_app/services/geographic_service.dart';
import 'package:samachar_plus_ott_app/models/geographic_model.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = false;

  // User data from auth
  String _name = '';
  String _phone = '';
  String _gender = 'other';
  String _state = '';
  String _district = '';
  List<String> _selectedCategories = [];
  List<String> _availableCategories = [];

  List<GeoState> _allStates = [];
  String? _selectedStateId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProfile = authProvider.userProfile;
    
    // Load states from cache
    _allStates = GeographicService.instance.getStates();

    if (userProfile != null) {
      setState(() {
        _name = userProfile.name;
        _phone = userProfile.phone;
        _state = userProfile.preferences?.state ?? '';
        _district = userProfile.preferences?.district ?? '';
        _selectedCategories = userProfile.preferences?.categories ?? [];
        _availableCategories = GeographicService.instance.getCategories();
        
        // Find matching state ID if name exists
        if (_state.isNotEmpty) {
          try {
            _selectedStateId = _allStates.firstWhere((s) => s.stateNameEnglish == _state).id;
          } catch (_) {
            _selectedStateId = null;
          }
        }
      });
    }
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  void _handleSave() async {
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProfile = authProvider.userProfile;

    if (userProfile != null) {
      final updatedProfile = userProfile.copyWith(
        name: _name,
        preferences: userProfile.preferences?.copyWith(
          state: _state,
          district: _district,
          categories: _selectedCategories,
        ),
      );

      await authProvider.updateUserProfile(updatedProfile);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildGenderIcon(String gender) {
    IconData icon = Icons.face_6_rounded;
    Color color = AppTheme.red500;
    
    if (gender == 'male') {
      icon = Icons.face_rounded;
      color = const Color(0xFF0EA5E9); // Modern sky blue
    } else if (gender == 'female') {
      icon = Icons.face_3_rounded;
      color = const Color(0xFFF43F5E); // Modern rose/pink
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Icon(icon, size: 36, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticated) {
      return _buildSignInPrompt();
    }

    if (_isLoading) {
      return const Center(child: CustomSpinner());
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            AppTheme.gray50.withValues(alpha: 0.8),
            AppTheme.gray100.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Column(
        children: [
          // TOP HALF: Profile
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: _isEditing ? _buildEditMode() : _buildViewMode(),
            ),
          ),
          
          // BOTTOM HALF: Notifications
          if (!_isEditing)
            Expanded(
              flex: 1,
              child: _buildNotificationsSection(),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    // Mock notifications data (same as before)
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Breaking News!',
        'body': 'Major policy update announced by the government regarding digital media.',
        'time': '2 mins ago',
        'type': 'breaking',
        'isRead': false,
      },
      {
        'title': 'Local Update: $_district',
        'body': 'New community center to be inaugurated in your district this weekend.',
        'time': '1 hour ago',
        'type': 'local',
        'isRead': true,
      },
      {
        'title': 'Election Watch',
        'body': 'Phase 2 of local elections conclude with high voter turnout.',
        'time': '3 hours ago',
        'type': 'headline',
        'isRead': true,
      },
      {
        'title': 'Weather Alert',
        'body': 'Heavy rainfall expected in the northern regions over the next 48 hours.',
        'time': '5 hours ago',
        'type': 'breaking',
        'isRead': true,
      },
      {
        'title': 'Sporting Glory',
        'body': 'National team wins the championship in a thrilling final match.',
        'time': '1 day ago',
        'type': 'headline',
        'isRead': true,
      },
    ];

    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.red500.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_active_rounded, color: AppTheme.red500, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'NOTIFICATIONS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.gray900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Mark all as read',
                    style: TextStyle(
                      color: AppTheme.red500.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _buildNotificationItem(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> item) {
    Color typeColor = AppTheme.gray500;
    IconData typeIcon = Icons.info_outline;

    if (item['type'] == 'breaking') {
      typeColor = AppTheme.red500;
      typeIcon = Icons.auto_awesome_rounded;
    } else if (item['type'] == 'local') {
      typeColor = Colors.blue.shade600;
      typeIcon = Icons.assistant_navigation;
    } else if (item['type'] == 'headline') {
      typeColor = Colors.amber.shade700;
      typeIcon = Icons.stars_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item['isRead'] ? AppTheme.gray200 : typeColor.withValues(alpha: 0.3),
          width: item['isRead'] ? 1 : 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(typeIcon, color: typeColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['title'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: item['isRead'] ? FontWeight.w600 : FontWeight.w900,
                          color: AppTheme.gray900,
                        ),
                      ),
                    ),
                    Text(
                      item['time'],
                      style: const TextStyle(fontSize: 11, color: AppTheme.gray500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['body'],
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.gray600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSignInPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle,
              size: 80,
              color: AppTheme.gray400,
            ),
            const SizedBox(height: 24),
            const Text(
              'Sign in to access your profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.gray800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Manage your preferences, view your activity, and personalize your news experience.',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.push('/phone'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.red500,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Sign In / Sign Up',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewMode() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.gray200, width: 2),
                ),
                child: Center(child: _buildGenderIcon(_gender)),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.gray800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _phone,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.gray500,
                      ),
                    ),
                    if (_state.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '$_district, $_state',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.gray500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                children: [
                   Container(
                    decoration: BoxDecoration(
                      color: AppTheme.gray100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: IconButton(
                      icon: const Icon(Icons.edit_note_rounded, color: AppTheme.gray700),
                      onPressed: () => setState(() => _isEditing = true),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.red500.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.power_settings_new_rounded, color: AppTheme.red500),
                      onPressed: () async {
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      await authProvider.signOut();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Signed out successfully')),
                      );
                    },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Favorite Categories',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.gray700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_selectedCategories.isEmpty)
            const Text(
              'No categories selected.',
              style: TextStyle(fontSize: 14, color: AppTheme.gray500),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedCategories.map((cat) {
                return Chip(
                  label: Text(cat),
                  backgroundColor: AppTheme.red500,
                  labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEditMode() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray800,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: _name),
            onChanged: (value) => _name = value,
          ),
          const SizedBox(height: 16),
          const Text(
            'Gender',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.gray600),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'male',
                  label: Text('Male'),
                  icon: Icon(Icons.male_rounded),
                ),
                ButtonSegment(
                  value: 'female',
                  label: Text('Female'),
                  icon: Icon(Icons.female_rounded),
                ),
                ButtonSegment(
                  value: 'other',
                  label: Text('Other'),
                  icon: Icon(Icons.face_retouching_natural_rounded),
                ),
              ],
              selected: {_gender},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _gender = newSelection.first;
                });
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppTheme.red500.withValues(alpha: 0.1);
                    }
                    return null;
                  },
                ),
                foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppTheme.red500;
                    }
                    return AppTheme.gray700;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Manage Preferences',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray800,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Favorite Categories',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.gray700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableCategories.map((cat) {
              final isSelected = _selectedCategories.contains(cat);
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (_) => _toggleCategory(cat),
                selectedColor: AppTheme.red500,
                backgroundColor: AppTheme.gray50,
                side: BorderSide(
                  color: isSelected ? Colors.transparent : AppTheme.gray200,
                ),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.gray700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Location',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.gray700),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            key: ValueKey('state_$_state'),
            decoration: const InputDecoration(
              labelText: 'State',
              border: OutlineInputBorder(),
            ),
            // Ensure value exists in items to avoid crash
            value: _allStates.any((s) => s.stateNameEnglish == _state) ? _state : null,
            items: _allStates.map((s) {
              return DropdownMenuItem(value: s.stateNameEnglish, child: Text(s.stateNameEnglish));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _state = value ?? '';
                _district = '';
                try {
                  _selectedStateId = _allStates.firstWhere((s) => s.stateNameEnglish == _state).id;
                } catch (_) {
                  _selectedStateId = null;
                }
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            key: ValueKey('district_$_district'), // Force rebuild when value changes
            decoration: const InputDecoration(
              labelText: 'District',
              border: OutlineInputBorder(),
            ),
            // Ensure value exists in items to avoid crash
            value: (_selectedStateId != null && 
                    GeographicService.instance.getDistricts(_selectedStateId!)
                        .any((d) => d.districtNameEnglish == _district)) 
                ? _district : null,
            items: _selectedStateId == null
                ? []
                : GeographicService.instance.getDistricts(_selectedStateId!).map((d) {
                    return DropdownMenuItem(value: d.districtNameEnglish, child: Text(d.districtNameEnglish));
                  }).toList(),
            onChanged: (value) => setState(() => _district = value ?? ''),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => _isEditing = false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gray500,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
