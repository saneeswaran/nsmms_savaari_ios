import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  // Loading
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Center(
        child: Text('Please login to view your bookings'),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('customers')
                .doc(currentUser.uid)
                .collection('bookings')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error loading bookings'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () async {},
                        child: Text('No bookings yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your upcoming trips will appear here',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView(
                padding: EdgeInsets.all(16),
                children: snapshot.data!.docs.map((booking) {
                  final journey =
                      booking['journeyDetails'] as Map<String, dynamic>;
                  final passengers = List<Map<String, dynamic>>.from(
                      booking['passengerDetails']);
                  final date = (booking['createdAt'] as Timestamp).toDate();
                  final formattedDate = DateFormat('MMM dd, yyyy').format(date);
                  final formattedTime = DateFormat('hh:mm a').format(date);

                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header with status
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getStatusColor(booking['bookingStatus']),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                booking['ticketNumber'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                booking['bookingStatus']
                                    .toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Journey details
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Route
                              SizedBox(
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          journey['source'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward,
                                          color: Colors.grey),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          journey['destination'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 12),

                              // Travel details
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Icon(Icons.directions_bus,
                                        size: 16, color: Colors.grey),
                                    SizedBox(width: 8),
                                    Text(
                                      '${journey['travelName']} • ${journey['busType']}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),

                              // Date and seat
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      size: 16, color: Colors.grey),
                                  SizedBox(width: 8),
                                  Text(
                                    '${_formatDate(journey['date'])} • Seat ${journey['seats'].join(', ')}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),

                              SizedBox(height: 8),

                              // Boarding point
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      size: 16, color: Colors.grey),
                                  SizedBox(width: 8),
                                  Text(
                                    'Boarding: ${journey['boardingPoint']}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),

                              // Dropping point
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      size: 16, color: Colors.grey),
                                  SizedBox(width: 8),
                                  Text(
                                    'Dropping: ${journey['droppingPoint']}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),

                              SizedBox(height: 16),
                              Divider(height: 1),
                              SizedBox(height: 16),

                              // Passenger details
                              Text(
                                'Passenger Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              SizedBox(height: 8),

                              // Display all passengers
                              Column(
                                children: passengers
                                    .map((passenger) => Padding(
                                          padding: EdgeInsets.only(bottom: 12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                passenger['name'] ??
                                                    'Name not available',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.green),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '${passenger['age'] ?? 'N/A'} yrs • ${_getGenderText(passenger['gender'])}',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                'Seat: ${passenger['seat'] ?? 'N/A'}',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),

                              SizedBox(height: 16),
                              Divider(height: 1),
                              SizedBox(height: 16),

                              // Booking and payment info
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Booked on',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text('$formattedDate at $formattedTime'),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Amount paid',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        '₹${booking['paymentAmount']}',
                                        // '₹${booking['invoiceAmount']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Cancel button
                        if (booking['bookingStatus'] == 'Confirmed')
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Colors.grey.shade200)),
                            ),
                            child: TextButton(
                              onPressed: () {
                                _showCancelDialog(context, booking);
                              },
                              child: Text(
                                'CANCEL',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  String _getGenderText(dynamic genderCode) {
    if (genderCode == null) return 'N/A';
    if (genderCode == '1') return 'Male';
    if (genderCode == '2') return 'Female';
    if (genderCode == '3') return 'Other';
    return genderCode.toString();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green.shade600;
      case 'cancelled':
        return Colors.red.shade600;
      case 'pending':
        return Colors.orange.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  final List<String> cancellationReasons = [
    'Change of travel plans',
    'Found better alternative',
    'Bus timing not suitable',
    'Personal emergency',
    'Other reason'
  ];

  void _showCancelDialog(BuildContext context, DocumentSnapshot booking) {
    String selectedReason = cancellationReasons[0];
    final parentContext = context;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Cancel Booking'),
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Are you sure you want to cancel this booking?'),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedReason,
                      isExpanded: true,
                      items: cancellationReasons.map((String reason) {
                        return DropdownMenuItem<String>(
                          value: reason,
                          child: Text(
                            reason,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Reason for cancellation',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('NO'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _cancelBooking(parentContext, booking, selectedReason);
                },
                child: Text('YES, CANCEL', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _cancelBooking(
      BuildContext context, DocumentSnapshot booking, String remarks) async {

    setState(() {
      _isLoading = true; // Show loading
    });
    final currentUser = FirebaseAuth.instance.currentUser;
    log("=== Cancel Booking Started ===");

    if (currentUser == null) {
      log("No current user logged in. Exiting.");
      return;
    }

    log("Current User ID: ${currentUser.uid}");
    log("Booking Document ID: ${booking.id}");
    log("Booking Data: ${booking.data()}");

    try {
      log("Parsing busId and seatId...");
      final busId = int.tryParse(booking['busId'].toString());
      final seatId = booking['passengerDetails'][0]['seat'];
      final traceId = booking['traceId'];
      log("$seatId");

      log("Parsed busId: $busId, seatId: $seatId");

      if (busId == null || seatId == null) {
        throw Exception("Invalid BusId or SeatId");
      }

      final requestBody = {
        "EndUserIp": "122.171.16.249",
        "ClientId": "180187",
        "UserName": "Namma434",
        "Password": "Namma@4341",
        "BusId": busId,
        "SeatName": seatId,
        "Remarks": remarks,
        "TraceId": traceId,
      };

      log("Request Body: $requestBody");

      const headers = {
        "Content-Type": "application/json",
        "Api-Token": "Namma@90434#34",
      };

      log("Sending POST request to cancel booking...");
      final response = await http.post(
        Uri.parse(
            "https://namma-savaari-api-backend.vercel.app/cancel-booking"),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      log("HTTP Status Code: ${response.statusCode}");
      log("HTTP Response Body: ${response.body}");

      final responseData = jsonDecode(response.body);
      log("Decoded Response Data: $responseData");

      final apiSuccess = response.statusCode == 200 &&
          (responseData['Error'] == null ||
              responseData['Error']['ErrorCode'] == 0);

// Also allow "already canceled" case
      final alreadyCancelled = responseData['Error']?['ErrorMessage']
              ?.contains('Cancellation Already Done') ??
          false;

      if (apiSuccess || alreadyCancelled) {
        log("Cancellation successful. Updating Firestore...");

        await FirebaseFirestore.instance
            .collection('customers')
            .doc(currentUser.uid)
            .collection('bookings')
            .doc(booking.id)
            .update({
          'bookingStatus': 'Cancelled',
          'lastUpdated': FieldValue.serverTimestamp(),
          'cancellationTime': FieldValue.serverTimestamp(),
          'cancellationDetails': {
            'apiResponse': responseData,
            'cancelledAt': DateTime.now().toIso8601String(),
            'refundAmount': responseData['Response']?['RefundAmount'],
            'cancellationReason': remarks,
          }
        });
        // messenger.showSnackBar(
        //   const SnackBar(
        //     content: Text(
        //       'Your booking is canceled. Refund will be processed within 24 hours.',
        //     ),
        //     backgroundColor: Colors.green,
        //   ),
        // );

        // 2️⃣ Update all_bookings collection
        final allBookingsSnapshot = await FirebaseFirestore.instance
            .collection('all_bookings')
            .where('ticketNumber', isEqualTo: booking['ticketNumber'])
            .where('userId', isEqualTo: currentUser.uid)
            .get();

        for (var doc in allBookingsSnapshot.docs) {
          await doc.reference.update({
            'bookingStatus': 'Cancelled', // mark canceled
            'lastUpdated': FieldValue.serverTimestamp(),
            'cancellationTime': FieldValue.serverTimestamp(),
            'cancellationDetails': {
              'apiResponse': responseData,
              'cancelledAt': DateTime.now().toIso8601String(),
              'refundAmount': responseData['Response']?['RefundAmount'],
              'cancellationReason': remarks,
            },
          });
        }

        log("Firestore updated successfully.");
        if (!context.mounted) return;

        // Show green if successful and no API error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              apiSuccess
                  ? 'Booking cancelled successfully.'
                  : 'Cancellation Already Done or Pending.',
            ),
            backgroundColor: apiSuccess ? Colors.green : Colors.yellow[800],
          ),
        );

        // if (!context.mounted) return;
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //         'Your booking is canceled. Refund will be processed within 24 hours.'),
        //     backgroundColor: Colors.green,
        //   ),
        // );
      } else {
        final errorMessage =
            responseData['Error']?['ErrorMessage'] ?? 'Cancellation failed';
        log("API returned an error: $errorMessage");
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contact Admin, Cancellation failed:\n$responseData'),
            backgroundColor: Colors.red,
          ),
        );
        throw Exception(errorMessage);
      }
    } catch (e, stackTrace) {
      log("Exception caught during cancellation: $e");
      log("Stack trace: $stackTrace");

      if (!context.mounted) return;
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //         'Cancellation failed: $e \n Please contact our service team or admin for assistance with this booking.'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading
      });
      log("Closing loading indicator...");

      log("=== Cancel Booking Finished ===");
    }
  }
}
