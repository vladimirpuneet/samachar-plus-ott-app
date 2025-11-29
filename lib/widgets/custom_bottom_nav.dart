import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/utils/app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isRegional;
  final Function(bool) onToggleRegional;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.isRegional,
    required this.onToggleRegional,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // User Profile
          NavIcon(
            icon: Icons.person_outline,
            isSelected: selectedIndex == 2,
            onTap: () => onItemTapped(2),
          ),

          // Live TV
          TextIcon(
            text: 'LIVE TV',
            isSelected: selectedIndex == 1,
            onTap: () => onItemTapped(1),
          ),

          // Toggle Switch
          ContentToggle(
            isRegional: isRegional,
            onToggle: onToggleRegional,
          ),

          // News
          TextIcon(
            text: 'NEWS',
            isSelected: selectedIndex == 0,
            onTap: () => onItemTapped(0),
          ),

          // Notifications
          NavIcon(
            icon: Icons.notifications_none,
            isSelected: false, // Notifications screen not part of main tabs usually
            onTap: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
    );
  }
}

class NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const NavIcon({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          size: 28,
          color: isSelected ? AppTheme.primaryColor : Colors.grey,
        ),
      ),
    );
  }
}

class TextIcon extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TextIcon({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryColor : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

class ContentToggle extends StatelessWidget {
  final bool isRegional;
  final Function(bool) onToggle;

  const ContentToggle({
    super.key,
    required this.isRegional,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: isRegional ? 30 : 0,
            left: 0,
            right: 0,
            height: 30,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => onToggle(false),
                  child: Center(
                    child: Text(
                      'National',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: !isRegional ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => onToggle(true),
                  child: Center(
                    child: Text(
                      'Regional',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isRegional ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
