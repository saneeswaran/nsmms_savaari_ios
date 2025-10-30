import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BlockTicketPage extends StatefulWidget {
  const BlockTicketPage({super.key});

  @override
  _BlockTicketPageState createState() => _BlockTicketPageState();
}

class _BlockTicketPageState extends State<BlockTicketPage> {
  bool _isLoading = false;
  String _errorMessage = "";

  // Replace these with the actual passenger details
  String firstName = 'Ashok';
  String lastName = 'Bunga';
  String email = 'ashokbunga83@gmail.com';
  String phoneNo = '8555003861';
  String gender = 'Male';
  String age = '24';
  String address = 'Bengaluru';
  String seatNumber = '1';
  String seatFare = '400';

  Future<void> _blockTicket() async {
    const String apiUrl = "https://bus.srdvtest.com/v5/rest/Block";
    const Map<String, dynamic> requestBody = {
      "ClientId": "180131",
      "UserName": "Namma434",
      "Password": "Namma@4341",
      "TraceId": "1",
      "ResultIndex": "1",
      "BordingPointId": "1", // This should be the selected boarding point ID
      "DropingPointId": "1", // This should be the selected dropping point ID
      "RefID": "1", // This could be a reference ID if required
      "LeadPassenger": "1", // Assuming first passenger is the lead
      "FirstName": "Ashok",
      "LastName": "Bunga",
      "Email": "ashokbunga83@gmail.com",
      "Phoneno": "8555003861",
      "Gender": "Male",
      "Age": "24",
      "ColumnNo": "000", // Set accordingly
      "IsLadiesSeat": false,
      "IsMaleSeat": false,
      "IsUpper": false,
      "RowNo": "000", // Set accordingly
      "SeatFare": 400,
      "SeatIndex": 1,
      "SeatName": "1",
      "SeatStatus": true,
      "SeatType": 1,
      "width": 1,
      "CurrencyCode": "INR",
      "BasePrice": 400,
      "Tax": 0,
      "OtherCharges": 0,
      "Discount": 0,
      "PublishedPrice": 400,
      "PublishedPriceRoundedOff": 400,
      "OfferedPrice": "380",
      "OfferedPriceRoundedOff": 380,
      "AgentCommission": 20,
      "AgentMarkUp": 0,
      "TDS": 8,
      "CGSTAmount": 0,
      "CGSTRate": 0,
      "CessAmount": 0,
      "CessRate": 0,
      "IGSTAmount": 0,
      "IGSTRate": 18,
      "SGSTAmount": 0,
      "SGSTRate": 0,
      "TaxableAmount": 0
    };

    const headers = {
      "Content-Type": "application/json",
      "Api-Token": "Namma@90434#34",
    };

    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        bool isPriceChanged = responseBody['IsPriceChanged'] ?? false;
        if (isPriceChanged) {
          // Handle price change, if necessary
        }
        // Handle successful response
        setState(() {
          // Handle any successful response actions here
          _errorMessage = "Ticket blocked successfully!";
        });
      } else {
        setState(() {
          _errorMessage = "Failed to block ticket: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade700,
        title: const Text("Boock Ticket"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _blockTicket,
              child: const Text('Boock Ticket'),
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty) Text(_errorMessage),
          ],
        ),
      ),
    );
  }
}
