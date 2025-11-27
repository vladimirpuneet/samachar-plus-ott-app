import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/models/news_model.dart';
import 'package:samachar_plus_ott_app/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String newsDetail = '/news-detail';
  static const String category = '/category';
  static const String liveTv = '/live-tv';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String search = '/search';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      // Add other routes when screens are created
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case newsDetail:
        return _createRoute(const NewsDetailScreen());
      case category:
        return _createRoute(CategoryScreen(category: settings.arguments as String));
      case liveTv:
        return _createRoute(const LiveTvScreen());
      case profile:
        return _createRoute(const ProfileScreen());
      case notifications:
        return _createRoute(const NotificationsScreen());
      case search:
        return _createRoute(SearchScreen());
      default:
        return _createRoute(const Scaffold(
          body: Center(
            child: Text('Route not found'),
          ),
        ));
    }
  }

  static Route<dynamic> _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

// Placeholder screen classes
class NewsDetailScreen extends StatelessWidget {
  final NewsArticle? article;

  const NewsDetailScreen({super.key, this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Detail')),
      body: Center(child: Text('News Detail Screen - ${article?.title ?? 'Unknown'}')),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$category News')),
      body: Center(child: Text('Category: $category')),
    );
  }
}

class LiveTvScreen extends StatelessWidget {
  const LiveTvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live TV')),
      body: const Center(child: Text('Live TV Screen')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Screen')),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(child: Text('Notifications Screen')),
    );
  }
}

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(child: Text('Search Screen')),
    );
  }
}