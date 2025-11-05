import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namma_savaari/customer/auth/view/customer_login_page.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();
    // Allow resending after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => canResendEmail = true);
      }
    });
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      debugPrint("Error sending email verification: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> checkEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CustomerLoginPage()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Email not verified yet")));
      }
    } catch (e) {
      debugPrint("Error checking email verification: $e");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Email Verification")),
    body: SingleChildScrollView(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.redAccent.shade700, Colors.black87],
            ),
          ),
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
                    const Text(
                      "A verification email has been sent.\nPlease check your inbox or spam folder.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Button to check if verified
                    ElevatedButton(
                      onPressed: checkEmailVerified,
                      child: const Text(
                        "I've Verified",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: canResendEmail ? sendVerificationEmail : null,
                      child: const Text(
                        "Resend Email",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: const Text("Cancel"),
                    ),
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


/*

Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "A verification email has been sent.\nPlease check your inbox or spam folder.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Button to check if verified
              ElevatedButton(
                onPressed: checkEmailVerified,
                child: const Text("I've Verified"),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: canResendEmail ? sendVerificationEmail : null,
                child: const Text("Resend Email"),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: const Text("Cancel"),
              ),
            ],
          ),


*/