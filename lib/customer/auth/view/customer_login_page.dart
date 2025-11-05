import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namma_savaari/customer/auth/service/auth_service.dart';
import 'package:namma_savaari/customer/auth/view/customer_signup_page.dart';
import 'package:namma_savaari/customer/customer_home_page.dart';
import 'package:namma_savaari/customer/widgets/auth_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';

class CustomerLoginPage extends StatefulWidget {
  const CustomerLoginPage({super.key});

  @override
  _CustomerLoginPageState createState() => _CustomerLoginPageState();
}

class _CustomerLoginPageState extends State<CustomerLoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isSigningIn = false;

  // --> Firebase Email AUTH
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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

  // LOGIN
  Future<void> loginAuth() async {
    try {
      setState(() {
        _isSigningIn = true; // start loading
      });

      log("🔹 Starting login process...");

      // Login with Firebase
      final user = await auth.signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null) {
        log("Login successful for ${user.uid}");

        // Check if email is verified
        if (!user.emailVerified) {
          log("Email not verified for ${user.email}");
          await auth.signOut(); // Sign out unverified user

          if (!mounted) return;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text("Email not verified"),
              content: Text(
                "Please verify your email (${user.email}) before logging in.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
          return;
        }

        // Email is verified , now save user info in Firestore
        final userDoc = FirebaseFirestore.instance
            .collection("customers")
            .doc(user.uid);

        final docSnapshot = await userDoc.get();
        if (!docSnapshot.exists) {
          // If document doesn't exist, save user data
          final prefs = await SharedPreferences.getInstance();
          final name =
              prefs.getString("name") ?? emailController.text.split('@')[0];
          final phone = prefs.getString("phoneNumber");
          final gender = prefs.getString("gender");

          await userDoc.set({
            "uid": user.uid,
            "email": user.email,
            "name": name,
            "phone": phone,
            "gender": gender,
            "feedback": null,
            "status": "loggedIn",
            "createdAt": FieldValue.serverTimestamp(),
          });
          log("Firestore document created for ${user.uid}");
        } else {
          // Update status if document exists
          await userDoc.update({"status": "loggedIn"});
          log("Firestore document updated with status=loggedIn");
        }

        // Save login state locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        log("SharedPreferences updated with isLoggedIn=true");

        // Navigate to home page
        if (!mounted) return;
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CustomerHomePage()),
        );
      }
    } catch (e, stackTrace) {
      log("Login error: $e");
      log("StackTrace: $stackTrace");

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false; // stop loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height,
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
                        controller: emailController,
                        label: "Email",
                      ),

                      // PASSWORD
                      AuthTextfield(
                        controller: passwordController,
                        label: "Password",
                        obscureText: true,
                      ),

                      const SizedBox(height: 16),

                      // SIGN UP
                      InkWell(
                        onTap: loginAuth,
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
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account yet? ",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CustomerSignupPage(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 77, 139),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 100),
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
