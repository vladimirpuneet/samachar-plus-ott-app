import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/header.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../utils/app_routes.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
                          Icons.notifications_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Please sign in to view notifications',
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

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue[50],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Stay updated with the latest news',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _buildNotificationsList(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onProfileClick: () => context.go(AppRoutes.profile),
        unreadCount: 0,
      ),
    );
  }

  Widget _buildNotificationsList() {
    // Mock notifications - in real app this would come from provider
    final mockNotifications = [
      {
        'title': 'Breaking News',
        'message': 'Major development in the tech industry',
        'time': '5 minutes ago',
        'isRead': false,
      },
      {
        'title': 'Sports Update',
        'message': 'Local team wins championship',
        'time': '1 hour ago',
        'isRead': false,
      },
      {
        'title': 'Daily Digest',
        'message': 'Your personalized news summary is ready',
        'time': '3 hours ago',
        'isRead': true,
      },
    ];

    if (mockNotifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We\'ll notify you when there\'s something new',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockNotifications.length,
      itemBuilder: (context, index) {
        final notification = mockNotifications[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: notification['isRead'] == false ? 2 : 1,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: notification['isRead'] == false 
                ? Colors.red[100] 
                : Colors.grey[100],
              child: Icon(
                Icons.notifications,
                color: notification['isRead'] == false 
                  ? Colors.red[600] 
                  : Colors.grey[600],
              ),
            ),
            title: Text(
              notification['title'] as String,
              style: TextStyle(
                fontWeight: notification['isRead'] == false 
                  ? FontWeight.bold 
                  : FontWeight.normal,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification['message'] as String),
                const SizedBox(height: 4),
                Text(
                  notification['time'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            trailing: notification['isRead'] == false
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
            onTap: () {
              // TODO: Mark notification as read and handle navigation
            },
          ),
        );
      },
    );
  }
}