import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:namma_savaari/customer/customer_splash_page.dart';
import 'package:namma_savaari/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'customer/theme_provider.dart';

void main() async {
  WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  try {
    log("Initializing Firebase...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log(" Firebase initialized successfully!");
  } catch (e, stack) {
    log(" Firebase initialization failed: $e", stackTrace: stack);
  }
  FlutterNativeSplash.remove();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return MaterialApp(
      title: 'Namma Savaari',
      theme: ThemeData(
        fontFamily: kIsWeb ? "Montserrat" : null,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: const CustomerSplashPage(),
    );
  }
}
