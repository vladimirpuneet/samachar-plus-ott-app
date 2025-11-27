import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:samachar_plus_ott_app/theme.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onLogoClick;

  const Header({super.key, this.onLogoClick});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.red500,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      centerTitle: false,
      titleSpacing: 0,
      leadingWidth: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: InkWell(
          onTap: onLogoClick ?? () => context.go('/news'),
          child: SizedBox(
            height: 56, // h-14 = 3.5rem = 56px
            child: CachedNetworkImage(
              imageUrl: "https://s12.gifyu.com/images/b38qq.gif",
              fit: BoxFit.contain,
              placeholder: (context, url) => const SizedBox(),
              errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(68); // h-[68px]
}
