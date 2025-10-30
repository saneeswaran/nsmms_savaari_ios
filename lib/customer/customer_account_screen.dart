import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:namma_savaari/customer/view_more_shorts_screen.dart';
import 'package:namma_savaari/customer/view_more_youtube_videos_screen.dart';

import 'Account_settings_screen.dart';
import 'customer_all_offers_list_screen.dart';

class MyAccountScreen extends StatefulWidget {
  final VoidCallback onNavigateToHelp;
  final VoidCallback onNavigateToBookings;

  const MyAccountScreen({
    required this.onNavigateToHelp,
    required this.onNavigateToBookings,
    super.key,
  });

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  String selectedCountry = 'India';

  // Method to show the rating dialog
  Future<void> _showRateDialog(BuildContext context) async {
    final TextEditingController reviewController = TextEditingController();
    double rating = 0.0; // Variable to store the user's rating

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.all(16.0),
            content: SizedBox(
              height:
                  MediaQuery.of(context).size.height * 0.45, // Adjusted height
              width: MediaQuery.of(context).size.width * 0.9, // Adjusted width
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image on top
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        'assets/rate_rev.JPG', // Replace with your asset image
                        height: 180, // Updated image height
                        width: double.infinity, // Updated image width
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // "Rate Your Experience" Text
                    const Text(
                      "Rate Your Experience",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Mandatory Rating input (stars)
                    RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      unratedColor: Colors.grey, // Color for unselected stars
                      onRatingUpdate: (rating) {
                        rating = rating;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Optional Review input
                    TextField(
                      controller: reviewController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Write a review (Optional)...',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.symmetric(
                horizontal: 16), // Adjust padding for buttons
            actionsAlignment:
                MainAxisAlignment.spaceBetween, // Arrange buttons properly
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                ),
                onPressed: () async {
                  if (rating == 0.0) {
                    // Show a message if rating is not provided
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please provide a rating!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Get the logged-in user's ID
                  final User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    String uid = user.uid; // Customer UID
                    String review = reviewController.text;

                    try {
                      // Check if the user has already submitted a rating
                      var reviewSnapshot = await FirebaseFirestore.instance
                          .collection('customers')
                          .doc(uid)
                          .collection('reviews')
                          .limit(1) // Limit to one review per customer
                          .get();

                      if (reviewSnapshot.docs.isNotEmpty) {
                        // Update the existing review
                        await FirebaseFirestore.instance
                            .collection('customers')
                            .doc(uid)
                            .collection('reviews')
                            .doc(reviewSnapshot.docs[0].id)
                            .update({
                          'rating': rating,
                          'review': review.isNotEmpty ? review : null,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                      if(!context.mounted) return;
                       ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rating updated successfully!'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      } else {
                        // Add a new review
                        await FirebaseFirestore.instance
                            .collection('customers')
                            .doc(uid)
                            .collection('reviews')
                            .add({
                          'rating': rating,
                          'review': review.isNotEmpty ? review : null,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                                              if(!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rating submitted successfully!'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to submit rating: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }

                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showCountryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Country',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Image.asset(
                  'assets/Flag_of_India.svg.png', // Replace with the correct path to your image
                  width: 30,
                  height: 30,
                ),
                title: const Text(
                  'India',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedCountry = 'India';
                  });
                  Navigator.pop(
                      context); // Close the bottom sheet after selecting
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _fetchCustomerDetails() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('customers')
            .doc(user.uid)
            .get();
        return snapshot.data() as Map<String, dynamic>;
      } catch (e) {
        log('Error fetching customer details: $e');
        return {};
      }
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Map<String, dynamic>>(
      future: _fetchCustomerDetails(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   // Custom loading indicator with animation
        //   return Center(
        //     child: FadeIn(
        //       duration: Duration(milliseconds: 300),
        //       child: CircularProgressIndicator(
        //         valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
        //         strokeWidth: 6.0,
        //       ),
        //     ),
        //   );
        // }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Colors.redAccent.shade700),
            minHeight: 5.0,
          );
        }

        Map<String, dynamic>? data = snapshot.data;
        String name = data?['name'] ?? '';
        String email = data?['email'] ?? '';
        Timestamp? createdAt = data?['createdAt'];
        String createdAtString = createdAt != null
            ? DateTime.fromMillisecondsSinceEpoch(
                    createdAt.millisecondsSinceEpoch)
                .toLocal()
                .toString()
            : '';

        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    child: Image.asset(
                      'assets/customer_profile.jpg',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (name.isNotEmpty)
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        if (email.isNotEmpty)
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        if (createdAtString.isNotEmpty)
                          Text(
                            'Member since $createdAtString',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'My details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.book, color: Colors.redAccent.shade700),
                      title: const Text('Bookings',
                          style: TextStyle(fontSize: 18)),
                      onTap: widget
                          .onNavigateToBookings, // Navigate to Bookings tab
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'More',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Icon(Icons.local_offer,
                          color: Colors.redAccent.shade700),
                      title: const Text(
                        'Offers',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        // Navigate to the Offers screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CustomerAllOffersListScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.ondemand_video_rounded,
                          color: Colors.redAccent.shade700),
                      title: const Text(
                        'Trending videos',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        // Navigate to the Offers screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewMorePage(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.video_library,
                          color: Colors.redAccent.shade700),
                      title: const Text(
                        'Trending shorts',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        // Navigate to the Offers screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ViewMoreShortsScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    // ListTile(
                    //   leading: Icon(Icons.account_balance_wallet, color: Colors.redAccent.shade700),
                    //   title: Text('Namma Savaari Wallet',style: TextStyle(fontSize: 18),),
                    //   onTap: () {
                    //     // Navigate to the Offers screen
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => WalletScreen(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // Divider(),
                    // ListTile(
                    //   leading: Icon(Icons.account_balance, color: Colors.redAccent.shade700),
                    //   title: Text('Wallet History',style: TextStyle(fontSize: 18),),
                    //   onTap: () {
                    //     // Navigate to the Offers screen
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => BalanceLogScreen(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // Divider(),
                    ListTile(
                      leading: Icon(Icons.star_rate,
                          color: Colors.redAccent.shade700),
                      title: const Text(
                        'Rate app',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        // Show the rating dialog
                        _showRateDialog(
                            context); // Call the rating dialog function
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading:
                          Icon(Icons.help, color: Colors.redAccent.shade700),
                      title: const Text('Help', style: TextStyle(fontSize: 18)),
                      onTap: widget.onNavigateToHelp, // Navigate to Help tab
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.manage_accounts_outlined,
                          color: Colors.redAccent.shade700),
                      title: const Text(
                        'Account settings',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        // Navigate to the Offers screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountSettingsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Preferences',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Image.asset(
                        'assets/Flag_of_India.svg.png', // Replace with the correct path to your image
                        width: 30,
                        height: 30,
                      ),
                      title: const Text(
                        'Country',
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(selectedCountry),
                      onTap: () {
                        showCountryBottomSheet(context);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.currency_rupee,
                          color:
                              Colors.redAccent.shade700), // Leading star icon
                      title: const Row(
                        children: [
                          Text(
                            'Currency',
                            style: TextStyle(fontSize: 18),
                          ), // Currency title
                          SizedBox(width: 8),
                        ],
                      ),
                      subtitle: const Text(
                        'INR',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ), // Display "INR" below the currency title
                      onTap: () {
                        // You can add any action here if needed, or leave it empty.
                      },
                    ),
                    // Divider(),
                    // ListTile(
                    //   leading: Icon(Icons.language, color: Colors.redAccent.shade700),
                    //   title: Text('Language',style: TextStyle(fontSize: 18,),),
                    //   onTap: () {
                    //     // Navigate to the Help screen
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => CommissionSettings(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // Divider(),
                    // ListTile(
                    //   leading: Icon(Icons.brightness_2, color: Colors.redAccent.shade700),
                    //   // leading: Icon(Icons.wb_sunny, color: Colors.pink),
                    //   title: Text('Dark Mode'),
                    //   trailing: Switch(
                    //     value: Provider.of<ThemeProvider>(context).isDarkMode,
                    //     onChanged: (value) {
                    //       Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                    //     },
                    //   ),
                    // ),
                    // Divider(),
                    // ListTile(
                    //   leading: Icon(Icons.public, color: Colors.redAccent.shade700),
                    //   title: Text('Our Website', style: TextStyle(fontSize: 18)),
                    //   subtitle: Text('chanconstructions.com', style: TextStyle(fontSize: 16)),
                    //   trailing: Icon(Icons.open_in_new, size: 20),
                    //   onTap: () async {
                    //     const url = 'https://chanconstructions.com/';
                    //     if (await canLaunch(url)) {
                    //       await launch(
                    //         url,
                    //         forceSafariVC: false, // iOS - don't use Safari View Controller
                    //         forceWebView: false, // Android - don't use WebView
                    //       );
                    //     } else {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         SnackBar(content: Text('Could not launch $url')),
                    //       );
                    //     }
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
