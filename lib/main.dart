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
          builder: (context, state) => const RegionalNewsScreen(),
        ),
        GoRoute(
          path: '/national',
          builder: (context, state) => const NationalNewsScreen(),
        ),
        GoRoute(
          path: '/live',
          builder: (context, state) => const LiveNewsScreen(),
        ),
        GoRoute(
          path: '/regional-live',
          builder: (context, state) => const RegionalLiveScreen(),
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