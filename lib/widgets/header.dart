import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final VoidCallback? onLogoClick;

  const Header({super.key, this.onLogoClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red[600],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: onLogoClick,
                child: Container(
                  child: Image.network(
                    'https://s12.gifyu.com/images/b38qq.gif',
                    height: 56,
                    width: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.article,
                        color: Colors.white,
                        size: 40,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}