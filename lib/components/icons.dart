import 'package:flutter/material.dart';

class LiveIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;

  const LiveIcon({super.key, this.width = 64, this.height = 32, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: color ?? Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        'LIVE',
        style: TextStyle(
          color: color ?? Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: height * 0.45,
        ),
      ),
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
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: color ?? Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        'NEWS',
        style: TextStyle(
          color: color ?? Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: height * 0.45,
        ),
      ),
    );
  }
}

class UserIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const UserIcon({super.key, this.size = 32, this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.person, size: size, color: color ?? Colors.black);
  }
}

class BellIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const BellIcon({super.key, this.size = 32, this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.notifications_outlined, size: size, color: color ?? Colors.black);
  }
}
