import 'package:flutter/material.dart';
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
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CustomerHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height * 1,
        width: size.width * 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.redAccent.shade700, Colors.black87],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.2),
            SizedBox(
              height: size.height * 0.3,
              width: size.width * 0.8,
              child: Image.asset("assets/Namma_Savaari_LOGO1.png"),
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
