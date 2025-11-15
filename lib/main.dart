import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:samachar_plus_ott_app/services/firebase_service.dart';
import 'package:samachar_plus_ott_app/services/supabase_service.dart';
import 'package:samachar_plus_ott_app/providers/auth_provider.dart';
import 'package:samachar_plus_ott_app/providers/news_provider.dart';
import 'package:samachar_plus_ott_app/screens/splash_screen.dart';
import 'package:samachar_plus_ott_app/utils/app_routes.dart';
import 'package:samachar_plus_ott_app/utils/app_theme.dart';
import 'package:samachar_plus_ott_app/firebase_options.dart';
import 'env/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Supabase
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const SamacharPlusApp());
}

class SamacharPlusApp extends StatelessWidget {
  const SamacharPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MaterialApp(
        title: 'Samachar Plus OTT',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        locale: const Locale('en', 'IN'),
        supportedLocales: const [
          Locale('en', 'IN'),
          Locale('hi', 'IN'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}