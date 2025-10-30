//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class BalanceScreen extends StatefulWidget {
//   @override
//   _BalanceScreenState createState() => _BalanceScreenState();
// }
//
// class _BalanceScreenState extends State<BalanceScreen> {
//   bool isLoading = true; // To manage loading state
//   Map<String, dynamic> balanceData = {}; // To store balance API response
//   List<dynamic> balanceLogs = []; // To store balance log data
//
//   // Function to fetch the balance
//   Future<void> fetchBalance() async {
//     const String apiUrl = "https://bus.srdvapi.com/v5/rest/Balance";
//
//     // Request body
//     final Map<String, String> requestBody = {
//       "EndUserIp": "157.48.136.69", // Replace with the actual IP
//       "ClientId": "180187",         // Replace with your Client ID
//       "UserName": "Namma434",       // Replace with your User Name
//       "Password": "Namma@4341",     // Replace with your Password
//     };
//
//     try {
//       // Make the API request
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Api-Token": "Namma@90434#34", // Add the actual API token
//         },
//         body: json.encode(requestBody),
//       );
//
//       if (response.statusCode == 200) {
//         // Parse the response
//         final responseData = json.decode(response.body);
//         setState(() {
//           balanceData = responseData;
//         });
//         print("Balance API Response: $responseData");
//       } else {
//         print("Failed to fetch balance. Status code: ${response.statusCode}");
//         print("Response body: ${response.body}");
//       }
//     } catch (error) {
//       print("An error occurred while fetching balance: $error");
//     }
//   }
//
//   // Function to fetch the balance log
//   Future<void> fetchBalanceLog() async {
//     const String apiUrl = "https://bus.srdvapi.com/v5/rest/BalanceLog";
//
//     // Request body
//     final Map<String, String> requestBody = {
//       "EndUserIp": "157.48.136.69", // Replace with the actual IP
//       "ClientId": "180187",         // Replace with your Client ID
//       "UserName": "Namma434",       // Replace with your User Name
//       "Password": "Namma@4341",     // Replace with your Password
//     };
//
//     try {
//       // Make the API request
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Api-Token": "Namma@90434#34", // Add the actual API token
//         },
//         body: json.encode(requestBody),
//       );
//
//       if (response.statusCode == 200) {
//         // Parse the response
//         final responseData = json.decode(response.body);
//         setState(() {
//           balanceLogs = responseData['BalanceLog'] ?? [];
//           isLoading = false;
//         });
//         print("Balance Log API Response: $responseData");
//       } else {
//         print("Failed to fetch balance log. Status code: ${response.statusCode}");
//         print("Response body: ${response.body}");
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (error) {
//       print("An error occurred while fetching balance log: $error");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch data from both APIs
//     fetchBalance();
//     fetchBalanceLog();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Balance and Logs"),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator()) // Show loading spinner
//           : SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Display Balance API response
//               Text(
//                 "Balance Details:",
//                 style: TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Text("Balance: ${balanceData['Balance'] ?? 'N/A'}"),
//               Text("CreditLimit: ${balanceData['CreditLimit'] ?? 'N/A'}"),
//               Divider(),
//
//               // Display Balance Log API response
//               Text(
//                 "Balance Logs:",
//                 style: TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               balanceLogs.isEmpty
//                   ? Text("No logs available")
//                   : ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: balanceLogs.length,
//                 itemBuilder: (context, index) {
//                   final log = balanceLogs[index];
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 8.0),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                         children: [
//                           Text("ID: ${log['ID'] ?? 'N/A'}"),
//                           Text("Date: ${log['Date'] ?? 'N/A'}"),
//                           Text("Client ID: ${log['ClientID'] ?? 'N/A'}"),
//                           Text("Client Name: ${log['ClientName'] ?? 'N/A'}"),
//                           Text("Detail: ${log['Detail'] ?? 'N/A'}"),
//                           Text("Debit: ${log['Debit'] ?? 'N/A'}"),
//                           Text("Credit: ${log['Credit'] ?? 'N/A'}"),
//                           Text("Balance: ${log['Balance'] ?? 'N/A'}"),
//                           Text("Module: ${log['Module'] ?? 'N/A'}"),
//                           Text("Trace ID: ${log['TraceID'] ?? 'N/A'}"),
//                           Text("Ref ID: ${log['RefID'] ?? 'N/A'}"),
//                           Text("Updated By: ${log['UpdatedBy'] ?? 'N/A'}"),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//



// balance console



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class BalanceScreen extends StatefulWidget {
//   @override
//   _BalanceScreenState createState() => _BalanceScreenState();
// }
//
// class _BalanceScreenState extends State<BalanceScreen> {
//   // Function to fetch the balance
//   Future<void> fetchBalance() async {
//     const String apiUrl = "https://bus.srdvapi.com/v5/rest/Balance";
//
//     // Request body
//     final Map<String, String> requestBody = {
//       "EndUserIp": "157.48.136.69", // Replace with the actual IP
//       "ClientId": "180187",         // Replace with your Client ID
//       "UserName": "Namma434",       // Replace with your User Name
//       "Password": "Namma@4341",     // Replace with your Password
//     };
//
//     try {
//       // Make the API request
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Api-Token": "Namma@90434#34", // Add the actual API token
//         },
//         body: json.encode(requestBody),
//       );
//
//       if (response.statusCode == 200) {
//         // Parse and print the response
//         final responseData = json.decode(response.body);
//         print("Balance API Response: $responseData");
//       } else {
//         print("Failed to fetch balance. Status code: ${response.statusCode}");
//         print("Response body: ${response.body}");
//       }
//     } catch (error) {
//       print("An error occurred: $error");
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchBalance(); // Call the API when the screen initializes
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Balance"),
//       ),
//       body: Center(
//         child: Text(
//           "Fetching balance...",
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }



// Balance Fetching on the screen



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_fonts/google_fonts.dart';
//
//
// class BalanceScreen extends StatefulWidget {
//   @override
//   _BalanceScreenState createState() => _BalanceScreenState();
// }
//
// class _BalanceScreenState extends State<BalanceScreen> {
//   // Variables to hold the balance and credit limit
//   String balance = "Loading...";
//   String creditLimit = "Loading...";
//
//   // Function to fetch the balance
//   Future<void> fetchBalance() async {
//     // const String apiUrl = "https://bus.srdvapi.com/v5/rest/Balance";
//     const String apiUrl = "http://3.7.121.234/bus-api/Balance";
//
//
//     // Request body
//     final Map<String, String> requestBody = {
//       "EndUserIp": "157.48.136.69", // Replace with the actual IP
//       "ClientId": "180187",         // Replace with your Client ID
//       "UserName": "Namma434",       // Replace with your User Name
//       "Password": "Namma@4341",     // Replace with your Password
//     };
//
//     try {
//       // Make the API request
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Api-Token": "Namma@90434#34", // Add the actual API token
//         },
//         body: json.encode(requestBody),
//       );
//
//       if (response.statusCode == 200) {
//         // Parse the response
//         final responseData = json.decode(response.body);
//
//         // Extract the balance and credit limit from the response
//         setState(() {
//           balance = responseData['Balance'] ?? "Not Available";
//           creditLimit = responseData['CreditLimit'] ?? "Not Available";
//         });
//
//         print("Balance API Response: $responseData");
//       } else {
//         print("Failed to fetch balance. Status code: ${response.statusCode}");
//         print("Response body: ${response.body}");
//       }
//     } catch (error) {
//       print("An error occurred: $error");
//       setState(() {
//         balance = "Error fetching balance";
//         creditLimit = "Error fetching credit limit";
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchBalance(); // Call the API when the screen initializes
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Balance",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.redAccent.shade700,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Balance: $balance,",
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent.shade700),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       "Credit Limit: $creditLimit",
//                       style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.blueGrey[50],
//     );
//   }
// }



