import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BookSeat extends StatefulWidget {
  final String resultIndex;
  final String traceId;
  final String sourceCity;
  final String destinationCity;
  final String journeyDate;
  final String travelName;
  final String busType;
  final String arrivalTime;
  final String departureTime;
  final int? boardingPointIndex;
  final int? droppingPointIndex;
  final String selectedBoardingPoint;
  final String selectedDroppingPoint;
  final int? agentCommission;
  // final List<Map<String, dynamic>> selectedSeats; // List of seats
  final bool leadPassenger;
  final int passengerId;
  final String title;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneno;
  final String gender;
  final String? idType;
  final String? idNumber;
  final String address;
  final String age;
  final List<Map<String, dynamic>>
      selectedSeats; // Changed to accept list of seats
  final List<Map<String, dynamic>> passengers; // All passengers data
  final VoidCallback onNavigateToHome;

  const BookSeat(
      {super.key,
      required this.resultIndex,
      required this.traceId,
      required this.sourceCity,
      required this.destinationCity,
      required this.journeyDate,
      required this.travelName,
      required this.busType,
      required this.arrivalTime,
      required this.departureTime,
      required this.boardingPointIndex,
      required this.droppingPointIndex,
      required this.selectedBoardingPoint,
      required this.selectedDroppingPoint,
      required this.selectedSeats,
      required this.leadPassenger,
      required this.passengerId,
      required this.title,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneno,
      required this.gender,
      this.agentCommission,
      this.idType,
      this.idNumber,
      required this.address,
      required this.age,
      required this.passengers,
      required this.onNavigateToHome});

  @override
  _BookSeatState createState() => _BookSeatState();
}

class _BookSeatState extends State<BookSeat> {
  late Razorpay _razorpay;
  bool _isLoading = false;
  double _commission = 0; // Add commission variable

