import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namma_savaari/customer/customer_home_page.dart';
import 'package:namma_savaari/customer/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false; // Track password visibility
  bool _isConfirmPasswordVisible = false; // Track confirm password visibility
  late bool isSigning = false;
  late bool googleSigning = false;
  @override
  void initState() {
    super.initState();
    // Check login status after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isSigning = true;
        });
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        // Create user with email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Store user information in Firestore (avoid storing passwords in plain text)
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(userCredential.user!.uid)
            .set({
              'uid': userCredential.user!.uid,
              'email': email,
              'status': 'loggedIn',
            });

        // Store login status in SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Navigate to Home page
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CustomerHomePage()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign Up Successful!'),
            backgroundColor: Colors.blue,
          ),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isSigning = false;
        });
      }
    }
  }

  Future<void> _checkLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // No Firebase user, stay on sign-up screen
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection("customers")
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final status = doc.data()?['status'] ?? 'loggedOut';

        if (status == 'loggedIn' && mounted) {
          _navigateToHome();
        } else {
          // User has explicitly logged out → stay on SignUpScreen
          debugPrint("User is loggedOut, staying on SignUpScreen.");
        }
      } else {
        debugPrint("No Firestore record found for this user.");
      }
    } catch (e) {
      debugPrint("Error checking login status: $e");
    }
  }

  // Naviagate to home
  void _navigateToHome() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CustomerHomePage()),
    ); // Make sure '/admin-home' is defined in GoRouter
  }

  // Future<void> _handleGoogleSignIn() async {
  //   if (!mounted) return;
  //   setState(() {
  //     googleSigning = true;
  //   });
  //   log("clicked Google Sign-In button");

  //   bool result = await CustomerGoogleLoginService.customerSignInWithGoogle(
  //       context: context);

  //   if (!mounted) return;
  //   setState(() {
  //     googleSigning = false;
  //   });

  //   if (result) {
  //     log("Sign-In success, saving login state...");
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setBool('isLoggedIn', true);

  //     if (!mounted) return;
  //     context.go('/customerHome');

  //     Fluttertoast.showToast(
  //       msg: "Signed in successfully!",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //     );
  //   } else {
  //     log("Sign-In failed, showing toast to user");
  //     Fluttertoast.showToast(
  //       msg: "Failed to sign in. Try again.",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.pink[300],
      body: Center(
        // Use Center widget to align everything in the center
        child: SingleChildScrollView(
          // Scrollable container in case of small screens
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.redAccent.shade700, Colors.black87],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center vertically
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch, // Stretch to fill width
                  children: [
                    // Title Text
                    const Text(
                      'Create an Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center, // Center align the text
                    ),
                    const SizedBox(height: 20),

                    // Email TextField
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@gmail.com')) {
                          return 'Email must be in the format of @gmail.com';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password TextField
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        if (!RegExp(
                          r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                        ).hasMatch(value)) {
                          return 'Password must include letters, numbers, and symbols';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password TextField
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Register Button
                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white, // Text color
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 60.0,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isSigning
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.blue, // You can change color
                                strokeWidth: 3,
                              ),
                            )
                          : Text('Sign Up'),
                    ),
                    const SizedBox(height: 20),
                    // "Have an account? Sign In" Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already Have an account?',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Sign In Screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ), // Ensure you have a SignInScreen widget
                            );
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // SizedBox(
                    //   height: 55,
                    //   child: ElevatedButton(
                    //     // onPressed: () {
                    //     //   // Handle Google login
                    //     // },
                    //     onPressed: _handleGoogleSignIn,
                    //     style: ElevatedButton.styleFrom(
                    //       foregroundColor: Colors.black,
                    //       backgroundColor: Colors.white,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(30),
                    //       ),
                    //       // side: BorderSide(color: Colors.grey),
                    //     ),
                    //     child: googleSigning
                    //         ? const SizedBox(
                    //             height: 24,
                    //             width: 24,
                    //             child: CircularProgressIndicator(
                    //               color: Colors.blue, // You can change color
                    //               strokeWidth: 3,
                    //             ),
                    //           )
                    //         : RichText(
                    //             text: TextSpan(
                    //               children: [
                    //                 WidgetSpan(
                    //                   alignment: PlaceholderAlignment.middle,
                    //                   child: Image.asset(
                    //                     'assets/google_logo_officiall.png', // Add your Google logo image in the assets
                    //                     width: 24,
                    //                     height: 24,
                    //                   ),
                    //                 ),
                    //                 const TextSpan(
                    //                   text: 'oogle',
                    //                   style: TextStyle(color: Colors.black),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