// custom wallet


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// class WalletScreen extends StatefulWidget {
//   @override
//   _WalletScreenState createState() => _WalletScreenState();
// }
//
// class _WalletScreenState extends State<WalletScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   Razorpay? _razorpay;
//   double walletBalance = 0.0;
//   String userId = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     _getUserWallet();
//   }
//
//   Future<void> _getUserWallet() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       userId = user.uid;
//       DocumentSnapshot walletDoc =
//       await _firestore.collection('wallets').doc(userId).get();
//
//       if (!walletDoc.exists) {
//         await _firestore.collection('wallets').doc(userId).set({
//           'balance': 0.0,
//           'transactions': [],
//         });
//         setState(() => walletBalance = 0.0);
//       } else {
//         setState(() => walletBalance = walletDoc['balance']);
//       }
//     }
//   }
//
//   void _openCheckout(double amount) {
//     var options = {
//       'key': 'rzp_test_0JqfNU3fC2HG7Z', // Replace with your Razorpay Key
//       'amount': amount * 100, // Razorpay works in paise
//       'name': 'Your App Name',
//       'description': 'Wallet Recharge',
//       'prefill': {'contact': '1234567890', 'email': 'user@example.com'}
//     };
//
//     _razorpay!.open(options);
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     double topUpAmount = 500.0; // Example amount
//     walletBalance += topUpAmount;
//
//     await _firestore.collection('wallets').doc(userId).update({
//       'balance': walletBalance,
//       'transactions': FieldValue.arrayUnion([
//         {
//           'id': response.paymentId,
//           'amount': topUpAmount,
//           'type': 'deposit',
//           'timestamp': DateTime.now().toIso8601String()
//         }
//       ])
//     });
//
//     setState(() {});
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Recharge Successful!")));
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Payment Failed")));
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {}
//
//   Future<void> _makePayment(double amount) async {
//     if (walletBalance >= amount) {
//       walletBalance -= amount;
//
//       await _firestore.collection('wallets').doc(userId).update({
//         'balance': walletBalance,
//         'transactions': FieldValue.arrayUnion([
//           {
//             'id': DateTime.now().millisecondsSinceEpoch.toString(),
//             'amount': amount,
//             'type': 'payment',
//             'timestamp': DateTime.now().toIso8601String()
//           }
//         ])
//       });
//
//       setState(() {});
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Payment Successful!")));
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Insufficient Balance")));
//     }
//   }
//
//   @override
//   void dispose() {
//     _razorpay!.clear();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("User Wallet")),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("Wallet Balance: ₹$walletBalance",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () => _openCheckout(500),
//             child: Text("Top-Up ₹500"),
//           ),
//           ElevatedButton(
//             onPressed: () => _makePayment(200),
//             child: Text("Pay ₹200"),
//           ),
//           SizedBox(height: 20),
//           Expanded(child: _transactionHistory()),
//         ],
//       ),
//     );
//   }
//
//   Widget _transactionHistory() {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: _firestore.collection('wallets').doc(userId).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return CircularProgressIndicator();
//
//         var walletData = snapshot.data!;
//         List transactions = walletData['transactions'] ?? [];
//
//         return ListView.builder(
//           itemCount: transactions.length,
//           itemBuilder: (context, index) {
//             var txn = transactions[index];
//             return ListTile(
//               title: Text("₹${txn['amount']} - ${txn['type']}"),
//               subtitle: Text(txn['timestamp']),
//             );
//           },
//         );
//       },
//     );
//   }
// }



