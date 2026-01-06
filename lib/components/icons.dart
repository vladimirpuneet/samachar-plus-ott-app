import 'package:flutter/material.dart';

class LiveIcon extends StatefulWidget {
  final double width;
  final double height;
  final Color? color;

  const LiveIcon({super.key, this.width = 70, this.height = 32, this.color});

  @override
  State<LiveIcon> createState() => _LiveIconState();
}

class _LiveIconState extends State<LiveIcon> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // More intense blinking
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.color ?? Colors.black;
    final isInactive = activeColor.opacity < 1.0 && activeColor != Colors.red && activeColor != const Color(0xFFCD1913);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none, // Allow dot to go outside slightly
          alignment: Alignment.center,
          children: [
            // TV Frame Icon
            Icon(
              Icons.tv_rounded,
              size: widget.height * 1.4, // Pre-scaled for better fit
              color: activeColor,
            ),
            // "LIVE" TEXT INSIDE TV - Better Visibility
            if (!isInactive)
              Positioned(
                top: 7, // Precise alignment for TV screen area
                child: FadeTransition(
                  opacity: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.red, // Changed from black to brand red
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9, // Increased size
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            // Live Indicator Dot - CORNER OF BUTTON
            if (!isInactive)
              Positioned(
                top: -2,
                right: -2,
                child: FadeTransition(
                  opacity: _pulseAnimation,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.8),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'NEWS CHANNEL',
          style: TextStyle(
            color: activeColor,
            fontWeight: FontWeight.w900,
            fontSize: 9,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

class TextNewsIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;

  const TextNewsIcon({super.key, this.width = 64, this.height = 32, this.color});

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? Colors.black;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.newspaper_rounded,
          size: height * 1.1,
          color: activeColor,
        ),
        const SizedBox(height: 2),
        Text(
          'NEWS',
          style: TextStyle(
            color: activeColor,
            fontWeight: FontWeight.w900,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class UserIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const UserIcon({super.key, this.size = 32, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.person_pin_rounded, size: size, color: color ?? Colors.black),
        const SizedBox(height: 2),
        Text(
          'PROFILE',
          style: TextStyle(
            color: color ?? Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class BellIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const BellIcon({super.key, this.size = 32, this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.notifications_active_rounded, size: size, color: color ?? Colors.black);
  }
}
