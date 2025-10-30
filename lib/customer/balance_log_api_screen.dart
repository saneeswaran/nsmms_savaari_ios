// Response getting in console

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class BalanceLogScreen extends StatefulWidget {
//   @override
//   _BalanceLogScreenState createState() => _BalanceLogScreenState();
// }
//
// class _BalanceLogScreenState extends State<BalanceLogScreen> {
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
//         // Parse and print the response
//         final responseData = json.decode(response.body);
//         print("Balance Log Response: $responseData");
//       } else {
//         print("Failed to fetch balance log. Status code: ${response.statusCode}");
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
//     fetchBalanceLog(); // Call the API when the screen initializes
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Balance Log"),
//       ),
//       body: Center(
//         child: Text(
//           "Fetching balance log...",
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }

// trying to print the response ina console

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BalanceLogScreen extends StatefulWidget {
  const BalanceLogScreen({super.key});

  @override
  _BalanceLogScreenState createState() => _BalanceLogScreenState();
}

class _BalanceLogScreenState extends State<BalanceLogScreen> {
  List<dynamic> balanceLogs = []; // To store the balance log data
  bool isLoading = true; // To manage the loading state

  // Function to fetch the balance log
  Future<void> fetchBalanceLog() async {
    // const String apiUrl = "https://bus.srdvapi.com/v5/rest/BalanceLog";
    const String apiUrl =
        "https://namma-savaari-api-backend-9mpl.vercel.app/balance-log";

    // Request body
    final Map<String, String> requestBody = {
      "EndUserIp": "157.48.136.69", // Replace with the actual IP
      "ClientId": "180187", // Replace with your Client ID
      "UserName": "Namma434", // Replace with your User Name
      "Password": "Namma@4341", // Replace with your Password
    };

    try {
      // Make the API request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Api-Token": "Namma@90434#34", // Add the actual API token
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Parse the response and update the state
        final responseData = json.decode(response.body);
        setState(() {
          balanceLogs = responseData['Result'] ?? []; // Extract balance logs
          isLoading = false;
        });
      } else {
        log(
            "Failed to fetch balance log. Status code: ${response.statusCode}");
        log("Response body: ${response.body}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      log("An error occurred: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBalanceLog(); // Call the API when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Balance Log",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent.shade700,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : balanceLogs.isEmpty
              ? const Center(
                  child: Text(
                    "No data available",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: balanceLogs.length,
                  itemBuilder: (context, index) {
                    final log = balanceLogs[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ID: ${log['ID'] ?? 'N/A'}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent.shade700)),
                            Text("Date: ${log['Date'] ?? 'N/A'}"),
                            // Text("Client ID: ${log['ClientID'] ?? 'N/A'}"),
                            // Text("Client Name: ${log['ClientName'] ?? 'N/A'}"),
                            // Text("Detail: ${log['Detail'] ?? 'N/A'}"),
                            // Text("Debit: ${log['Debit'] ?? 'N/A'}"),
                            // Text("Credit: ${log['Credit'] ?? 'N/A'}"),
                            Text("Balance: ${log['Balance'] ?? 'N/A'}"),
                            Text("Module: ${log['Module'] ?? 'N/A'}"),
                            // Text("Trace ID: ${log['TraceID'] ?? 'N/A'}"),
                            // Text("Ref ID: ${log['RefID'] ?? 'N/A'}"),
                            // Text("Updated By: ${log['UpdatedBy'] ?? 'N/A'}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