// custom wallet testing



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// class WalletScreen extends StatefulWidget {
//   @override
//   _WalletScreenState createState() => _WalletScreenState();
// }
//
// class _WalletScreenState extends State<WalletScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late String customerId; // To hold the logged-in customer's ID
//
//   Razorpay? _razorpay;
//   double walletBalance = 0.0;
//   String userId = "";
//   TextEditingController _customAmountController = TextEditingController();
//   TextEditingController _customPaymentController = TextEditingController();
//   double _selectedTopUpAmount = 500.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     _getUserWallet();
//   }
//
//   Future<void> _getUserWallet() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       userId = user.uid;
//       DocumentSnapshot walletDoc =
//       await _firestore.collection('wallets').doc(userId).get();
//
//       if (!walletDoc.exists) {
//         await _firestore.collection('wallets').doc(userId).set({
//           'balance': 0.0,
//           'transactions': [],
//         });
//         setState(() => walletBalance = 0.0);
//       } else {
//         setState(() => walletBalance = walletDoc['balance']);
//       }
//     }
//   }
//
//   void _openCheckout(double amount) {
//     var options = {
//       'key': 'rzp_test_0JqfNU3fC2HG7Z', // Replace with your Razorpay Key
//       // 'key': 'rzp_live_jRrlgHE9Hldmk5', // Replace with your Razorpay Key
//       'amount': amount * 100, // Razorpay works in paise
//       'name': 'Namma Savaari',
//       'description': 'Wallet Recharge',
//       'prefill': {'contact': '1234567890', 'email': 'user@example.com'}
//     };
//
//
//     _razorpay!.open(options);
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     // Use the selected amount instead of hardcoded 500
//     walletBalance += _selectedTopUpAmount;
//
//     await _firestore.collection('wallets').doc(userId).update({
//       'balance': walletBalance,
//       'transactions': FieldValue.arrayUnion([
//         {
//           'id': response.paymentId,
//           'amount': _selectedTopUpAmount,
//           'type': 'deposit',
//           'timestamp': DateTime.now().toIso8601String()
//         }
//       ])
//     });
//
//     setState(() {});
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Recharge Successful!")));
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Payment Failed")));
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {}
//
//   Future<void> _makePayment(double amount) async {
//     if (walletBalance >= amount) {
//       walletBalance -= amount;
//
//       await _firestore.collection('wallets').doc(userId).update({
//         'balance': walletBalance,
//         'transactions': FieldValue.arrayUnion([
//           {
//             'id': DateTime.now().millisecondsSinceEpoch.toString(),
//             'amount': amount,
//             'type': 'payment',
//             'timestamp': DateTime.now().toIso8601String()
//           }
//         ])
//       });
//
//       setState(() {});
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Payment Successful!")));
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Insufficient Balance")));
//     }
//   }
//
//
//   void _showTopUpDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Top-Up Wallet"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text("Select amount to add:"),
//             SizedBox(height: 10),
//             Wrap(
//               spacing: 8.0,
//               children: [
//                 ChoiceChip(
//                   label: Text("₹500"),
//                   selected: _selectedTopUpAmount == 500.0,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedTopUpAmount = 500.0;
//                     });
//                     Navigator.pop(context);
//                     _openCheckout(500);
//                   },
//                 ),
//                 ChoiceChip(
//                   label: Text("₹1000"),
//                   selected: _selectedTopUpAmount == 1000.0,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedTopUpAmount = 1000.0;
//                     });
//                     Navigator.pop(context);
//                     _openCheckout(1000);
//                   },
//                 ),
//                 ChoiceChip(
//                   label: Text("₹1500"),
//                   selected: _selectedTopUpAmount == 1500.0,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedTopUpAmount = 1500.0;
//                     });
//                     Navigator.pop(context);
//                     _openCheckout(1500);
//                   },
//                 ),
//                 ChoiceChip(
//                   label: Text("₹2000"),
//                   selected: _selectedTopUpAmount == 2000.0,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedTopUpAmount = 2000.0;
//                     });
//                     Navigator.pop(context);
//                     _openCheckout(2000);
//                   },
//                 ),
//                 ChoiceChip(
//                   label: Text("₹2500"),
//                   selected: _selectedTopUpAmount == 2500.0,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedTopUpAmount = 2500.0;
//                     });
//                     Navigator.pop(context);
//                     _openCheckout(2500);
//                   },
//                 ),
//                 ChoiceChip(
//                   label: Text("₹3000"),
//                   selected: _selectedTopUpAmount == 3000.0,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedTopUpAmount = 3000.0;
//                     });
//                     Navigator.pop(context);
//                     _openCheckout(3000);
//                   },
//                 ),
//               ],
//             ),
//             // SizedBox(height: 20),
//             // TextField(
//             //   controller: _customAmountController,
//             //   keyboardType: TextInputType.number,
//             //   decoration: InputDecoration(
//             //     labelText: "Custom Amount",
//             //     prefixText: "₹",
//             //     border: OutlineInputBorder(),
//             //   ),
//             // ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (_customAmountController.text.isNotEmpty) {
//                 double customAmount = double.parse(_customAmountController.text);
//                 if (customAmount > 0) {
//                   setState(() {
//                     _selectedTopUpAmount = customAmount;
//                   });
//                   Navigator.pop(context);
//                   _openCheckout(customAmount);
//                 }
//               }
//             },
//             child: Text("Proceed"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showPaymentDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Make Payment"),
//         content: TextField(
//           controller: _customPaymentController,
//           keyboardType: TextInputType.number,
//           decoration: InputDecoration(
//             labelText: "Enter Amount",
//             prefixText: "₹",
//             border: OutlineInputBorder(),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (_customPaymentController.text.isNotEmpty) {
//                 double paymentAmount = double.parse(_customPaymentController.text);
//                 if (paymentAmount > 0) {
//                   Navigator.pop(context);
//                   _makePayment(paymentAmount);
//                 }
//               }
//             },
//             child: Text("Pay"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _razorpay!.clear();
//     _customAmountController.dispose();
//     _customPaymentController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Wallet"),
//       backgroundColor: Colors.redAccent.shade700,),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("Wallet Balance: ₹$walletBalance",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _showTopUpDialog,
//             child: Text("Top-Up Wallet"),
//           ),
//           ElevatedButton(
//             onPressed: _showPaymentDialog,
//             child: Text("Make Payment"),
//           ),
//           SizedBox(height: 20),
//           Expanded(child: _transactionHistory()),
//         ],
//       ),
//     );
//   }
//
//   // Widget _transactionHistory() {
//   //   return StreamBuilder<DocumentSnapshot>(
//   //     stream: _firestore.collection('wallets').doc(userId).snapshots(),
//   //     builder: (context, snapshot) {
//   //       if (!snapshot.hasData) return CircularProgressIndicator();
//   //
//   //       var walletData = snapshot.data!;
//   //       List transactions = walletData['transactions'] ?? [];
//   //
//   //       return ListView.builder(
//   //         itemCount: transactions.length,
//   //         itemBuilder: (context, index) {
//   //           var txn = transactions[index];
//   //           return ListTile(
//   //             title: Text("₹${txn['amount']} - ${txn['type']}"),
//   //             subtitle: Text(txn['timestamp']),
//   //             trailing: Icon(
//   //               txn['type'] == 'deposit' ? Icons.arrow_downward : Icons.arrow_upward,
//   //               color: txn['type'] == 'deposit' ? Colors.green : Colors.red,
//   //             ),
//   //           );
//   //         },
//   //       );
//   //     },
//   //   );
//   // }
//
//   Widget _transactionHistory() {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: _firestore.collection('wallets').doc(userId).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return CircularProgressIndicator();
//
//         var walletData = snapshot.data!;
//         List transactions = walletData['transactions'] ?? [];
//
//         // Sort transactions by timestamp in descending order (newest first)
//         transactions.sort((a, b) {
//           DateTime dateA = DateTime.parse(a['timestamp']);
//           DateTime dateB = DateTime.parse(b['timestamp']);
//           return dateB.compareTo(dateA); // Compare in reverse order
//         });
//
//         return ListView.builder(
//           itemCount: transactions.length,
//           itemBuilder: (context, index) {
//             var txn = transactions[index];
//             return ListTile(
//               title: Text("₹${txn['amount']} - ${txn['type']}"),
//               subtitle: Text(
//                 // Format the timestamp for better readability
//                 DateFormat('dd MMM yyyy, hh:mm a').format(
//                   DateTime.parse(txn['timestamp']),
//                 ),
//               ),
//               trailing: Icon(
//                 txn['type'] == 'deposit' ? Icons.arrow_downward : Icons.arrow_upward,
//                 color: txn['type'] == 'deposit' ? Colors.green : Colors.red,
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }



