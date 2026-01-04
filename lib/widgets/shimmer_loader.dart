import 'package:flutter/material.dart';

class ShimmerLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value, 0),
              end: const Alignment(1, 0),
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
            ),
          ),
        );
      },
    );
  }
}

class ShimmerNewsCard extends StatelessWidget {
  const ShimmerNewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerLoader(width: double.infinity, height: 180, borderRadius: 12),
          const SizedBox(height: 16),
          const ShimmerLoader(width: 250, height: 20),
          const SizedBox(height: 8),
          const ShimmerLoader(width: double.infinity, height: 14),
          const SizedBox(height: 4),
          const ShimmerLoader(width: 200, height: 14),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerLoader(width: 80, height: 12),
              ShimmerLoader(width: 60, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}

class ShimmerChannelCard extends StatelessWidget {
  const ShimmerChannelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShimmerLoader(width: double.infinity, height: 100, borderRadius: 12),
        const SizedBox(height: 8),
        const ShimmerLoader(width: 60, height: 10),
      ],
    );
  }
}
