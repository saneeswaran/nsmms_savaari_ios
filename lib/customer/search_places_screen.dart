import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:namma_savaari/customer/services.dart';
import 'package:provider/provider.dart';

class CitySelectionPage extends StatefulWidget {
  const CitySelectionPage({super.key});

  @override
  _CitySelectionPageState createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  String? customerId;
  List<Map<String, dynamic>> _cityList = [];
  List<Map<String, dynamic>> _filteredCityList = [];
  List<Map<String, dynamic>> _recentCityPairs = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode =
      FocusNode(); // FocusNode to track search bar focus

  @override
  void initState() {
    super.initState();
    _getCustomerId();
    _fetchCityList();
    _fetchRecentCities();
    _fetchRecentCityPairs();
    _searchController.addListener(_filterCities);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CityProvider>(context, listen: false).fetchCities();
    });
    // Provider.of<CityProvider>(context, listen: false).fetchCities();

    // Add a listener to the FocusNode to update the UI when focus changes
    // _searchFocusNode.addListener(() {
    //   setState(() {}); // Rebuild the UI when focus changes
    // });
    _searchFocusNode.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose(); // Dispose the FocusNode
    super.dispose();
  }

  // Method to get the current logged-in customerId
  Future<void> _getCustomerId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        customerId = user.uid;
      });
    } else {
      log("User not logged in.");
    }
  }

  // Fetch the city list from the API
  Future<void> _fetchCityList() async {
    const String url = "https://namma-savaari-api-backend.vercel.app/city-list";
    const Map<String, String> headers = {
      "Content-Type": "application/json",
      "Api-Token": "Namma@90434#34",
    };

    const Map<String, String> body = {
      "ClientId": "180187",
      "UserName": "Namma434",
      "Password": "Namma@4341",
      "EndUserIp": "157.48.136.69"
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["Error"]["ErrorCode"] == 1 && data["Result"] != null) {
          setState(() {
            _cityList =
                List<Map<String, dynamic>>.from(data["Result"]["CityList"]);
            _filteredCityList = List.from(_cityList);
          });
        } else {
          _showError(data["Error"]["ErrorMessage"] ?? "Unknown error");
        }
      } else {
        _showError("Failed to fetch data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      _showError("An error occurred: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetch recent cities from Firestore
  Future<void> _fetchRecentCities() async {
    if (customerId == null) return;

    try {
      final userDocRef = FirebaseFirestore.instance
          .collection('customers')
          .doc(customerId)
          .collection('recentSelectedCities');

      final snapshot = await userDocRef.get();

      List<Map<String, dynamic>> recentCities = [];

      for (var doc in snapshot.docs) {
        recentCities.add(doc.data());
      }

    } catch (e) {
      log("Error fetching recent cities: $e");
    }
  }

  // Fetch recent city pairs from Firestore
  Future<void> _fetchRecentCityPairs() async {
    if (customerId == null) return;

    try {
      final userDocRef = FirebaseFirestore.instance
          .collection('customers')
          .doc(customerId)
          .collection('recentCityPairs');

      final snapshot =
          await userDocRef.orderBy('timestamp', descending: true).get();

      List<Map<String, dynamic>> recentPairs = [];

      for (var doc in snapshot.docs) {
        recentPairs.add(doc.data());
      }

      setState(() {
        _recentCityPairs = recentPairs;
      });
    } catch (e) {
      log("Error fetching recent city pairs: $e");
    }
  }

  // Filter cities based on the search query
  void _filterCities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCityList = List.from(_cityList);
      } else {
        _filteredCityList = _cityList.where((city) {
          final cityName = city["CityName"]?.toLowerCase() ?? "";
          return cityName.contains(query);
        }).toList();
      }
    });
  }

  // Show an error message
  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select City", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent.shade700,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode, // Assign the FocusNode
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.redAccent.shade700,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.redAccent.shade700,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                hintText: "Search for cities...",
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),

          // Show "Search for cities..." section when the search bar is focused
          if (_searchFocusNode.hasFocus && _searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Search Results",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.redAccent.shade700,
                ),
              ),
            ),

          // Show "Recent City Pairs" section when the search bar is not focused
          if (!_searchFocusNode.hasFocus && _recentCityPairs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recent City Pairs",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.redAccent.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 150,
                      child: ListView.separated(
                        itemCount: _recentCityPairs.length,
                        itemBuilder: (context, index) {
                          final pair = _recentCityPairs[index];
                          final fromPlace =
                              pair['fromPlace']?.split(' - ')[0] ?? '';
                          final toPlace =
                              pair['toPlace']?.split(' - ')[0] ?? '';

                          return GestureDetector(
                            onTap: () {
                              // Return the selected city pair when tapped
                              Navigator.pop(context, {
                                'fromPlace': pair['fromPlace'],
                                'toPlace': pair['toPlace'],
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "$fromPlace → $toPlace",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.grey.shade300,
                            height: 1,
                            thickness: 1,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Display cities in the list
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredCityList.isEmpty
                      ? const Center(child: Text("No cities available."))
                      : ListView.separated(
                          itemCount: _filteredCityList.length,
                          itemBuilder: (context, index) {
                            final city = _filteredCityList[index];
                            return ListTile(
                              title: Text(
                                city["CityName"] ?? "Unknown City",
                                style: const TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                Navigator.pop(context, {
                                  "CityName": city["CityName"],
                                  "CityId": city["CityId"],
                                });
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.grey.shade300,
                              height: 1,
                              thickness: 1,
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}


//Testing


// success_1_1 _city

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class CitySelectionPage extends StatefulWidget {
//   @override
//   _CitySelectionPageState createState() => _CitySelectionPageState();
// }
//
// class _CitySelectionPageState extends State<CitySelectionPage> {
//   String? customerId; // Variable to hold customer ID
//   List<Map<String, dynamic>> _cityList = [];
//   List<Map<String, dynamic>> _filteredCityList = [];
//   List<Map<String, dynamic>> _recentCities = []; // List to hold recent cities
//   bool _isLoading = false;
//   TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _getCustomerId(); // Fetch the customer ID as soon as the page loads
//     _fetchCityList();
//     _fetchRecentCities(); // Fetch recent cities when the page loads
//     _searchController.addListener(_filterCities);
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   // Method to get the current logged-in customerId
//   Future<void> _getCustomerId() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         customerId = user.uid; // Set customerId to the current logged-in user's UID
//       });
//     } else {
//       print("User not logged in.");
//       // Handle the case where the user is not logged in
//     }
//   }
//
//   // Fetch the city list from the API
//   Future<void> _fetchCityList() async {
//     const String url = "https://bus.srdvapi.com/v5/rest/GetBusCityList";
//     const Map<String, String> headers = {
//       "Content-Type": "application/json",
//       "Api-Token": "Namma@90434#34",
//     };
//
//     const Map<String, String> body = {
//       "ClientId": "180187",
//       "UserName": "Namma434",
//       "Password": "Namma@4341",
//     };
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: json.encode(body),
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data["Error"]["ErrorCode"] == 1 && data["Result"] != null) {
//           setState(() {
//             _cityList = List<Map<String, dynamic>>.from(data["Result"]["CityList"]);
//             _filteredCityList = List.from(_cityList);
//           });
//         } else {
//           _showError(data["Error"]["ErrorMessage"] ?? "Unknown error");
//         }
//       } else {
//         _showError("Failed to fetch data. Status code: ${response.statusCode}");
//       }
//     } catch (e) {
//       _showError("An error occurred: $e");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   // Fetch recent cities from Firestore
//   Future<void> _fetchRecentCities() async {
//     if (customerId == null) return; // Ensure customerId is available
//
//     try {
//       // Get the current user's Firestore subcollection reference for recent cities
//       final userDocRef = FirebaseFirestore.instance
//           .collection('customers')
//           .doc(customerId)
//           .collection('recentSelectedCities');
//
//       // Fetch recent cities from Firestore
//       final snapshot = await userDocRef.get();
//
//       List<Map<String, dynamic>> recentCities = [];
//
//       // Convert the Firestore documents to a list
//       snapshot.docs.forEach((doc) {
//         recentCities.add(doc.data());
//       });
//
//       setState(() {
//         _recentCities = recentCities;
//       });
//     } catch (e) {
//       print("Error fetching recent cities: $e");
//     }
//   }
//
//   Future<void> _fetchRecentCityPairs() async {
//     if (customerId == null) return;
//
//     try {
//       final userDocRef = FirebaseFirestore.instance
//           .collection('customers')
//           .doc(customerId)
//           .collection('recentCityPairs');
//
//       final snapshot = await userDocRef.get();
//
//       List<Map<String, dynamic>> recentPairs = [];
//
//       snapshot.docs.forEach((doc) {
//         recentPairs.add(doc.data());
//       });
//
//       setState(() {
//         _recentCities = recentPairs;
//       });
//     } catch (e) {
//       print("Error fetching recent city pairs: $e");
//     }
//   }
//
//
//   void _filterCities() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       if (query.isEmpty) {
//         _filteredCityList = List.from(_cityList);
//       } else {
//         _filteredCityList = _cityList.where((city) {
//           final cityName = city["CityName"]?.toLowerCase() ?? "";
//           return cityName.contains(query);
//         }).toList();
//       }
//     });
//   }
//
//   void _addToRecentCities(Map<String, dynamic> city) async {
//     if (customerId == null) return; // Ensure customerId is available
//
//     try {
//       // Get the current user's Firestore document reference
//       final userDocRef = FirebaseFirestore.instance
//           .collection('customers')
//           .doc(customerId)
//           .collection('recentSelectedCities'); // Subcollection for recent cities
//
//       // Fetch current data from the subcollection
//       final snapshot = await userDocRef.get();
//
//       List<Map<String, dynamic>> recentCities = [];
//
//       // Convert existing data to a list
//       snapshot.docs.forEach((doc) {
//         recentCities.add(doc.data());
//       });
//
//       // Remove city if it's already in the list
//       recentCities.removeWhere((c) => c["CityId"] == city["CityId"]);
//
//       // Add the city to the top
//       recentCities.insert(0, city);
//
//       // Limit to 5 recent cities
//       if (recentCities.length >= 5) {
//         recentCities.removeLast();
//       }
//
//       // Now, update the subcollection with the new list of recent cities
//       // First, delete all the previous records in the subcollection
//       final batch = FirebaseFirestore.instance.batch();
//
//       // Delete all previous recent cities
//       snapshot.docs.forEach((doc) {
//         batch.delete(doc.reference);
//       });
//
//       // Add new cities to the subcollection
//       recentCities.forEach((cityData) {
//         batch.set(userDocRef.doc(), cityData);
//       });
//
//       // Commit the batch
//       await batch.commit();
//
//     } catch (e) {
//       print("Error updating recent cities: $e");
//     }
//   }
//
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Select City", style: TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent.shade700),
//       body: Column(
//         children: [
//           // Display recent cities at the top of the screen
//           if (_recentCities.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Recent Cities", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   SizedBox(height: 8),
//                   SizedBox(
//                     height: 100,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal  ,
//                       itemCount: _recentCities.length,
//                       itemBuilder: (context, index) {
//                         final city = _recentCities[index];
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.pop(context, {
//                               "CityName": city["CityName"],
//                               "CityId": city["CityId"],
//                             });
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(right: 8),
//                             padding: EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.redAccent.shade200,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.location_on, color: Colors.white),
//                                 SizedBox(height: 4),
//                                 Text(
//                                   city["CityName"] ?? "Unknown City",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//           // Search bar
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: "Search",
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//
//           // Display cities in the list
//           Expanded(
//             child: _isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : _filteredCityList.isEmpty
//                 ? Center(child: Text("No cities available."))
//                 : ListView.builder(
//               itemCount: _filteredCityList.length,
//               itemBuilder: (context, index) {
//                 final city = _filteredCityList[index];
//                 return ListTile(
//                   title: Text(city["CityName"] ?? "Unknown City"),
//                   onTap: () {
//                     _addToRecentCities(city);  // Store the city in Firestore
//                     Navigator.pop(context, {
//                       "CityName": city["CityName"],
//                       "CityId": city["CityId"],
//                     });
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// success 2







