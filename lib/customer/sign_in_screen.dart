import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namma_savaari/customer/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cust_forgot_password_screen.dart';
import 'customer_home_page.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false; // Track password visibility
  bool isSigning = false;
  bool googleSigning = false;

  Future<void> _signIn() async {
    setState(() {
      isSigning = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        // Sign in user with email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        // Set the logged-in status in SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Update logged-in status in Firestore
        final userId = userCredential.user?.uid; // Get the user ID
        if (userId != null) {
          await FirebaseFirestore.instance
              .collection('customers')
              .doc(userId)
              .set(
                {'status': 'loggedIn'},
                SetOptions(merge: true),
              ); // Use merge to avoid overwriting existing data
        }

        // Navigate to Home page
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage()),
        // );

        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => const CustomerHomePage()),
        //   (Route<dynamic> route) => false,
        // );
        // Navigate to Home page
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign In Successful!'),
            backgroundColor: Colors.blue,
          ),
        );
        if (!mounted) return;
        // context.go("/customerHome");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CustomerHomePage()),
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

  //     Fluttertoast.showToast(
  //       msg: "Signed in successfully!",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //     );
  //                           if(!mounted) return;
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (_) => const CustomerHomePage()),
  //     );
  //     // if (!mounted) return;
  //     // context.go('/customerHome');
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title Text
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Email TextField
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.grey[300]),
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
                      obscureText: !_isPasswordVisible, // Password visibility
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.grey[300]),
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
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CustForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Sign In Button
                    ElevatedButton(
                      onPressed: _signIn,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.pink[300],
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
                          : Text('Sign In'),
                    ),
                    const SizedBox(height: 20),
                    // "Don't Have an account? Sign Up" Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Do not have an account?',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Sign In Screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ), // Ensure you have a SignInScreen widget
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey[400], thickness: 1),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Or login with',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Divider(color: Colors.grey[400], thickness: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // SizedBox(
                    //   height: 55,
                    //   child: ElevatedButton(
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
