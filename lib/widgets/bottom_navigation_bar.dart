import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_routes.dart';

class BottomNavigationBar extends StatelessWidget {
  final VoidCallback? onProfileClick;
  final int unreadCount;

  const BottomNavigationBar({
    super.key,
    this.onProfileClick,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home,
                label: 'Home',
                route: AppRoutes.home,
                isActive: currentRoute == AppRoutes.home,
              ),
              _buildNavItem(
                context,
                icon: Icons.article,
                label: 'National',
                route: AppRoutes.national,
                isActive: currentRoute == AppRoutes.national,
              ),
              _buildNavItem(
                context,
                icon: Icons.tv,
                label: 'Live',
                route: AppRoutes.live,
                isActive: currentRoute == AppRoutes.live,
              ),
              _buildNavItem(
                context,
                icon: Icons.notifications,
                label: 'Alerts',
                route: AppRoutes.notifications,
                isActive: currentRoute == AppRoutes.notifications,
                badgeCount: unreadCount,
              ),
              GestureDetector(
                onTap: onProfileClick ?? () => context.go(AppRoutes.profile),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person,
                      color: currentRoute == AppRoutes.profile 
                          ? Colors.red[600] 
                          : Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 10,
                        color: currentRoute == AppRoutes.profile 
                            ? Colors.red[600] 
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
    int badgeCount = 0,
  }) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.red[600] : Colors.grey,
                size: 24,
              ),
              if (badgeCount > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      badgeCount > 99 ? '99+' : badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? Colors.red[600] : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}