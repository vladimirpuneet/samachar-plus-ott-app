import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_routes.dart';
import '../providers/auth_provider.dart';
import '../widgets/bottom_nav_button.dart';
import '../widgets/unread_badge.dart';

class BottomNavigationBar extends StatelessWidget {
  final VoidCallback onProfileClick;
  final int unreadCount;

  const BottomNavigationBar({
    super.key,
    required this.onProfileClick,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, -2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Profile button
            Expanded(
              child: GestureDetector(
                onTap: onProfileClick,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: 24,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            
            // News/Timeline button
            const Expanded(
              child: BottomNavButton(
                icon: Icons.timeline,
                label: 'Timeline',
                route: AppRoutes.home,
              ),
            ),
            
            // Notifications button
            Expanded(
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.notifications),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        const Icon(
                          Icons.notifications,
                          size: 24,
                          color: Colors.grey,
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: UnreadBadge(count: unreadCount),
                          ),
                      ],
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
}