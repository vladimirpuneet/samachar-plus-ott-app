import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isActive;

  const BottomNavButton({
    super.key,
    required this.icon,
    required this.label,
    required this.route,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final isCurrentRoute = currentRoute == route;

    return GestureDetector(
      onTap: () => context.push(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isCurrentRoute ? Colors.red[600] : Colors.grey,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isCurrentRoute ? Colors.red[600] : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}