  // Fetch Commission
  double? commissionPercentage;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _loadCommission(); // Load commission when widget initializes
    // Fetch Commission
    fetchCommission();
    log("Book Seat Sereen");
    log("Full name: ${widget.firstName + widget.lastName}");
  }

  // Calculate price with commission
  double _calculatePriceWithCommission(dynamic basePrice) {
    final price = double.tryParse(basePrice.toString()) ?? 0;
    return (price * (1 + _commission / 100)).roundToDouble();
  }

  // Calculate total amount for all seats with commission
  double get totalAmount => widget.selectedSeats.fold(
        0.0,
        (double sum, seat) =>
            sum + _calculatePriceWithCommission(seat['Price']['OfferedPrice']),
      );

  Future<void> _loadCommission() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('settings')
          .doc('commission')
          .get();
      setState(() {
        _commission = doc.data()?['percentage']?.toDouble() ?? 0;
      });
    } catch (e) {
      log('Error loading commission: $e');
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Directly book seat, no need to capture
      await bookSeat(context, response.paymentId!);
    } catch (e) {
      _showDialog(
        title: "Error",
        message: "Booking failed: $e",
        isSuccess: false,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isLoading = false;
    });

    _showDialog(
      title: "Payment Failed",
      message: "Error: ${response.message ?? 'Unknown error'}",
      isSuccess: false,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showDialog(
      title: "External Wallet Selected",
      message: "Wallet: ${response.walletName}",
      isSuccess: true,
    );
  }

  void _openCheckout() async {
    setState(() {
      _isLoading = true;
    });
    log("Total with commission in paise: ${(totalWithCommission * 100).toInt()}");
    try {
      var options = {
        'key': 'rzp_live_jRrlgHE9Hldmk5',
        'amount': (totalWithCommission * 100).toInt(), // Total amount in paise
        'name': 'Namma Savaari',
        'description': 'Bus Ticket: ${widget.travelName}',
        'prefill': {
          'contact': widget.phoneno,
          'email': widget.email,
        },
        'theme': {'color': '#FF2291'},
      };

      _razorpay.open(options);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showDialog(
        title: "Error",
        message: "Failed to open payment gateway: $e",
        isSuccess: false,
      );
    }
  }

  void _showDialog(
      {required String title,
      required String message,
      required bool isSuccess}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> bookSeat(BuildContext context, String paymentId) async {
    const String apiUrl =
        "https://namma-savaari-api-backend.vercel.app/bus-api/book";

    // Construct passenger list from the passengers data
    List<Map<String, dynamic>> passengers = widget.passengers.map((passenger) {
      return {
        "LeadPassenger": passenger["LeadPassenger"],
        "PassengerId": passenger["PassengerId"],
        "Title": passenger["Title"],
        "FirstName": passenger["FirstName"],
        "LastName": passenger["LastName"],
        "Email": passenger["Email"],
        "Phoneno": passenger["Phoneno"],
        "Gender": passenger["Gender"],
        "IdType": passenger["IdType"],
        "IdNumber": passenger["IdNumber"],
        "Address": passenger["Address"],
        "Age": passenger["Age"],
        "Seat": passenger["Seat"],
      };
    }).toList();

    final Map<String, dynamic> requestBody = {
      "ClientId": "180187",
      "UserName": "Namma434",
      "Password": "Namma@4341",
      "ResultIndex": widget.resultIndex,
      "TraceId": widget.traceId,
      "BoardingPointId": widget.boardingPointIndex,
      "DroppingPointId": widget.droppingPointIndex,
      "RefID": paymentId,
      "Passenger": passengers,
    };

    const headers = {
      "Content-Type": "application/json",
      "Api-Token": "Namma@90434#34",
    };

    try {
// Sends a POST request to the booking API.
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      log("=== BOOKING API CALLED ===");
      log("REQUEST BODY: $requestBody");
      log("STATUS CODE: ${response.statusCode}");
      log("RAW RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        log("FULL BOOKING RESPONSE: $responseData");

        if (responseData['Error'] != null &&
            (responseData['Error']['ErrorCode'] != 0 ||
                responseData['Error']['ErrorMessage'].isNotEmpty)) {
          setState(() {
            _isLoading = false;
          });
          _showDialog(
            title: "Booking Failed",
            message: responseData['Error']['ErrorMessage'] ?? 'Unknown error',
            isSuccess: false,
          );
          return;
        }

        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          final resultData = responseData['Result'];
          log("RESUTL => $resultData");
          await FirebaseFirestore.instance.collection('all_bookings').add({
            'bookingStatus': resultData['BusBookingStatus'],
            'userId': currentUser.uid,
            'traceId': widget.traceId,
            'resultIndex': widget.resultIndex,
            'sourceCity': widget.sourceCity,
            'destinationCity': widget.destinationCity,
            'journey': '${widget.sourceCity} to ${widget.destinationCity}',
            'journeyDate': widget.journeyDate,
            'travelName': widget.travelName,
            'busType': widget.busType,
            'arrivalTime': widget.arrivalTime,
            'departureTime': widget.departureTime,
            'boardingPointIndex': widget.boardingPointIndex,
            'droppingPointIndex': widget.droppingPointIndex,
            'selectedBoardingPoint': widget.selectedBoardingPoint,
            'selectedDroppingPoint': widget.selectedDroppingPoint,
            'selectedSeats': widget.selectedSeats, // store all seat details
            'passengers': widget.passengers, // store all passenger data
            'totalAmount': totalAmount,
            'commissionAmount': commissionAmount,
            'totalWithCommission': totalWithCommission.round(),
            'paymentId': paymentId,
            'paymentStatus': 'completed',
            'createdAt': FieldValue.serverTimestamp(),
            'lastUpdated': FieldValue.serverTimestamp(),
            'amount': resultData['InvoiceAmount'],
            'ConvenienceFee': commissionAmount,
            'paymentAmount': totalWithCommission.round(),
            'ticketNumber': resultData['TicketNo'],
          });
          // await FirebaseFirestore.instance.collection('all_bookings').add({
          //   'userId': currentUser.uid,
          //   'ticketNumber': resultData['TicketNo'],
          //   'travelName': widget.travelName,
          //   'pnr': resultData['TravelOperatorPNR'],
          //   'bookingStatus': resultData['BusBookingStatus'],
          //   'operatorPNR': resultData['TravelOperatorPNR'],
          //   'amount': resultData['InvoiceAmount'],
          //   'journey': '${widget.sourceCity} to ${widget.destinationCity}',
          //   'travelDate': widget.journeyDate,
          //   'bookingTime': FieldValue.serverTimestamp(),
          //   'paymentAmount': totalWithCommission.round(),
          //   'ConvenienceFee': commissionAmount,
          // });
        }

        setState(() {
          _isLoading = false;
        });
                      if(!context.mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Booking Successful"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ticket No: ${responseData['Result']['TicketNo']}"),
                Text("PNR: ${responseData['Result']['TravelOperatorPNR']}"),
                Text("Status: ${responseData['Result']['BusBookingStatus']}"),
                const SizedBox(height: 10),
                const Text("Booking confirmation has been sent to your email."),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("ok"),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        _showDialog(
          title: "Booking Failed",
          message: "Server error: ${response.statusCode}",
          isSuccess: false,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showDialog(
        title: "Error",
        message: "An error occurred: $e",
        isSuccess: false,
      );
    }
  }

  // Fetch Commission
  Future<void> fetchCommission() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('settings')
          .doc('commission')
          .get();

      if (doc.exists) {
        setState(() {
          commissionPercentage = doc['percentage']?.toDouble() ?? 0;
        });
      }
    } catch (e) {
      log('Error fetching commission: $e');
    }
  }

