import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/header.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../utils/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      _nameController.text = authProvider.user!.email ?? '';
      _emailController.text = authProvider.user!.email ?? '';
    }
  }

  Future<void> _handleSignOut() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();
    if (mounted) {
      context.go(AppRoutes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(
            onLogoClick: () => context.go(AppRoutes.home),
          ),
          Expanded(
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                if (!authProvider.isAuthenticated) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Please sign in to view your profile',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.go(AppRoutes.auth),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  );
                }

                final user = authProvider.user!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red[600]!, Colors.red[400]!],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Text(
                                (user.email ?? 'U')[0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[600],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user.email ?? 'User',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Member since ${_formatDate(DateTime.parse(user.createdAt!))}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Profile Details
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Profile Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = !_isEditing;
                                      });
                                    },
                                    icon: Icon(
                                      _isEditing ? Icons.check : Icons.edit,
                                      color: Colors.red[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              if (_isEditing) ...[
                                TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                  ),
                                  enabled: false,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Save Changes'),
                                ),
                              ] else ...[
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  title: const Text('Name'),
                                  subtitle: Text(_nameController.text),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.email),
                                  title: const Text('Email'),
                                  subtitle: Text(_emailController.text),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.calendar_today),
                                  title: const Text('Member Since'),
                                  subtitle: Text(_formatDate(DateTime.parse(user.createdAt!))),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Settings
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.notifications),
                              title: const Text('Notifications'),
                              subtitle: const Text('Manage your notifications'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () => context.go(AppRoutes.notifications),
                            ),
                            ListTile(
                              leading: const Icon(Icons.favorite),
                              title: const Text('Favorites'),
                              subtitle: const Text('Your saved articles'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                // TODO: Implement favorites screen
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.settings),
                              title: const Text('Settings'),
                              subtitle: const Text('App preferences'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                // TODO: Implement settings screen
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sign Out Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleSignOut,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onProfileClick: () {},
        unreadCount: 0,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}