/// wallet working properly without withdrawal
library;



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// class WalletScreen extends StatefulWidget {
//   @override
//   _WalletScreenState createState() => _WalletScreenState();
// }
//
// class _WalletScreenState extends State<WalletScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late String customerId; // To hold the logged-in customer's ID
//
//   Razorpay? _razorpay;
//   double walletBalance = 0.0;
//   TextEditingController _customAmountController = TextEditingController();
//   TextEditingController _customPaymentController = TextEditingController();
//   double _selectedTopUpAmount = 500.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     _getUserWallet();
//   }
//
//   Future<void> _getUserWallet() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       customerId = user.uid;
//       DocumentSnapshot walletDoc = await _firestore
//           .collection('customers')
//           .doc(customerId)
//           .collection('wallets')
//           .doc('balance') // Using a single document for wallet data
//           .get();
//
//       if (!walletDoc.exists) {
//         await _firestore
//             .collection('customers')
//             .doc(customerId)
//             .collection('wallets')
//             .doc('balance')
//             .set({
//           'balance': 0.0,
//           'transactions': [],
//         });
//         setState(() => walletBalance = 0.0);
//       } else {
//         setState(() => walletBalance = walletDoc['balance']);
//       }
//     }
//   }
//
//   void _openCheckout(double amount) {
//     var options = {
//       // 'key': 'rzp_test_0JqfNU3fC2HG7Z', // Replace with your Razorpay Key
//       'key': 'rzp_live_jRrlgHE9Hldmk5',
//       'amount': amount * 100, // Razorpay works in paise
//       'name': 'Namma Savaari',
//       'description': 'Wallet Recharge',
//       'prefill': {'contact': '1234567890', 'email': 'user@example.com'}
//     };
//
//     _razorpay!.open(options);
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     walletBalance += _selectedTopUpAmount;
//
//     await _firestore
//         .collection('customers')
//         .doc(customerId)
//         .collection('wallets')
//         .doc('balance')
//         .update({
//       'balance': walletBalance,
//       'transactions': FieldValue.arrayUnion([
//         {
//           'id': response.paymentId,
//           'amount': _selectedTopUpAmount,
//           'type': 'deposit',
//           'timestamp': DateTime.now().toIso8601String()
//         }
//       ])
//     });
//
//     setState(() {});
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Recharge Successful!")));
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Payment Failed")));
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {}
//
//   Future<void> _makePayment(double amount) async {
//     if (walletBalance >= amount) {
//       walletBalance -= amount;
//
//       await _firestore
//           .collection('customers')
//           .doc(customerId)
//           .collection('wallets')
//           .doc('balance')
//           .update({
//         'balance': walletBalance,
//         'transactions': FieldValue.arrayUnion([
//           {
//             'id': DateTime.now().millisecondsSinceEpoch.toString(),
//             'amount': amount,
//             'type': 'payment',
//             'timestamp': DateTime.now().toIso8601String()
//           }
//         ])
//       });
//
//       setState(() {});
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Payment Successful!")));
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Insufficient Balance")));
//     }
//   }
//
//   void _showTopUpDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Top-Up Wallet"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text("Select amount to add:"),
//             SizedBox(height: 10),
//             Wrap(
//               spacing: 8.0,
//               children: [
//                 ChoiceChip(
//                   label: Text("₹1"),
//                   selected: _selectedTopUpAmount == 1.0,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedTopUpAmount = 1.0;
//                     });
//                     Navigator.pop(context);
//                     _openCheckout(1);
//                   },
//                 ),
//                 ChoiceChip(
//                   label: Text("₹500"),
//                   selected: _selectedTopUpAmount == 500.0,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedTopUpAmount = 500.0;
//                     });
//                     Navigator.pop(context);
//                     _openCheckout(500);
//                   },
//                 ),
//                 ChoiceChip(
//                   label: Text("₹1000"),
//                   selected: _selectedTopUpAmount == 1000.0,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedTopUpAmount = 1000.0;
//                     });
//                     Navigator.pop(context);
//                     _openCheckout(1000);
//                   },
//                 ),
//                 ChoiceChip(
//                   label: Text("₹1500"),
//                   selected: _selectedTopUpAmount == 1500.0,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedTopUpAmount = 1500.0;
//                     });
//                     Navigator.pop(context);
//                     _openCheckout(1500);
//                   },
//                 ),
//                 ChoiceChip(
//                   label: Text("₹2000"),
//                   selected: _selectedTopUpAmount == 2000.0,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedTopUpAmount = 2000.0;
//                     });
//                     Navigator.pop(context);
//                     _openCheckout(2000);
//                   },
//                 ),
//                 ChoiceChip(
//                   label: Text("₹2500"),
//                   selected: _selectedTopUpAmount == 2500.0,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedTopUpAmount = 2500.0;
//                     });
//                     Navigator.pop(context);
//                     _openCheckout(2500);
//                   },
//                 ),
//                 ChoiceChip(
//                   label: Text("₹3000"),
//                   selected: _selectedTopUpAmount == 3000.0,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedTopUpAmount = 3000.0;
//                     });
//                     Navigator.pop(context);
//                     _openCheckout(3000);
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (_customAmountController.text.isNotEmpty) {
//                 double customAmount = double.parse(_customAmountController.text);
//                 if (customAmount > 0) {
//                   setState(() {
//                     _selectedTopUpAmount = customAmount;
//                   });
//                   Navigator.pop(context);
//                   _openCheckout(customAmount);
//                 }
//               }
//             },
//             child: Text("Proceed"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showPaymentDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Make Payment"),
//         content: TextField(
//           controller: _customPaymentController,
//           keyboardType: TextInputType.number,
//           decoration: InputDecoration(
//             labelText: "Enter Amount",
//             prefixText: "₹",
//             border: OutlineInputBorder(),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (_customPaymentController.text.isNotEmpty) {
//                 double paymentAmount = double.parse(_customPaymentController.text);
//                 if (paymentAmount > 0) {
//                   Navigator.pop(context);
//                   _makePayment(paymentAmount);
//                 }
//               }
//             },
//             child: Text("Pay"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _razorpay!.clear();
//     _customAmountController.dispose();
//     _customPaymentController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Wallet"),
//         backgroundColor: Colors.redAccent.shade700,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(height: 20,),
//         Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Icon(Icons.account_balance_wallet, color: Colors.redAccent, size: 30),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Wallet Balance",
//                     style: TextStyle(fontSize: 16, color: Colors.redAccent),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     "₹$walletBalance",
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.redAccent,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//           SizedBox(height: 20),
//           // ElevatedButton(
//           //   onPressed: _showTopUpDialog,
//           //   child: Text("Top-Up Wallet"),
//           // ),
//
//           ElevatedButton.icon(
//             onPressed: _showTopUpDialog,
//             icon: const Icon(Icons.add, size: 22, color: Colors.white),
//             label: const Text(
//               "Top-Up Wallet",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
//             ),
//             style: ElevatedButton.styleFrom(
//               foregroundColor: Colors.white,
//               backgroundColor: Colors.redAccent,
//               padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               elevation: 5,
//             ),
//           ),
//
//           // ElevatedButton(
//           //   onPressed: _showPaymentDialog,
//           //   child: Text("Make Payment"),
//           // ),
//           // SizedBox(height: 20),
//           Expanded(child: _transactionHistory()),
//         ],
//       ),
//     );
//   }
//
//   Widget _transactionHistory() {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: _firestore
//           .collection('customers')
//           .doc(customerId)
//           .collection('wallets')
//           .doc('balance')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return CircularProgressIndicator();
//
//         var walletData = snapshot.data!;
//         List transactions = walletData['transactions'] ?? [];
//
//         // Sort transactions by timestamp in descending order (newest first)
//         transactions.sort((a, b) {
//           DateTime dateA = DateTime.parse(a['timestamp']);
//           DateTime dateB = DateTime.parse(b['timestamp']);
//           return dateB.compareTo(dateA); // Compare in reverse order
//         });
//
//         return ListView.builder(
//           itemCount: transactions.length,
//           itemBuilder: (context, index) {
//             var txn = transactions[index];
//             return ListTile(
//               title: Text("₹${txn['amount']} - ${txn['type']}"),
//               subtitle: Text(
//                 DateFormat('dd MMM yyyy, hh:mm a').format(
//                   DateTime.parse(txn['timestamp']),
//                 ),
//               ),
//               trailing: Icon(
//                 txn['type'] == 'deposit' ? Icons.arrow_downward : Icons.arrow_upward,
//                 color: txn['type'] == 'deposit' ? Colors.green : Colors.red,
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }



