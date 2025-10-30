import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:namma_savaari/customer/auth/service/auth_service.dart';
import 'package:namma_savaari/customer/widgets/auth_textfield.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final bool _isSigningIn = false;

  // --> Firebase Email AUTH
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final phoneNoController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final verifyPasswordController = TextEditingController();

  // Gender
  String? selectedGender;
  final auth = AuthService();
  bool isLogin = false;

  // Future<void> _register() async {
  //   if (_formKey.currentState!.validate()) {
  //     try {
  //       final name = _nameController.text.trim();
  //       final gender = _selectedGender;
  //       final phone = _phoneController.text.trim();
  //       final pet1 = _pet1Controller.text.trim();
  //       final pet2 = _pet2Controller.text.trim();

  //       // Assuming a user is already logged in, retrieve the current user's email
  //       User? currentUser = FirebaseAuth.instance.currentUser;

  //       if (currentUser != null) {
  //         // Store user information in Firestore
  //         await FirebaseFirestore.instance.collection('customers').doc(currentUser.uid).set({
  //           'name': name,
  //           'gender': gender,
  //           'phone': phone,
  //           'pet1': pet1,
  //           'pet2': pet2,
  //           'email': currentUser.email,
  //         });

  //         // Navigate to Home page
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const HomePage()),
  //         );

  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('Registration Successful!'),
  //             backgroundColor: Colors.blue,
  //           ),
  //         );
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('User is not logged in.'),
  //             backgroundColor: Colors.red,
  //           ),
  //         );
  //       }
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(e.toString()),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }

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

                      // PHONE NUMBER
                      AuthTextfield(
                          controller: phoneNoController, label: "Phone Number"),

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
                        onTap: () {
                          context.go('/home');
                        },
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
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const CustomerLoginPage()));
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
