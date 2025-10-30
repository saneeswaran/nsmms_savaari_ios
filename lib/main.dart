import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:namma_savaari/customer/auth/view/customer_login_page.dart';
import 'package:namma_savaari/customer/auth/view/customer_signup_page.dart';
import 'package:namma_savaari/customer/auth/view/email_verification_page.dart';
import 'package:namma_savaari/customer/customer_home_page.dart';
import 'package:namma_savaari/customer/customer_splash_page.dart';
import 'package:namma_savaari/customer/services.dart';
import 'package:namma_savaari/customer/sign_up_screen.dart';
import 'package:namma_savaari/customer/version_checker.dart';
import 'package:namma_savaari/customer/welcome_screen.dart';
import 'package:namma_savaari/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'customer/customer_help_topics.dart';
import 'customer/theme_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: kIsWeb ? DefaultFirebaseOptions.currentPlatform : null,
  );

  try {
    log("Initializing Firebase...");
    await Firebase.initializeApp(
      options: kIsWeb ? DefaultFirebaseOptions.currentPlatform : null,
    );
    log(" Firebase initialized successfully!");
  } catch (e, stack) {
    log(" Firebase initialization failed: $e", stackTrace: stack);
  }

  // Initialize Local Notifications (only for mobile)
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CityProvider()),
      ],
      child: const VersionCheckWrapper(child: MyApp()),
    ),
  );

  FlutterNativeSplash.remove();
}

// GoRouter setup
final GoRouter _router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => _getHomeScreen(),
    ),
    GoRoute(
      path: "/home",
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: "/email-verification",
      builder: (context, state) => const EmailVerificationPage(),
    ),
    GoRoute(
      path: "/login",
      builder: (context, state) => const CustomerLoginPage(),
    ),
    GoRoute(
      path: "/signup",
      builder: (context, state) => const CustomerSignupPage(),
    ),
    // GoRoute(
    //   path: "/services",
    //   builder: (context, state) => ServicesPage(),
    // ),
    // GoRoute(
    //   path: "/visi",
    //   builder: (context, state) => VisiPage(),
    // ),
    GoRoute(
      path: "/signin",
      builder: (context, state) => WelcomePage(),
    ),
    // Customer
    GoRoute(
      path: "/customerHome",
      builder: (context, state) => CustomerHomePage(),
    ),
    GoRoute(
      path: "/customerSginUpScreen",
      builder: (context, state) => SignUpScreen(),
    ),
    GoRoute(
      path: "/helptopics",
      builder: (context, state) => HelpTopicsScreen(),
    ),
  ],
);

/// Determines the correct home screen based on the platform
Widget _getHomeScreen() {
  if (kIsWeb) {
  } else if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    return CustomerSplashPage();
  } else {
    return CustomerSplashPage();
  }

  return CustomerSplashPage();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return MaterialApp.router(
      title: 'Namma Savaari',
      theme: ThemeData(
        fontFamily: kIsWeb ? "Montserrat" : null,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
