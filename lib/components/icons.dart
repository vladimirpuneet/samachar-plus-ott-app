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
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
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
          alignment: Alignment.center,
          children: [
            // TV Frame Icon
            Icon(
              Icons.tv_rounded,
              size: widget.height * 1.1,
              color: activeColor,
            ),
            // Live Indicator Dot
            if (!isInactive)
              Positioned(
                top: 4,
                right: 4,
                child: FadeTransition(
                  opacity: _pulseAnimation,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'LIVE TV',
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
