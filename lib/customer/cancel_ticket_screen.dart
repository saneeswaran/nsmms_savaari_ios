// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class CancelTicketScreen extends StatelessWidget {
//   Future<void> cancelBusBooking() async {
//     const String apiUrl = "https://bus.srdvapi.com/v5/rest/cancelbusbooking";
//
//     // Request body
//     final Map<String, String> requestBody = {
//       "EndUserIp": "122.171.16.249", // Replace with the actual IP
//       "ClientId": "180187",         // Replace with your Client ID
//       "UserName": "Namma434",       // Replace with your User Name
//       "Password": "Namma@4341",     // Replace with your Password
//       "BusId": "358801",            // ID of the bus being canceled
//       "SeatId": "46",               // Seat ID for the booking
//       "Remarks": "i have booked the wrong bus" // Reason for cancellation
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
//         // Parse and log the successful response
//         final responseData = json.decode(response.body);
//         print("Cancel Booking API Response: $responseData");
//       } else {
//         print("Failed to cancel booking. Status code: ${response.statusCode}");
//         print("Response body: ${response.body}");
//       }
//     } catch (error) {
//       print("An error occurred: $error");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Cancel Bus Booking"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             cancelBusBooking();
//           },
//           child: Text("Cancel Booking"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.red, // Optional styling
//           ),
//         ),
//       ),
//     );
//   }
// }


//Testing


import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CancelTicketScreen extends StatefulWidget {
  final String busId;
  final dynamic seatIndex;

  // Constructor to accept BusId and SeatIndex
  const CancelTicketScreen({
    super.key,
    required this.busId,
    required this.seatIndex,
  });

  @override
  _CancelTicketScreenState createState() => _CancelTicketScreenState();
}

class _CancelTicketScreenState extends State<CancelTicketScreen> {
  final TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Print busId and seatIndex in the console
    log("Bus ID: ${widget.busId}");
    log("Seat Index: ${widget.seatIndex}");
  }

  // Function to call the API for canceling the bus booking
  Future<void> cancelBusBooking(BuildContext context) async {
    const String apiUrl = "https://bus.srdvapi.com/v5/rest/cancelbusbooking";

    // Request body with dynamic BusId, SeatId, and Remarks
    final Map<String, String> requestBody = {
      "EndUserIp": "122.171.16.249", // Replace with the actual IP
      "ClientId": "180187",         // Replace with your Client ID
      "UserName": "Namma434",       // Replace with your User Name
      "Password": "Namma@4341",     // Replace with your Password
      "BusId": widget.busId,        // Use the passed BusId
      "SeatId": widget.seatIndex,   // Use the passed SeatIndex
      "Remarks": _remarksController.text, // Use the user input from the text field
    };

    try {
      // Make the API request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Api-Token": "Namma@90434#34", // Replace with the actual API token
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Parse the successful response
        final responseData = json.decode(response.body);
        log("Cancel Booking API Response: $responseData");

        // Show success message
                              if(!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully canceled the booking!")),
        );

        // Optional: Navigate back to the previous screen after cancellation
                              if(!context.mounted) return;
        Navigator.pop(context);
      } else {
        // Log and show failure message
        log("Failed to cancel booking. Status code: ${response.statusCode}");
        log("Response body: ${response.body}");
                              if(!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cancellation failed. Please try again.")),
        );
      }
    } catch (error) {
      // Log and show error message
      log("An error occurred: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cancel Bus Booking"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Remarks text field
            TextField(
              controller: _remarksController,
              decoration: const InputDecoration(
                labelText: "Remarks",
                hintText: "Enter the reason for cancellation",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            // Cancel booking button
            ElevatedButton(
              onPressed: () {
                if (_remarksController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a reason for cancellation.")),
                  );
                } else {
                  cancelBusBooking(context); // Call the cancel function
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Styling the button
              ),
              child: const Text("Cancel Booking"),
            ),
          ],
        ),
      ),
    );
  }
}

