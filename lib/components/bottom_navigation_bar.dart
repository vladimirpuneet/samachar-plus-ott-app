import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:samachar_plus_ott_app/components/icons.dart';
import 'package:samachar_plus_ott_app/theme.dart';
import 'package:provider/provider.dart';
import 'package:samachar_plus_ott_app/providers/news_provider.dart';

class BottomNavigationBar extends StatelessWidget {
  final VoidCallback? onProfileClick;

  const BottomNavigationBar({
    super.key,
    this.onProfileClick,
  });

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final newsProvider = Provider.of<NewsProvider>(context);
    
    final bool isLiveActive = location == '/live';
    final bool isNewsActive = location == '/news';
    final bool isProfileActive = location == '/profile';
    
    // Get screen width for calculating button widths
    final double screenWidth = MediaQuery.of(context).size.width;
    final double liveWidth = screenWidth * 0.25;
    final double newsWidth = screenWidth * 0.50;
    final double profileWidth = screenWidth * 0.25;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // LIVE TV Button (25%)
            InkWell(
              onTap: () {
                if (location == '/live') return;
                String transition = 'fade';
                if (location == '/news') {
                  transition = 'nav_left';
                } else if (location == '/profile') {
                  transition = 'nav_left';
                }
                context.go('/live', extra: <String, dynamic>{'transition': transition});
              },
              child: Container(
                width: liveWidth,
                alignment: Alignment.center,
                child: LiveIcon(
                  width: 70,
                  height: 30,
                  color: isLiveActive ? AppTheme.red500 : AppTheme.gray500,
                ),
              ),
            ),

            // SIMPLE NEWS Button (50%)
            InkWell(
              onTap: () {
                if (location != '/news') {
                  context.go('/news', extra: <String, dynamic>{'transition': isLiveActive ? 'nav_right' : 'nav_left'});
                }
              },
              child: Container(
                width: newsWidth,
                alignment: Alignment.center,
                child: TextNewsIcon(
                  color: isNewsActive ? AppTheme.red500 : AppTheme.gray500,
                ),
              ),
            ),




            // PROFILE Button (25%)
            InkWell(
              onTap: onProfileClick ?? () {
                if (location == '/profile') return;
                context.go('/profile', extra: <String, dynamic>{'transition': 'nav_right'});
              },
              child: Container(
                width: profileWidth,
                alignment: Alignment.center,
                child: UserIcon(
                  size: 32,
                  color: isProfileActive ? AppTheme.red500 : AppTheme.gray500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