// adding withdrawal option also


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String customerId;

  Razorpay? _razorpay;
  double walletBalance = 0.0;
  final TextEditingController _customAmountController = TextEditingController();
  final TextEditingController _customPaymentController = TextEditingController();
  final TextEditingController _withdrawAmountController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  double _selectedTopUpAmount = 500.0;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _getUserWallet();
  }

  Future<void> _getUserWallet() async {
    User? user = _auth.currentUser;
    if (user != null) {
      customerId = user.uid;
      DocumentSnapshot walletDoc = await _firestore
          .collection('customers')
          .doc(customerId)
          .collection('wallets')
          .doc('balance')
          .get();

      if (!walletDoc.exists) {
        await _firestore
            .collection('customers')
            .doc(customerId)
            .collection('wallets')
            .doc('balance')
            .set({
          'balance': 0.0,
          'transactions': [],
        });
        setState(() => walletBalance = 0.0);
      } else {
        setState(() => walletBalance = walletDoc['balance']);
      }
    }
  }

  void _openCheckout(double amount) {
    var options = {
      'key': 'rzp_live_jRrlgHE9Hldmk5',
      'amount': amount * 100,
      'name': 'Namma Savaari',
      'description': 'Wallet Recharge',
      'prefill': {'contact': '1234567890', 'email': 'user@example.com'}
    };

    _razorpay!.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    walletBalance += _selectedTopUpAmount;

    await _firestore
        .collection('customers')
        .doc(customerId)
        .collection('wallets')
        .doc('balance')
        .update({
      'balance': walletBalance,
      'transactions': FieldValue.arrayUnion([
        {
          'id': response.paymentId,
          'amount': _selectedTopUpAmount,
          'type': 'deposit',
          'timestamp': DateTime.now().toIso8601String(),
          'status': 'completed'
        }
      ])
    });

    setState(() {});
                          if(!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Recharge Successful!")));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Payment Failed")));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}


  Future<void> _withdrawToBank(double amount) async {
    if (walletBalance < amount) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Insufficient Balance")));
      return;
    }

    if (_bankAccountController.text.isEmpty || _ifscController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please enter bank details")));
      return;
    }

    // First create a pending transaction
    String txnId = DateTime.now().millisecondsSinceEpoch.toString();
    await _firestore
        .collection('customers')
        .doc(customerId)
        .collection('wallets')
        .doc('balance')
        .update({
      'balance': walletBalance - amount,
      'transactions': FieldValue.arrayUnion([
        {
          'id': txnId,
          'amount': amount,
          'type': 'withdrawal',
          'timestamp': DateTime.now().toIso8601String(),
          'status': 'pending',
          'bank_account': _bankAccountController.text,
          'ifsc_code': _ifscController.text
        }
      ])
    });

    // In a real app, here you would call your backend to process the actual bank transfer
    // For demo purposes, we'll simulate a successful transfer after 2 seconds
    Future.delayed(const Duration(seconds: 2), () async {
      // Update the transaction status to completed
      var walletDoc = await _firestore
          .collection('customers')
          .doc(customerId)
          .collection('wallets')
          .doc('balance')
          .get();

      List transactions = walletDoc['transactions'];
      int index = transactions.indexWhere((txn) => txn['id'] == txnId);

      if (index != -1) {
        transactions[index]['status'] = 'completed';

        await _firestore
            .collection('customers')
            .doc(customerId)
            .collection('wallets')
            .doc('balance')
            .update({
          'transactions': transactions
        });

        setState(() {
          walletBalance -= amount;
        });

        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Withdrawal Successful! Amount will be credited to your bank account within 3-5 business days.")));
        }
      }
    });

    setState(() {
      walletBalance -= amount;
    });
                      if(!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Withdrawal request submitted")));
  }

  void _showTopUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Top-Up Wallet"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Select amount to add:"),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: const Text("₹1"),
                  selected: _selectedTopUpAmount == 1.0,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTopUpAmount = 1.0;
                    });
                    Navigator.pop(context);
                    _openCheckout(1);
                  },
                ),
                ChoiceChip(
                  label: const Text("₹500"),
                  selected: _selectedTopUpAmount == 500.0,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTopUpAmount = 500.0;
                    });
                    Navigator.pop(context);
                    _openCheckout(500);
                  },
                ),
                ChoiceChip(
                  label: const Text("₹1000"),
                  selected: _selectedTopUpAmount == 1000.0,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTopUpAmount = 1000.0;
                    });
                    Navigator.pop(context);
                    _openCheckout(1000);
                  },
                ),
                ChoiceChip(
                  label: const Text("₹1500"),
                  selected: _selectedTopUpAmount == 1500.0,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTopUpAmount = 1500.0;
                    });
                    Navigator.pop(context);
                    _openCheckout(1500);
                  },
                ),
                ChoiceChip(
                  label: const Text("₹2000"),
                  selected: _selectedTopUpAmount == 2000.0,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTopUpAmount = 2000.0;
                    });
                    Navigator.pop(context);
                    _openCheckout(2000);
                  },
                ),
                ChoiceChip(
                  label: const Text("₹2500"),
                  selected: _selectedTopUpAmount == 2500.0,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTopUpAmount = 2500.0;
                    });
                    Navigator.pop(context);
                    _openCheckout(2500);
                  },
                ),
                ChoiceChip(
                  label: const Text("₹3000"),
                  selected: _selectedTopUpAmount == 3000.0,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTopUpAmount = 3000.0;
                    });
                    Navigator.pop(context);
                    _openCheckout(3000);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _customAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Custom Amount",
                prefixText: "₹",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_customAmountController.text.isNotEmpty) {
                double customAmount = double.parse(_customAmountController.text);
                if (customAmount > 0) {
                  setState(() {
                    _selectedTopUpAmount = customAmount;
                  });
                  Navigator.pop(context);
                  _openCheckout(customAmount);
                }
              }
            },
            child: const Text("Proceed"),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Withdraw to Bank"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _withdrawAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Amount to withdraw",
                  prefixText: "₹",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _bankAccountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Bank Account Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _ifscController,
                decoration: const InputDecoration(
                  labelText: "IFSC Code",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              const Text("Note: Withdrawals may take 3-5 business days to process",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_withdrawAmountController.text.isNotEmpty) {
                double withdrawAmount = double.parse(_withdrawAmountController.text);
                if (withdrawAmount > 0) {
                  _withdrawToBank(withdrawAmount);
                }
              }
            },
            child: const Text("Withdraw"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _razorpay!.clear();
    _customAmountController.dispose();
    _customPaymentController.dispose();
    _withdrawAmountController.dispose();
    _bankAccountController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
        backgroundColor: Colors.redAccent.shade700,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.account_balance_wallet, color: Colors.redAccent, size: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Wallet Balance",
                        style: TextStyle(fontSize: 16, color: Colors.redAccent),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "₹${walletBalance.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _showTopUpDialog,
                icon: const Icon(Icons.add, size: 22, color: Colors.white),
                label: const Text(
                  "Top-Up",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showWithdrawDialog,
                icon: const Icon(Icons.arrow_upward, size: 22, color: Colors.white),
                label: const Text(
                  "Withdraw",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: _transactionHistory()),
        ],
      ),
    );
  }

  Widget _transactionHistory() {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore
          .collection('customers')
          .doc(customerId)
          .collection('wallets')
          .doc('balance')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        var walletData = snapshot.data!;
        List transactions = walletData['transactions'] ?? [];

        transactions.sort((a, b) {
          DateTime dateA = DateTime.parse(a['timestamp']);
          DateTime dateB = DateTime.parse(b['timestamp']);
          return dateB.compareTo(dateA);
        });

        if (transactions.isEmpty) {
          return const Center(
            child: Text("No transactions yet", style: TextStyle(color: Colors.grey)),
          );
        }

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            var txn = transactions[index];
            bool isDeposit = txn['type'] == 'deposit';
            bool isWithdrawal = txn['type'] == 'withdrawal';
            bool isPending = txn['status'] == 'pending';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                leading: Icon(
                  isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isDeposit ? Colors.green : Colors.red,
                ),
                title: Text(
                  "${isDeposit ? 'Deposit' : isWithdrawal ? 'Withdrawal' : 'Payment'} - ₹${txn['amount']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isPending ? Colors.orange : isDeposit ? Colors.green : Colors.red,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(
                        DateTime.parse(txn['timestamp']),
                      ),
                    ),
                    if (isWithdrawal) Text(
                      "Bank: ${txn['bank_account']?.substring(txn['bank_account'].length - 4) ?? ''}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (isPending) const Text(
                      "Status: Pending",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
                trailing: isPending
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}

