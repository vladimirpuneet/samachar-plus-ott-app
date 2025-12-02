import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:samachar_plus_ott_app/utils/app_theme.dart';
import 'package:samachar_plus_ott_app/widgets/custom_bottom_nav.dart';
import 'package:samachar_plus_ott_app/screens/live_news_screen.dart';
import 'package:samachar_plus_ott_app/screens/regional_live_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Samachar Plus',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Force light mode for now to match React app default
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
        scrollbars: false,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isRegional = false;
  bool _isSearchOpen = false;
  final TextEditingController _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onToggleRegional(bool isRegional) {
    setState(() {
      _isRegional = isRegional;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchOpen = !_isSearchOpen;
      if (!_isSearchOpen) {
        _searchController.clear();
        FocusScope.of(context).unfocus();
      }
    });
  }

  Widget _getBody() {
    if (_selectedIndex == 0) {
      return const NewsTab();
    } else if (_selectedIndex == 1) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final isRegional = child.key == const ValueKey('regional');
          // Vertical slide: Regional slides up from bottom, National slides down from top
          final offset = isRegional ? const Offset(0.0, 1.0) : const Offset(0.0, -1.0);
          
          return SlideTransition(
            position: Tween<Offset>(
              begin: offset,
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: _isRegional
            ? const RegionalLiveScreen(key: ValueKey('regional'))
            : const LiveNewsScreen(key: ValueKey('national')),
      );
    } else {
      return const ProfileTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68.0,
        backgroundColor: AppTheme.primaryColor,
        elevation: 4,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.gif',
              height: 56,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Text(
                'समाचार प्लस',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isSearchOpen ? 200 : 0,
              height: 40,
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: _isSearchOpen
                  ? TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                          onPressed: _toggleSearch,
                        ),
                      ),
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      onSubmitted: (value) {
                        // TODO: Implement search functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Searching for: $value')),
                        );
                      },
                    )
                  : null,
            ),
            IconButton(
              icon: Icon(
                _isSearchOpen ? Icons.search_off : Icons.search,
                color: Colors.white,
                size: 28,
              ),
              onPressed: _toggleSearch,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: _getBody(),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        isRegional: _isRegional,
        onToggleRegional: _onToggleRegional,
      ),
    );
  }
}

class NewsTab extends StatelessWidget {
  const NewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Text('${index + 1}'),
            ),
            title: Text(
              'Sample News Article ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'This is a sample news article description that mimics the layout of the news card.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening article ${index + 1}')),
              );
            },
          ),
        );
      },
    );
  }
}


class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, size: 50, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Text(
            'Guest User',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Welcome to Samachar Plus'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login feature coming soon!')),
              );
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}