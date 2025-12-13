import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/models.dart';

class ChannelCard extends StatelessWidget {
  final LiveChannel channel;
  final VoidCallback onTap;

  const ChannelCard({
    super.key,
    required this.channel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          channel.logoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, color: Colors.grey, size: 32),
              SizedBox(height: 4),
              Text(
                'No Logo',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
