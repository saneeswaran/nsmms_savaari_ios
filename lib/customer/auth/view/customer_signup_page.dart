import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:namma_savaari/customer/auth/service/auth_service.dart';
import 'package:namma_savaari/customer/auth/view/customer_login_page.dart';
import 'package:namma_savaari/customer/customer_home_page.dart';
import 'package:namma_savaari/customer/widgets/auth_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';

class CustomerSignupPage extends StatefulWidget {
  const CustomerSignupPage({super.key});

  @override
  _CustomerSignupPageState createState() => _CustomerSignupPageState();
}

class _CustomerSignupPageState extends State<CustomerSignupPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isSigningIn = false;

  // --> Firebase Email AUTH
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final verifyPasswordController = TextEditingController();

  // Gender
  String? selectedGender;
  final auth = AuthService();
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Check login status when widget initializes
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Get the current user ID
      final User? user = FirebaseAuth.instance.currentUser;
      final String? userId = user?.uid;

      if (userId != null) {
        // Fetch the login status from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('customers')
            .doc(userId)
            .get();

        if (userDoc.exists && userDoc['status'] == 'loggedIn') {
          // Navigate to HomePage if the status is 'loggedIn'
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          });
          return;
        }
      }
    }

  }

  // ---> SignUp
  Future<void> signUpAuth() async {
    try {
      setState(() {
        _isSigningIn = true;
      });
      log("Starting signup process...");

      // Check passwords match
      if (passwordController.text.trim() !=
          verifyPasswordController.text.trim()) {
        log("Passwords do not match");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      // Check gender selected
      if (selectedGender == null) {
        log("Gender not selected");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a gender")),
        );
        return;
      }

      log("Creating Firebase Auth user...");

      // Create user in Firebase Auth
      final user = await auth.signUpWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
      );

      if (user != null) {
        log("Firebase Auth signup successful: ${user.uid}");
        log("Preparing to send verification email to: ${user.email}");

        try {
          await user.sendEmailVerification();
          log("Verification email sent successfully to ${user.email}");
        } on FirebaseAuthException catch (e) {
          log("FirebaseAuthException while sending verification: ${e.code} | ${e.message}");
        } catch (e, st) {
          log("Unexpected error while sending verification: $e");
          log("Stacktrace: $st");
        }

        // Save login state locally for later verification
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false); // Not fully logged in yet
        await prefs.setString('name', nameController.text.trim());
        log("🔹 SharedPreferences updated with isLoggedIn=false");

        if (!mounted) return;
        context.go('/email-verification');
      } else {
        log("User is null after signup");
      }
    } catch (e, stackTrace) {
      log("Signup error: $e");
      log("StackTrace: $stackTrace");

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.redAccent.shade700, Colors.black87],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Welcome to\nNamma Savaari!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Image.asset(
                          'assets/Namma_Savaari_LOGO1.png',
                          height: 230,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Your journey starts here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.yellow,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Find, book, and travel with ease.\nEnjoy seamless bus ticket booking!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      // EMAIL
                      AuthTextfield(
                          controller: emailController, label: "Email"),

                      // NAME
                      AuthTextfield(controller: nameController, label: "Name"),

                      // GENDER
                      DropdownButtonFormField(
                          items: const [
                            DropdownMenuItem(
                                value: "Male",
                                child: Text(
                                  "Male",
                                  style: TextStyle(color: Colors.white),
                                )),
                            DropdownMenuItem(
                                value: "Female",
                                child: Text(
                                  "Female",
                                  style: TextStyle(color: Colors.white),
                                )),
                            DropdownMenuItem(
                                value: "Other",
                                child: Text(
                                  "Other",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                          dropdownColor: Colors.black,
                          decoration: InputDecoration(
                            labelText: "Gender",
                            labelStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          }),
                      // PASSWORD
                      AuthTextfield(
                        controller: passwordController,
                        label: "Password",
                        obscureText: true,
                      ),

                      // VERIFICATION PASSWORD
                      AuthTextfield(
                        controller: verifyPasswordController,
                        label: "Verify Password",
                        obscureText: true,
                      ),

                      const SizedBox(height: 16),
                      // SIGN UP
                      InkWell(
                        onTap: signUpAuth,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 07,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 119, 216),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: _isSigningIn
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomerLoginPage()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Log in",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 77, 139),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
