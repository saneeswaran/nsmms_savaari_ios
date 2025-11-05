import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_savaari/customer/auth/view/customer_signup_page.dart';
import 'package:namma_savaari/customer/customer_home_page.dart';

class CustomerSplashPage extends StatefulWidget {
  const CustomerSplashPage({super.key});

  @override
  State<CustomerSplashPage> createState() => _CustomerSplashPageState();
}

class _CustomerSplashPageState extends State<CustomerSplashPage> {
  @override
  void initState() {
    super.initState();

    // Delay the navigation until after the frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // No user signed in → go to SignUp
      _navigateToSignUp();
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection("customers")
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data()?['status'] == 'loggedIn') {
        // User is logged in → navigate to Home
        _navigateToHome();
      } else {
        // Not logged in or no status → navigate to SignUp
        _navigateToSignUp();
      }
    } catch (e) {
      // On error → navigate to SignUp
      _navigateToSignUp();
    }
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CustomerHomePage()),
    );
  }

  void _navigateToSignUp() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CustomerSignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.redAccent.shade700, Colors.black87],
          ),
        ),
      ),
    );
  }
}
