// bus_booking_application

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'customer_home_page.dart'; // Import your HomeScreen

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Password visibility toggles
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Regular expression to check for letters, numbers, and symbols in the password
  final RegExp passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');

  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      final password = _passwordController.text.trim();

      try {
        // Get the current user
        User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          // Update password in Firebase Authentication
          await currentUser.updatePassword(password);

          // Show success message
                                if(!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully!')),
          );

          // Navigate to the Home page and remove the password update screen from the stack
                                if(!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const CustomerHomePage()), // Replace HomePage with your actual home screen
            (Route<dynamic> route) =>
                false, // This ensures that the user can't go back to the password update screen
          );
        }
      } catch (e) {
        // Handle errors during the password update
                              if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating password: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Password')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // New Password TextField
              TextFormField(
                controller: _passwordController,
                obscureText:
                    !_isPasswordVisible, // Controls password visibility
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
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
                    return 'Please enter a new password';
                  } else if (!passwordRegExp.hasMatch(value)) {
                    return 'Password must be at least 8 characters long, contain letters, numbers, and symbols';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Confirm New Password TextField
              TextFormField(
                controller: _confirmPasswordController,
                obscureText:
                    !_isConfirmPasswordVisible, // Controls confirm password visibility
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Update Password Button
              ElevatedButton(
                onPressed: _updatePassword,
                child: const Text('Update Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
