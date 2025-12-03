import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/utils/app_theme.dart';

class CustomSpinner extends StatefulWidget {
  final double size;
  final Color? color;

  const CustomSpinner({
    super.key,
    this.size = 50.0,
    this.color,
  });

  @override
  State<CustomSpinner> createState() => _CustomSpinnerState();
}

class _CustomSpinnerState extends State<CustomSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Rotating outer ring
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.color ?? AppTheme.primaryColor,
              ),
              strokeWidth: 3,
            ),
            // Static or pulsing logo in center
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.play_circle_outline,
                    color: widget.color ?? AppTheme.primaryColor,
                    size: widget.size * 0.5,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