// Total Amount icludiing Commission
  double get totalWithCommission {
    if (commissionPercentage != null) {
      return totalAmount + (totalAmount * (commissionPercentage! / 100));
    } else {
      return totalAmount;
    }
  }

  // Commission amount
  double get commissionAmount {
    if (commissionPercentage != null) {
      return totalAmount * (commissionPercentage! / 100);
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Confirm Booking",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent.shade700,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Journey Details Card (same as before)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Journey Details",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.sourceCity,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const Icon(Icons.arrow_forward),
                            Text(
                              widget.destinationCity,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text("${widget.travelName} (${widget.busType})"),
                        Text("Date: ${widget.journeyDate}"),
                        Text("Departure: ${widget.departureTime}"),
                        Text("Arrival: ${widget.arrivalTime}"),
                        const Divider(height: 24),
                        const Text(
                          "Boarding & Dropping",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text("Boarding: ${widget.selectedBoardingPoint}"),
                        Text("Dropping: ${widget.selectedDroppingPoint}"),
                        const SizedBox(height: 16),
                        // const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Amount:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹${totalAmount.toStringAsFixed(0)}", // Already uses the commission-included total
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Convenience Fee:"),
                            Text(
                              commissionPercentage != null
                                  ? "₹${commissionAmount.toStringAsFixed(0)}"
                                  : "Loading commission...",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Amount:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹${totalWithCommission.round()}",
                              style: const TextStyle(
                                fontSize: 18,
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
                // Passenger & Seat Details
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(top: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Passenger & Seat Details",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),

                        // Display all passengers with their details
                        ...widget.passengers.asMap().entries.map((entry) {
                          final index = entry.key;
                          final passenger = entry.value;
                          final seat = passenger['Seat'];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Passenger ${index + 1}: ${passenger['Title']} ${passenger['FirstName']} ${passenger['LastName']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text("Seat: ${seat['SeatName']}"),
                                Text(
                                    "Type: ${seat['SeatType'] == 1 ? 'Sleeper' : 'Seater'}"),
                                // Text("Fare: ₹${seat['Price']['OfferedPrice']}"),

                                Text(
                                    "Fare: ₹${totalWithCommission.toStringAsFixed(0)}"),
                                const SizedBox(height: 8),
                                Text(
                                    "Age: ${passenger['Age']} | Gender: ${passenger['Gender'] == "1" ? "Male" : "Female"}"),
                                Text("Phone: ${passenger['Phoneno']}"),
                                Text("Email: ${passenger['Email']}"),
                                if (passenger['LeadPassenger'] == true)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      "Lead Passenger",
                                      style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _openCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          "PROCEED TO PAY",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                ),
                const SizedBox(height: 16),
                Text(
                  "By proceeding, you agree to our Terms and Conditions",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                // Rest of the UI (boarding points, total amount, payment button)
                // ... existing code
              ],
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class CommissionProvider extends ChangeNotifier {
  double _commission = 0;

  double get commission => _commission;

  Future<void> loadCommission() async {
    final doc = await FirebaseFirestore.instance
        .collection('settings')
        .doc('commission')
        .get();
    _commission = doc.data()?['percentage']?.toDouble() ?? 0;
    notifyListeners();
  }
}
