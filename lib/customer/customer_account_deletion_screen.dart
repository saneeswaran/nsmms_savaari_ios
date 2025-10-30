import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:namma_savaari/customer/welcome_screen.dart';

import 'Account_settings_screen.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _feedbackController = TextEditingController();
  late DateTime deletionDate;

  @override
  void initState() {
    super.initState();
    // Set deletion date to 2 days from now
    deletionDate = DateTime.now().add(const Duration(days: 2));
  }

  Future<void> _deleteAccountRequest() async {
    final User? user = _auth.currentUser;
    final String? userId = user?.uid;
    final feedback = _feedbackController.text.trim();

    if (userId != null) {
      try {
        // Show snackbar with confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your account will be permanently deleted after 2 days.')),
        );

        // Store deletion request date and status in Firestore
        await FirebaseFirestore.instance.collection('customers').doc(userId).set({
          'deletionRequestedAt': Timestamp.fromDate(DateTime.now()),
          'status': 'deletionPending',
          'feedback': feedback.isNotEmpty ? feedback : null,
        }, SetOptions(merge: true));

        // Navigate back to AccountSettingsScreen
        // Navigator.of(context).pushReplacementNamed('/account_settings');
     if(mounted) {
       Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomePage(),
          ),
        );
     }
      } catch (e) {
        log("Failed to set deletion request: $e");
      }
    }
  }

  Future<void> requestAccountDeletion() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      try {
        // Record the deletion request time and set the status
        await firestore.collection('customers').doc(user.uid).set({
          'deletionRequestedAt': Timestamp.fromDate(DateTime.now()),
          'status': 'deletionPending',
        }, SetOptions(merge: true));

        log('Deletion request recorded.');
      } catch (e) {
        log('Error while requesting account deletion: $e');
      }
    }
  }

  Future<void> checkAndDeleteAccount() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      try {
        // Fetch the deletion request details
        DocumentSnapshot doc = await firestore.collection('customers').doc(user.uid).get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          final deletionRequestedAt = (data['deletionRequestedAt'] as Timestamp).toDate();
          final status = data['status'];

          // Check if the deletion request is pending and if the 2 days have passed
          if (status == 'deletionPending' && DateTime.now().isAfter(deletionRequestedAt.add(const Duration(days: 2)))) {
            // Proceed with deleting the account from Firebase Auth and Firestore
            await auth.currentUser?.delete();  // Delete from Firebase Authentication
            await firestore.collection('customers').doc(user.uid).delete();  // Delete from Firestore

            log("Account deleted successfully.");
          }
        }
      } catch (e) {
        log("Error while checking deletion status: $e");
      }
    }
  }


  // Future<void> _loginUser() async {
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //
  //   try {
  //     // Attempt login (simplified example)
  //     await auth.signInWithEmailAndPassword(email, password);
  //
  //     // After successful login, check if the account deletion is due
  //     await checkAndDeleteAccount();
  //   } catch (e) {
  //     print("Login failed: $e");
  //   }
  // }


  // ElevatedButton(
  // onPressed: requestAccountDeletion,
  // child: Text("Request Account Deletion"),
  // )




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Account"),
        backgroundColor: Colors.red[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Warning Icon and Explanation Text
              const Icon(Icons.warning, color: Colors.red, size: 90),
              const SizedBox(height: 25),
              const Text(
                "This action will permanently delete your account in 2 days",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 25),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "•",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 5), // Adjust the spacing as needed
                      Expanded(
                        child: Text(
                          "Your payment and booking history will be deleted.",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "•",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          "You will need to re-enter your details if you decide to use Namma Savaari again.",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "•",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          "You will be unsubscribed from our mailing list.",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Deletion Information
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.teal[50],
                  child: Text(
                    "You can log in anytime within the next 2 days (until ${deletionDate.toLocal()}) to cancel the deletion of your account.",
                    style: const TextStyle(color: Colors.black87,),
                  ),

                ),
              ),
              const SizedBox(height: 20),

              // Feedback Text Box
              // TextField(
              //   controller: _feedbackController,
              //   decoration: InputDecoration(
              //     labelText: "Feedback (optional)",
              //     border: OutlineInputBorder(),
              //   ),
              //   maxLines: 3,
              // ),

              TextField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  hintText: "Feedback (optional)",
                  labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.black, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.pink.shade300, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                maxLines: 3,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountSettingsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade400,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Text("Keep my account with Namma Savaari",style: TextStyle(color: Colors.white),),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _deleteAccountRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Text("Delete my account",style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




