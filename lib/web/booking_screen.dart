import 'dart:convert';
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
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Center(
        child: Text('Please login to view your bookings'),
      );
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
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
                  Text(
                    'No bookings yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
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

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final booking = snapshot.data!.docs[index];
              final journey = booking['journeyDetails'];
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
                            booking['bookingStatus'].toString().toUpperCase(),
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
                          // Route
                          SizedBox(
                            width: double.infinity, // Take full width
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
                                  Icon(Icons.arrow_forward, color: Colors.grey),
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
                                '${_formatDate(journey['date'])} • Seat ${journey['seats']}',
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

                          // Boarding point
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 16, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                'Droping: ${journey['droppingPoint']}',
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

                          // Text(
                          //  "${ passenger['name']}",
                          //   style: TextStyle(fontSize: 15),
                          // ),

                          SizedBox(height: 4),

                          // Text(
                          //   '${passenger['age']} yrs • ${passenger['gender']}',
                          //   style: TextStyle(color: Colors.grey),
                          // ),

                          SizedBox(height: 16),
                          Divider(height: 1),
                          SizedBox(height: 16),

                          // Booking and payment info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    '₹${booking['invoiceAmount']}',
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

                    /// Final change

                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    //   decoration: BoxDecoration(
                    //     border: Border(top: BorderSide(color: Colors.grey.shade200)),
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       TextButton(
                    //         onPressed: () {
                    //           // View ticket details
                    //           _showBookingDetails(context, booking);
                    //         },
                    //         child: Text(
                    //           'VIEW TICKET',
                    //           style: TextStyle(color: Colors.redAccent.shade700),
                    //         ),
                    //       ),
                    //
                    //       if (booking['bookingStatus'] == 'Confirmed')
                    //         TextButton(
                    //           onPressed: () {
                    //             // Cancel booking - pass the full document snapshot
                    //             _showCancelDialog(context, booking);
                    //           },
                    //           child: Text(
                    //             'CANCEL',
                    //             style: TextStyle(color: Colors.red),
                    //           ),
                    //         ),
                    //     ],
                    //   ),
                    // ),

                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey.shade200)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              // View ticket details
                              _showBookingDetails(context, booking);
                            },
                            child: Text(
                              'VIEW TICKET',
                              style:
                                  TextStyle(color: Colors.redAccent.shade700),
                            ),
                          ),
                          if (booking['bookingStatus'] == 'Confirmed')
                            TextButton(
                              onPressed: () {
                                _showCancelDialog(context, booking);
                              },
                              child: Text(
                                'CANCEL',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
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

  void _showBookingDetails(BuildContext context, DocumentSnapshot booking) {
    final journey = booking['journeyDetails'];
    final passenger = booking['passengerDetails'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ticket Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ticket No: ${booking['ticketNumber']}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('PNR: ${booking['operatorPNR']}'),
              SizedBox(height: 16),
              Text('Journey Details',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('${journey['source']} to ${journey['destination']}'),
              Text(_formatDate(journey['date'])),
              Text('${journey['travelName']} (${journey['busType']})'),
              Text('Seat: ${journey['seatNumber']}'),
              SizedBox(height: 16),
              Text('Timings', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Departure: ${journey['departureTime']}'),
              Text('Arrival: ${journey['arrivalTime']}'),
              SizedBox(height: 16),
              Text('Boarding Point',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(journey['boardingPoint']),
              SizedBox(height: 16),
              Text('Passenger Details',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(passenger['name']),
              Text('${passenger['age']} yrs • ${passenger['gender']}'),
              Text(passenger['phone']),
              SizedBox(height: 16),
              Text('Payment Details',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Amount: ₹${booking['invoiceAmount']}'),
              Text('Status: ${booking['bookingStatus']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  // void _showCancelDialog(BuildContext context, DocumentSnapshot booking) {
  final List<String> cancellationReasons = [
    'Change of travel plans',
    'Found better alternative',
    'Bus timing not suitable',
    'Personal emergency',
    'Other reason'
  ];

// Update the _showCancelDialog method to include remarks selection
  void _showCancelDialog(BuildContext context, DocumentSnapshot booking) {
    String selectedReason = cancellationReasons[0]; // Default reason

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Cancel Booking'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Are you sure you want to cancel this booking?'),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedReason,
                  items: cancellationReasons.map((String reason) {
                    return DropdownMenuItem<String>(
                      value: reason,
                      child: Text(reason),
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
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('NO'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close the dialog
                  await _cancelBooking(context, booking, selectedReason);
                },
                child: Text('YES, CANCEL', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Final Change

  // Future<void> _cancelBooking(BuildContext context, DocumentSnapshot booking, String remarks) async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) return;
  //
  //   // Show loading indicator
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => Center(child: CircularProgressIndicator()),
  //   );
  //
  //   try {
  //     const String apiUrl = "http://3.7.121.234/bus-api/cancelbusbooking";
  //
  //     final busId = booking['busId'] is int
  //         ? booking['busId'] as int
  //         : int.parse(booking['busId'].toString());
  //
  //     final seatId = booking['journeyDetails']['seatNumber'] is int
  //         ? booking['journeyDetails']['seatNumber'] as int
  //         : int.parse(booking['journeyDetails']['seatNumber'].toString());
  //
  //     final Map<String, dynamic> requestBody = {
  //       "EndUserIp": "122.171.16.249",
  //       "ClientId": "180187",
  //       "UserName": "Namma434",
  //       "Password": "Namma@4341",
  //       "BusId": busId,
  //       "SeatId": seatId,
  //       "Remarks": remarks
  //     };
  //
  //     const headers = {
  //       "Content-Type": "application/json",
  //       "Api-Token": "Namma@90434#34",
  //     };
  //
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: headers,
  //       body: jsonEncode(requestBody),
  //     );
  //
  //     // Hide loading indicator
  //     Navigator.pop(context);
  //
  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //
  //       if (responseData['Error'] == null ||
  //           (responseData['Error']['ErrorCode'] == 0 &&
  //               responseData['Error']['ErrorMessage'].isEmpty)) {
  //
  //         // Update Firestore booking status
  //         await FirebaseFirestore.instance
  //             .collection('customers')
  //             .doc(currentUser.uid)
  //             .collection('bookings')
  //             .doc(booking.id)
  //             .update({
  //           'bookingStatus': 'Cancelled',
  //           'lastUpdated': FieldValue.serverTimestamp(),
  //           'cancellationTime': FieldValue.serverTimestamp(),
  //           'cancellationDetails': {
  //             'apiResponse': responseData,
  //             'cancelledAt': DateTime.now().toIso8601String(),
  //             'refundAmount': responseData['Response']?['RefundAmount'],
  //             'cancellationReason': remarks,
  //           }
  //         });
  //
  //         // Show success snackbar message
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Ticket canceled successfully'),
  //             backgroundColor: Colors.green,
  //             duration: Duration(seconds: 3),
  //           ),
  //         );
  //
  //       } else {
  //         // Show API error message
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(responseData['Error']['ErrorMessage'] ?? 'Cancellation failed'),
  //             backgroundColor: Colors.red,
  //           ),
  //         );
  //       }
  //     } else {
  //       // Show HTTP error message
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Server returned status code ${response.statusCode}'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     // Hide loading indicator in case of error
  //     Navigator.pop(context);
  //
  //     // Show exception error message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Cancellation failed: ${e.toString()}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  Future<void> _cancelBooking(
      BuildContext context, DocumentSnapshot booking, String remarks) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      const String apiUrl =
          "https://namma-savaari-api-backend-9mpl.vercel.app/cancel-booking";

      final busId = booking['busId'] is int
          ? booking['busId'] as int
          : int.parse(booking['busId'].toString());

      final seatId = booking['journeyDetails']['seatNumber'] is int
          ? booking['journeyDetails']['seatNumber'] as int
          : int.parse(booking['journeyDetails']['seatNumber'].toString());

      final Map<String, dynamic> requestBody = {
        "EndUserIp": "122.171.16.249",
        "ClientId": "180187",
        "UserName": "Namma434",
        "Password": "Namma@4341",
        "BusId": busId,
        "SeatId": seatId,
        "Remarks": remarks
      };

      const headers = {
        "Content-Type": "application/json",
        "Api-Token": "Namma@90434#34",
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Hide loading indicator
                            if(!context.mounted) return;
      Navigator.pop(context);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['Error'] == null ||
            (responseData['Error']['ErrorCode'] == 0 &&
                responseData['Error']['ErrorMessage'].isEmpty)) {
          // Update Firestore booking status
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

          // Show success snackbar message with refund info
                                if(!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Your booking is canceled. Refund will be processed within 25 hours based on cancellation charges.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 4),
            ),
          );

          // Refresh the UI to disable the cancel button
          (context as Element).markNeedsBuild();
        } else {
          // Show API error message
                                if(!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['Error']['ErrorMessage'] ??
                  'Cancellation failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Show HTTP error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server returned status code ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Hide loading indicator in case of error
      Navigator.pop(context);

      // Show exception error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cancellation failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
