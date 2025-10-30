import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namma_savaari/customer/welcome_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customer_home_page.dart';

class TrendyLoadingScreen extends StatefulWidget {
  const TrendyLoadingScreen({super.key});

  @override
  _TrendyLoadingScreenState createState() => _TrendyLoadingScreenState();
}

class _TrendyLoadingScreenState extends State<TrendyLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _scaleFactor = 1.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Navigate to home screen after 5 seconds
    // Future<void> _checkLoginStatus() async {
    //
    //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    //
    //   // Simulate a slight delay to showcase the animation
    //   await Future.delayed(Duration(seconds: 3));
    //
    //   if (isLoggedIn) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => HomePage()),
    //     );
    //   } else {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => WelcomePage()),
    //     );
    //   }
    // }

    Future<void> checkLoginStatus() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      // Simulate a slight delay to showcase the animation
      await Future.delayed(const Duration(seconds: 3));

      if (isLoggedIn) {
        // Get the current user ID
        final User? user = _auth.currentUser;
        final String? userId = user?.uid;

        if (userId != null) {
          // Fetch the login status from Firestore
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('customers')
              .doc(userId)
              .get();

          if (userDoc.exists && userDoc['status'] == 'loggedIn' && mounted) {
            // Navigate to HomePage if the status is 'loggedIn'
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CustomerHomePage()),
            );
            return;
          }
        }
      }

      // Navigate to WelcomePage if the status is not 'loggedIn' or the user is not logged in
   if(mounted) {
     Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomePage()),
      );
   }
    }

    checkLoginStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    setState(() {
      _scaleFactor = _scaleFactor == 1.0 ? 1.1 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Scaffold(
        body: Stack(
          children: [
            // Background Gradient Animation
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(color: Colors.redAccent.shade700),
                );
              },
            ),

            // Shimmer Effect for Logo
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Transform.scale(
                  //   scale: _scaleFactor,
                  //   child: Icon(
                  //     Icons.directions_bus,
                  //     color: Colors.white,
                  //     size: 70,
                  //   ),
                  // ),
                  Transform.scale(
                    scale: _scaleFactor,
                    child: Image.asset(
                      'assets/Namma_Savaari_LOGO1.png', // Replace with your image path
                      width:
                          150, // You can set the width or height as per your design
                      height:
                          150, // Ensures the image maintains the aspect ratio
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Enhanced Animated Text
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final scale = 1 + 0.05 * sin(_controller.value * 2 * pi);
                      const baseColor = Colors.white;
                      final highlightColor = Colors.cyan.shade100;
                      return Transform.scale(
                        scale: scale,
                        child: Shimmer.fromColors(
                          baseColor: baseColor,
                          highlightColor: highlightColor,
                          child: const Text(
                            "Namma Savaari",
                            style: TextStyle(
                              fontSize: 45,
                              fontFamily: 'DK More Or Less',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.white,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // Pulsating Loading Text
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + 0.1 * sin(_controller.value * 2 * pi),
                        child: const Text(
                          "Loading...",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Particles Animation
            Positioned.fill(
              child: CustomPaint(
                painter: ParticlePainter(controller: _controller),
              ),
            ),

            // Bottom Loading Line Animation
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    valueColor: _controller.drive(
                      ColorTween(
                        begin: Colors.white,
                        end: Colors.pink,
                      ),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Particle Painter for a dynamic background effect
class ParticlePainter extends CustomPainter {
  final Animation<double> controller;

  ParticlePainter({required this.controller}) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.3);
    final random = Random();
    for (int i = 0; i < 50; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3;
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
