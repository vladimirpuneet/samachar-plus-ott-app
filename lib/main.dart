import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:samachar_plus_ott_app/components/bottom_navigation_bar.dart' as app_nav;
import 'package:samachar_plus_ott_app/components/header.dart';
import 'package:samachar_plus_ott_app/providers/auth_provider.dart';
import 'package:samachar_plus_ott_app/providers/news_provider.dart';
import 'package:samachar_plus_ott_app/screens/article_screen.dart';
import 'package:samachar_plus_ott_app/screens/live_tv_screen.dart';
import 'package:samachar_plus_ott_app/screens/news_screen.dart';
import 'package:samachar_plus_ott_app/screens/otp_verification_screen.dart';
import 'package:samachar_plus_ott_app/screens/phone_input_screen.dart';
import 'package:samachar_plus_ott_app/screens/profile_screen.dart';
import 'package:samachar_plus_ott_app/theme.dart';
import 'package:samachar_plus_ott_app/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:samachar_plus_ott_app/services/geographic_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  // Initialize geographic cache early
  await GeographicService.instance.refreshCache();

  runApp(const MyApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/live',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return Scaffold(
          appBar: const Header(),
          body: child,
          bottomNavigationBar: const app_nav.BottomNavigationBar(),
        );
      },
      routes: [
        GoRoute(
          path: '/live',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const LiveTVScreen(),
          ),
        ),
        GoRoute(
          path: '/news',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const NewsScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const ProfileScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/phone',
      builder: (context, state) => const PhoneInputScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OtpVerificationScreen(),
    ),
    GoRoute(
      path: '/article/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ArticleScreen(articleId: id);
      },
    ),
  ],
);

CustomTransitionPage _buildPageWithTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: ValueKey(state.uri.toString()),
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final extraRaw = state.extra;
      final Map<String, dynamic>? extra = extraRaw is Map ? Map<String, dynamic>.from(extraRaw) : null;
      final transitionType = extra?['transition'] as String?;

      if (transitionType == null) {
        return FadeTransition(opacity: animation, child: child);
      }

      Offset begin = Offset.zero;

      if (transitionType == 'nav_right') {
        // Navigating to Right -> Enter from Right
        begin = const Offset(1.0, 0.0);
      } else if (transitionType == 'nav_left') {
        // Navigating to Left -> Enter from Left
        begin = const Offset(-1.0, 0.0);
      } else {
        return FadeTransition(opacity: animation, child: child);
      }

      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: Offset.zero).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MaterialApp.router(
        title: 'Samachar Plus OTT',
        theme: AppTheme.lightTheme,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}