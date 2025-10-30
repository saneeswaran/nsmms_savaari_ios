import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:namma_savaari/customer/auth/service/customer_google_service.dart';
import 'package:namma_savaari/customer/sign_up_screen.dart';

import 'customer_account_deletion_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _showLogoutConfirmationDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Are you sure you want to log out?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text("No"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context); // Close the dialog
                      await _onLogoutConfirmed(); // Proceed to log out
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Yes"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<void> _onLogoutConfirmed() async {
  //   _animationController.forward();

  //   // Get the current user's ID
  //   final User? user = _auth.currentUser;
  //   final String? userId = user?.uid;

  //   if (userId != null) {
  //     try {
  //       // Update Firestore 'status' field to 'loggedOut' for the specific user
  //       await FirebaseFirestore.instance
  //           .collection('customers')
  //           .doc(userId)
  //           .set({
  //         'status': 'loggedOut',
  //       }, SetOptions(merge: true));

  //       print("User status updated to 'loggedOut'");
  //     } catch (e) {
  //       print("Failed to update status: $e");
  //     }
  //   }

  //   // Log out the user
  //   await _auth.signOut();

  //   _animationController.reverse();

  //   // Navigate to the login screen or home screen after logout
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (context) => const SignUpScreen()),
  //   );

  // }
  Future<void> _onLogoutConfirmed() async {
    _animationController.forward();

    final User? user = FirebaseAuth.instance.currentUser;
    final String? userId = user?.uid;

    if (userId != null) {
      try {
        // Update Firestore 'status' field to 'loggedOut'
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(userId)
            .set({
          'status': 'loggedOut',
          'lastLogout': FieldValue.serverTimestamp(), // optional tracking
        }, SetOptions(merge: true));

        log("User status updated to 'loggedOut'");
      } catch (e) {
        log("Failed to update status: $e");
      }
    }

    // Use your service to fully sign out from Google + Firebase
    await CustomerGoogleLoginService.signOut();

    _animationController.reverse();

    // Navigate to login screen
  if(mounted) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Settings"),
        backgroundColor: Colors.redAccent.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          children: [
            // Card for Logout
            GestureDetector(
              onTap:
                  _showLogoutConfirmationDialog, // Show the confirmation dialog
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _animationController.value * -10),
                    child: Opacity(
                      opacity: 1 - _animationController.value,
                      child: child,
                    ),
                  );
                },
                child: Card(
                  color: Colors.lightBlue.shade50,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading:
                        const Icon(Icons.logout, color: Colors.pink, size: 28),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.indigo,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.shade400,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Divider with subtle text
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade300)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Danger Zone",
                    style: TextStyle(color: Colors.red.shade300),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),
            const SizedBox(height: 20),

            // Card for Delete Account
            GestureDetector(
              onTap: () {
                // Navigate to the Offers screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeleteAccountScreen(),
                  ),
                );
              },
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _animationController.value * 10),
                    child: Opacity(
                      opacity: 1 - _animationController.value,
                      child: child,
                    ),
                  );
                },
                child: Card(
                  color: Colors.red.shade50,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading:
                        const Icon(Icons.delete, color: Colors.pink, size: 28),
                    title: const Text(
                      "Delete Account",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    trailing: Icon(
                      Icons.warning,
                      color: Colors.red.shade400,
                      size: 16,
                    ),
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
