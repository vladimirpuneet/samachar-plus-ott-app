import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/widgets/custom_spinner.dart';
import 'package:samachar_plus_ott_app/constants.dart';
import 'package:samachar_plus_ott_app/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = false;
  
  // Mock user data (replace with actual auth later)
  String _name = 'Guest User';
  String _phone = '+91 XXXXXXXXXX';
  String _gender = 'other';
  String _state = '';
  String _district = '';
  List<String> _selectedCategories = [];

  final List<String> _states = ['Rajasthan', 'Uttar Pradesh', 'Madhya Pradesh', 'Bihar', 'Jharkhand'];
  final Map<String, List<String>> _districts = {
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Udaipur'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Agra'],
    'Madhya Pradesh': ['Bhopal', 'Indore', 'Gwalior'],
    'Bihar': ['Patna', 'Gaya', 'Bhagalpur'],
    'Jharkhand': ['Ranchi', 'Jamshedpur', 'Dhanbad'],
  };

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
    
    // Simulate save
    await Future.delayed(const Duration(seconds: 1));
    
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
    IconData icon = Icons.person;
    if (gender == 'male') {
      icon = Icons.male;
    } else if (gender == 'female') {
      icon = Icons.female;
    }
    return Icon(icon, size: 40, color: AppTheme.gray500);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CustomSpinner());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (_isEditing)
            _buildEditMode()
          else
            _buildViewMode(),
        ],
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
            color: Colors.black.withOpacity(0.05),
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
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppTheme.gray500),
                    onPressed: () => setState(() => _isEditing = true),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: AppTheme.gray500),
                    onPressed: () {
                      // Handle logout
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logout functionality pending')),
                      );
                    },
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
          Row(
            children: ['male', 'female', 'other'].map((g) {
              return Expanded(
                child: RadioListTile<String>(
                  title: Text(g[0].toUpperCase() + g.substring(1)),
                  value: g,
                  groupValue: _gender,
                  onChanged: (value) => setState(() => _gender = value!),
                  dense: true,
                  activeColor: AppTheme.red500,
                ),
              );
            }).toList(),
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
            children: NEWS_CATEGORIES.map((cat) {
              final isSelected = _selectedCategories.contains(cat);
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (_) => _toggleCategory(cat),
                selectedColor: AppTheme.red500,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.gray700,
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
            decoration: const InputDecoration(
              labelText: 'State',
              border: OutlineInputBorder(),
            ),
            value: _state.isEmpty ? null : _state,
            items: _states.map((s) {
              return DropdownMenuItem(value: s, child: Text(s));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _state = value ?? '';
                _district = '';
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'District',
              border: OutlineInputBorder(),
            ),
            value: _district.isEmpty ? null : _district,
            items: _state.isEmpty
                ? []
                : (_districts[_state] ?? []).map((d) {
                    return DropdownMenuItem(value: d, child: Text(d));
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
