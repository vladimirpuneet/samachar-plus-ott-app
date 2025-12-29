import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:samachar_plus_ott_app/components/bottom_navigation_bar.dart' as app_nav;
import 'package:samachar_plus_ott_app/components/header.dart';
import 'package:samachar_plus_ott_app/providers/auth_provider.dart';
import 'package:samachar_plus_ott_app/providers/news_provider.dart';
import 'package:samachar_plus_ott_app/screens/article_screen.dart';
import 'package:samachar_plus_ott_app/screens/live_news_screen.dart';
import 'package:samachar_plus_ott_app/screens/national_news_screen.dart';
import 'package:samachar_plus_ott_app/screens/notifications_screen.dart';
import 'package:samachar_plus_ott_app/screens/otp_verification_screen.dart';
import 'package:samachar_plus_ott_app/screens/phone_input_screen.dart';
import 'package:samachar_plus_ott_app/screens/profile_screen.dart';
import 'package:samachar_plus_ott_app/screens/regional_live_screen.dart';
import 'package:samachar_plus_ott_app/screens/regional_news_screen.dart';
import 'package:samachar_plus_ott_app/theme.dart';
import 'package:samachar_plus_ott_app/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  runApp(const MyApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
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
          path: '/',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context, 
            state: state, 
            child: const RegionalNewsScreen(),
          ),
        ),
        GoRoute(
          path: '/national',
          pageBuilder: (context, state) => _buildPageWithTransition(
             context: context, 
             state: state, 
             child: const NationalNewsScreen(),
          ),
        ),
        GoRoute(
          path: '/live',
          pageBuilder: (context, state) => _buildPageWithTransition(
             context: context, 
             state: state, 
             child: const LiveNewsScreen(),
          ),
        ),
        GoRoute(
          path: '/regional-live',
          pageBuilder: (context, state) => _buildPageWithTransition(
             context: context, 
             state: state, 
             child: const RegionalLiveScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen(),
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
    key: ValueKey(state.uri.toString()), // Force uniqueness based on URI
    child: child,
    transitionDuration: const Duration(milliseconds: 350), // Slightly slower for visibility
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final extraRaw = state.extra;
      final Map<String, dynamic>? extra = extraRaw is Map ? Map<String, dynamic>.from(extraRaw) : null;
      final transitionType = extra?['transition'] as String?;

      if (transitionType == null) {
        return FadeTransition(opacity: animation, child: child);
      }

      Offset begin = Offset.zero;

      if (transitionType == 'vertical') {
        // Vertical Logic
        final isRegional = state.uri.toString() == '/' || state.uri.toString() == '/regional-live';
        // Regional (Bottom) -> Enter from Bottom (0, 1)
        // National (Top) -> Enter from Top (0, -1)
        begin = isRegional ? const Offset(0.0, 1.0) : const Offset(0.0, -1.0);
      } else if (transitionType == 'horizontal') {
        // Horizontal Logic
        final isLive = state.uri.toString().contains('live');
        // Live (Left) -> Enter from Left (-1, 0)
        // News (Right) -> Enter from Right (1, 0)
        begin = isLive ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
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