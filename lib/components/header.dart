import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:samachar_plus_ott_app/providers/news_provider.dart';
import 'package:samachar_plus_ott_app/theme.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onLogoClick;

  const Header({super.key, this.onLogoClick});

  @override
  State<Header> createState() => _HeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(68); // h-[68px]
}

class _HeaderState extends State<Header> {
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleSearch() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (!_isExpanded) {
        _searchController.clear();
        Provider.of<NewsProvider>(context, listen: false).setSearchQuery(''); // Clear search in provider
      }
    });
  }

  void _submitSearch(String query) {
    if (query.trim().isEmpty) return;

    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    
    // Disable district filter when searching
    newsProvider.setDistrictFilter(false);
    
    // Navigate to news screen
    context.go('/news');
    
    // Set query AFTER navigation
    newsProvider.setSearchQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // 40% of screen width
    final double searchBoxWidth = screenWidth * 0.4;

    return AppBar(
      toolbarHeight: 68, // Explicitly match preferredSize
      backgroundColor: AppTheme.red500,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      centerTitle: false,
      titleSpacing: 0,
      leadingWidth: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: InkWell(
          onTap: widget.onLogoClick ?? () => context.go('/live'),
          child: SizedBox(
            height: 56, // h-14 = 3.5rem = 56px
            child: Image.asset(
              'assets/images/logo.gif',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, color: Colors.white),
            ),
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Search Box
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: _isExpanded ? searchBoxWidth : 0,
              height: 40,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: _isExpanded
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.only(left: 12, top: 0, bottom: 0, right: 0),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.search, color: AppTheme.red500, size: 20),
                          onPressed: () => _submitSearch(_searchController.text),
                        ),
                      ),
                      onSubmitted: _submitSearch,
                    )
                  : null,
            ),
            // Toggle Button
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(
                  _isExpanded ? Icons.close : Icons.search,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: _toggleSearch,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
