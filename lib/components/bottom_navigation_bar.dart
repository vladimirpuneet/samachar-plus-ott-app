import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:samachar_plus_ott_app/components/icons.dart';
import 'package:samachar_plus_ott_app/components/uni_button.dart';
import 'package:samachar_plus_ott_app/theme.dart';

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
    final String location = GoRouterState.of(context).uri.toString();
    final bool isProfileActive = location == '/profile';
    final bool isNotificationsActive = location == '/notifications';

    return Container(
      height: 80, // Adjust height as needed
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Profile Button
            InkWell(
              onTap: onProfileClick ?? () => context.go('/profile'),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: UserIcon(
                  size: 32,
                  color: isProfileActive ? AppTheme.red500 : AppTheme.gray500,
                ),
              ),
            ),

            // UniButton (Center)
            const UniButton(),

            // Notifications Button
            InkWell(
              onTap: () => context.go('/notifications'),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: BellIcon(
                      size: 32,
                      color: isNotificationsActive ? AppTheme.red500 : AppTheme.gray500,
                    ),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.red500,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$unreadCount',
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
            ),
          ],
        ),
      ),
    );
  }
}
