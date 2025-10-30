// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import 'bording_and_droping_point_selection_page.dart';
//
// class SeatLayoutPage extends StatefulWidget {
//   final String resultIndex;
//   final String traceId;
//   final String sourceCity;
//   final String destinationCity;
//   final String journeyDate;
//   final String travelName;
//   final String busType;
//   final String arrivalTime;
//   final String departureTime;
//   final dynamic cancelationPolicies;
//
//   SeatLayoutPage({required this.resultIndex, required this.traceId, required this.sourceCity, required this.destinationCity, required this.journeyDate, required this.travelName, required this.busType, required this.arrivalTime, required this.departureTime, required this.cancelationPolicies});
//
//   @override
//   _SeatLayoutPageState createState() => _SeatLayoutPageState();
// }
//
// class _SeatLayoutPageState extends State<SeatLayoutPage> {
//   bool _isLoading = true;
//   String _errorMessage = "";
//   Map<String, dynamic>? _seatLayoutData;
//   List<Map<String, dynamic>> _selectedSeats = []; // To track selected seats
//   static const int maxSeatSelection = 6;
//   bool _isSeatSummaryVisible = false; // Flag to toggle the seat summary visibility
//   String? _temporaryPrice;
//   List<dynamic>? cancellationCharges;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchSeatLayout();
//     // Parse the cancelationPolicies data
//     if (widget.cancelationPolicies is String) {
//       try {
//         cancellationCharges = jsonDecode(widget.cancelationPolicies);
//       } catch (e) {
//         cancellationCharges = null;
//       }
//     } else if (widget.cancelationPolicies is List) {
//       cancellationCharges = widget.cancelationPolicies;
//     }
//   }
//
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _fetchSeatLayout();
//   // }
//
//   Future<void> _fetchSeatLayout() async {
//     // final String apiUrl = "https://bus.srdvapi.com/v5/rest/GetSeatLayOut";
//     final String apiUrl = "http://3.7.121.234/bus-api/GetSeatLayOut";
//
//     final Map<String, dynamic> requestBody = {
//       "ClientId": "180187",
//       "UserName": "Namma434",
//       "Password": "Namma@4341",
//       "TraceId": widget.traceId,
//       "ResultIndex": widget.resultIndex,
//     };
//     final headers = {
//       "Content-Type": "application/json",
//       "Api-Token": "Namma@90434#34",
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: headers,
//         body: jsonEncode(requestBody),
//       );
//       if (response.statusCode == 200) {
//         final responseBody = jsonDecode(response.body);
//
//         setState(() {
//           _seatLayoutData = responseBody;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage = "Failed to fetch seat layout: ${response.body}";
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = "Error: ${e.toString()}";
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _toggleSeatSelection(Map<String, dynamic> seat) {
//     if (seat['SeatStatus'] == false) {
//       // Optionally, show a message that the seat is unavailable
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("This seat is unavailable.")),
//       );
//       return;
//     }
//
//     setState(() {
//       if (_selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])) {
//         // Deselect the seat and remove temporary price
//         _selectedSeats.removeWhere((s) => s['SeatName'] == seat['SeatName']);
//       } else {
//         // Select the seat and add temporary price
//         if (_selectedSeats.length < maxSeatSelection) {
//           _selectedSeats.add({
//             ...seat,
//             'OfferedPriceRoundedOff': seat['Price']?['OfferedPriceRoundedOff'] ??
//                 0,
//             'tempPrice': "₹${seat['Price']?['OfferedPriceRoundedOff'] ?? 0}",
//           });
//         } else {
//           _showMaxSelectionDialog();
//         }
//       }
//
//       _isSeatSummaryVisible = _selectedSeats.isNotEmpty;
//
//       // Set the temporary price for this seat, which will disappear after 3 seconds
//       Future.delayed(Duration(seconds: 3), () {
//         setState(() {
//           // Remove the temporary price from the seat after 3 seconds
//           _selectedSeats = _selectedSeats.map((s) {
//             if (s['SeatName'] == seat['SeatName']) {
//               s.remove('tempPrice');
//             }
//             return s;
//           }).toList();
//         });
//       });
//     });
//   }
//
//   void _showMaxSelectionDialog() {
//     showDialog(
//       context: context,
//       builder: (context) =>
//           AlertDialog(
//             title: Icon(Icons.airline_seat_recline_extra, size: 50,
//               color: Colors.indigo[300],),
//             content: Text(
//               "You can select a maximum of $maxSeatSelection seats.",
//               style: TextStyle(color: Colors.black,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold),),
//             actions: [
//               Center(
//                 child: Container(
//                   height: 50,
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () => Navigator.pop(context), // Close the dialog
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.redAccent.shade700,
//                       // Set the button color
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(
//                             8), // Optional: Rounded corners
//                       ),
//                     ),
//                     child: Text(
//                       "Okay",
//                       style: TextStyle(color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight
//                               .bold), // Optional: Customize text color
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//     );
//   }
//
//   void _showSeatSelectionDialog() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(height: 20,),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           "Price Breakup",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     GestureDetector(
//                       onTap: () => Navigator.of(context).pop(),
//                       child: Icon(
//                         Icons.close,
//                         size: 24.0,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.0),
//                 ..._selectedSeats.map((seat) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           seat['SeatName'],
//                           style: TextStyle(
//                             fontSize: 16,
//                           ),
//                         ),
//                         Text(
//                           "₹${seat['OfferedPriceRoundedOff']}",
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         backgroundColor: Colors.redAccent.shade700,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Select Seats",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(height: 4), // Add some space between the two lines
//             Text(
//               "${widget.sourceCity} -> ${widget.destinationCity}",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.normal,
//                 color: Colors
//                     .white70, // Slightly lighter white for the subtitle
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _errorMessage.isNotEmpty
//           ? Center(child: Text(_errorMessage))
//           : _seatLayoutData != null
//           ? Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             if (_temporaryPrice != null)
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 10.0),
//                 alignment: Alignment.center,
//                 color: Colors.redAccent.shade700,
//                 child: Text(
//                   _temporaryPrice!,
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: _buildSeatRows(),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10), // Spacing before the journey date container
//
//           ],
//         ),
//       )
//           : Center(
//         child: Text(
//           "No data available.",
//           style: TextStyle(fontSize: 16, color: Colors.red),
//         ),
//       ),
//       bottomNavigationBar: _isSeatSummaryVisible
//           ? GestureDetector(
//         onTap: _showSeatSelectionDialog,
//         child: Container(
//           color: Colors.white,
//           padding: EdgeInsets.all(16.0),
//           height: 150,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Seats: ${_selectedSeats.length}",
//                     style: TextStyle(fontSize: 20,color: Colors.black),
//                   ),
//                   Text(
//                     "Total: ₹${_selectedSeats.fold(0.0, (sum, seat) => sum +
//                         (seat['OfferedPriceRoundedOff'] ?? 0))
//                         .toStringAsFixed(2)}",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.black),
//                   ),
//                 ],
//               ),
//               Spacer(),
//
//               Center(
//                 child: Container(
//                   height: 50,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.redAccent.shade700
//                     ),
//                     onPressed: () {
//                       print("$_selectedSeats");
//
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BoardingDroppingPage(
//                             resultIndex: widget.resultIndex,
//                             traceId: widget.traceId,
//                             sourceCity: widget.sourceCity,
//                             destinationCity: widget.destinationCity,
//                             journeyDate: widget.journeyDate,
//                             travelName: widget.travelName,
//                             busType: widget.busType,
//                             arrivalTime: widget.arrivalTime,
//                             departureTime: widget.departureTime,
//                             selectedSeats: _selectedSeats,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       "Boarding & Dropping Point Selection",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )
//           : null,
//     );
//   }
//
// // with Space
//   List<Widget> _buildSeatRows() {
//     final seatDetails = _seatLayoutData?['Result']?['SeatLayout']?['SeatLayoutDetails']?['Layout']?['seatDetails'];
//     if (seatDetails == null) {
//       return [Text("No seat details available")];
//     }
//
//     // Separate upper and lower seats
//     List<List<dynamic>> lowerSeatRows = [];
//     List<List<dynamic>> upperSeatRows = [];
//
//     for (var row in seatDetails) {
//       List<dynamic> lowerRow = [];
//       List<dynamic> upperRow = [];
//       for (var seat in row) {
//         if (seat['IsUpper'] == true) {
//           upperRow.add(seat);
//         } else {
//           lowerRow.add(seat);
//         }
//       }
//       if (lowerRow.isNotEmpty) lowerSeatRows.add(lowerRow);
//       if (upperRow.isNotEmpty) upperSeatRows.add(upperRow);
//     }
//
//     return [
//       Center(
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (lowerSeatRows.isNotEmpty) ...[
//                 _buildLowerDeck(lowerSeatRows),
//                 SizedBox(width: 20),
//               ],
//               if (upperSeatRows.isNotEmpty) ...[
//                 _buildUpperDeck(upperSeatRows),
//               ],
//             ],
//           ),
//         ),
//       ),
//       SizedBox(height: 20), // Space below the decks
//       Center(
//         child: Text(
//           "About Seat Types",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
//         ),
//       ),
//       SizedBox(height: 20), // Space below the text
//       Center(
//         child: Container(
//           height: 350, // Set container height to 350
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//
//             ],
//           ),
//           child: Column(
//             children: [
//               // First row with "Type", "Seater", "Sleeper"
//               Container(
//                 height: 50, // Height for the first row
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           "Type",
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
//                         ),
//                       ),
//                     ),
//                     VerticalDivider(color: Colors.grey, thickness: 1), // Vertical divider
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           "Seater",
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
//                         ),
//                       ),
//                     ),
//                     VerticalDivider(color: Colors.grey, thickness: 1), // Vertical divider
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           "Sleeper",
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(color: Colors.grey, thickness: 1), // Horizontal divider below the first row
//
//               // Second row with "Available" and custom containers
//               Container(
//                 height: 50, // Height for the second row
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           "Available",
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
//                         ),
//                       ),
//                     ),
//                     VerticalDivider(color: Colors.grey, thickness: 1), // Vertical divider
//                     Expanded(
//                       child: Center(
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           child: Stack(
//                             children: [
//                               Positioned(
//                                 top: 5,
//                                 bottom: 5,
//                                 left: 5,
//                                 right: 5,
//                                 child: SizedBox(
//                                   child: DecoratedBox(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: Colors.black, // Border color for available seats
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(5),
//                                       color: Colors.white, // Background color
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 29,
//                                 bottom: 5,
//                                 left: 5,
//                                 right: 5,
//                                 child: SizedBox(
//                                   child: DecoratedBox(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: Colors.black, // Border color for available seats
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(5),
//                                       color: Colors.white, // Background color
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 15,
//                                 bottom: 5,
//                                 left: 4,
//                                 right: 30,
//                                 child: SizedBox(
//                                   child: DecoratedBox(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: Colors.black, // Border color for available seats
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(5),
//                                       color: Colors.white, // Background color
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 15,
//                                 bottom: 5,
//                                 left: 30,
//                                 right: 4,
//                                 child: SizedBox(
//                                   child: DecoratedBox(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: Colors.black, // Border color for available seats
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(5),
//                                       color: Colors.white, // Background color
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     VerticalDivider(color: Colors.grey, thickness: 1), // Vertical divider
//                     Expanded(
//                       child: Center(
//                         child: Container(
//                           width: 40,
//                           height: 102,
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.black, // Border color for available seats
//                               width: 1,
//                             ),
//                             borderRadius: BorderRadius.circular(8.0),
//                             color: Colors.white, // Background color
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(color: Colors.grey, thickness: 1), // Horizontal divider below the second row
//
//               // Rows 3 to 5 with specific labels and custom containers
//               Expanded(
//                 child: Column(
//                   children: [
//                     for (int i = 0; i < 3; i++) ...[
//                       Container(
//                         height: 50, // Fixed height for each row
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Center(
//                                 child: Text(
//                                   ["Already Booked", "Only for Female", "Only for Male"][i], // Dynamic text for each row
//                                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
//                                 ),
//                               ),
//                             ),
//                             VerticalDivider(color: Colors.grey, thickness: 1), // Vertical divider
//                             Expanded(
//                               child: Center(
//                                 child: Container(
//                                   width: 40,
//                                   height: 40,
//                                   child: Stack(
//                                     children: [
//                                       Positioned(
//                                         top: 5,
//                                         bottom: 5,
//                                         left: 5,
//                                         right: 5,
//                                         child: SizedBox(
//                                           child: DecoratedBox(
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                 color: i == 0
//                                                     ? Colors.grey.shade300 // Already Booked
//                                                     : i == 1
//                                                     ? Colors.pink.shade400 // Only for Female
//                                                     : Color(0xFF4A90E2), // Only for Male
//                                                 width: 2, // Border width
//                                               ),
//                                               borderRadius: BorderRadius.circular(5),
//                                               color: Colors.white, // Background color
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         top: 29,
//                                         bottom: 5,
//                                         left: 5,
//                                         right: 5,
//                                         child: SizedBox(
//                                           child: DecoratedBox(
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                 color: i == 0
//                                                     ? Colors.grey.shade300 // Already Booked
//                                                     : i == 1
//                                                     ? Colors.pink.shade400 // Only for Female
//                                                     : Color(0xFF4A90E2), // Only for Male
//                                                 width: 2, // Border width
//                                               ),
//                                               borderRadius: BorderRadius.circular(5),
//                                               color: Colors.white, // Background color
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         top: 15,
//                                         bottom: 5,
//                                         left: 4,
//                                         right: 30,
//                                         child: SizedBox(
//                                           child: DecoratedBox(
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                 color: i == 0
//                                                     ? Colors.grey.shade300 // Already Booked
//                                                     : i == 1
//                                                     ? Colors.pink.shade400 // Only for Female
//                                                     : Color(0xFF4A90E2), // Only for Male
//                                                 width: 2, // Border width
//                                               ),
//                                               borderRadius: BorderRadius.circular(5),
//                                               color: Colors.white, // Background color
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         top: 15,
//                                         bottom: 5,
//                                         left: 30,
//                                         right: 4,
//                                         child: SizedBox(
//                                           child: DecoratedBox(
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                 color: i == 0
//                                                     ? Colors.grey.shade300 // Already Booked
//                                                     : i == 1
//                                                     ? Colors.pink.shade400 // Only for Female
//                                                     : Color(0xFF4A90E2), // Only for Male
//                                                 width: 2, // Border width
//                                               ),
//                                               borderRadius: BorderRadius.circular(5),
//                                               color: Colors.white, // Background color
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             VerticalDivider(color: Colors.grey, thickness: 1), // Vertical divider
//                             Expanded(
//                               child: Center(
//                                 child: Container(
//                                   width: 40,
//                                   height: 102,
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: i == 0
//                                           ? Colors.grey.shade300 // Already Booked
//                                           : i == 1
//                                           ? Colors.pink.shade400 // Only for Female
//                                           : Color(0xFF4A90E2), // Only for Male
//                                       width: 2, // Border width
//                                     ),
//                                     borderRadius: BorderRadius.circular(8.0),
//                                     color: Colors.white, // Background color
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       if (i < 2) Divider(color: Colors.grey, thickness: 1), // Horizontal divider except for the last row
//                     ],
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       SizedBox(height: 30,),
//       Center(
//         child: Text(
//           "Cancellation Policies:",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       SizedBox(height: 10),
//       Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Display Cancellation Charges
//               if (cancellationCharges != null)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Cancellation Charges:",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     ...cancellationCharges!.map((charge) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           RichText(
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: "Cancellation Charge: ", // Key
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: "${charge['CancellationCharge']}", // Value
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.redAccent.shade700, // Different color for value
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           RichText(
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: "Cancellation Charge Type: ", // Key
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: "${charge['CancellationChargeType']}", // Value
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.normal,
//                                     color: Colors.grey, // Different color for value
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           RichText(
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: "Policy: ", // Key
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: "${charge['PolicyString']}", // Value
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.normal,
//                                     color: Colors.grey, // Different color for value
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           RichText(
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: "From: ", // Key
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: "${charge['FromDate']}", // Value
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.normal,
//                                     color: Colors.grey, // Different color for value
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           RichText(
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: "Time Before Dept: ", // Key
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: "${charge['TimeBeforeDept']}", // Value
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.normal,
//                                     color: Colors.grey, // Different color for value
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           RichText(
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: "To: ", // Key
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: "${charge['ToDate']}", // Value
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.normal,
//                                     color: Colors.grey, // Different color for value
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                         ],
//                       );
//                     }).toList(),
//                   ],
//                 ),
//
//               // Display the Remaining Policies (if any)
//               SizedBox(height: 20),
//               Text(
//                 "Other Policies:",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 cancellationCharges != null
//                     ? "Refer to the cancellation charges above."
//                     : "No cancellation policies available.",
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//
//
//     ];
//   }
//
//
//
//
//   Widget _buildLowerDeck(List<List<dynamic>> lowerSeatRows) {
//     return _buildSeatDeck("Lower Deck", lowerSeatRows);
//   }
//
//   Widget _buildUpperDeck(List<List<dynamic>> upperSeatRows) {
//     return _buildSeatDeck("Upper Deck", upperSeatRows);
//   }
//   Widget _buildSeatDeck(String title, List<List<dynamic>> seatRows) {
//     // Reverse the order of the seat rows
//     List<List<dynamic>> reversedRows = seatRows.reversed.toList();
//
//     // Check if all seats in the deck are of SeatType == 2
//     bool isAllSeatType2 = true;
//     for (var row in seatRows) {
//       for (var seat in row) {
//         if (seat['SeatType'] != 2) {
//           isAllSeatType2 = false;
//           break;
//         }
//       }
//       if (!isAllSeatType2) break;
//     }
//
//     // Check if there are both SeatType == 1 and SeatType == 2 in the same column
//     bool hasMixedSeatTypes = false;
//     for (var row in seatRows) {
//       bool hasSeatType1 = false;
//       bool hasSeatType2 = false;
//       for (var seat in row) {
//         if (seat['SeatType'] == 1) hasSeatType1 = true;
//         if (seat['SeatType'] == 2) hasSeatType2 = true;
//         if (hasSeatType1 && hasSeatType2) {
//           hasMixedSeatTypes = true;
//           break;
//         }
//       }
//       if (hasMixedSeatTypes) break;
//     }
//
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         // borderRadius: BorderRadius.circular(12),
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(12), // Top border radius
//           bottom: Radius.circular(12),
//         ),
//         boxShadow: [
//         ],
//       ),
//
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               for (int i = 0; i < reversedRows.length; i++) ...[
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: reversedRows[i].map<Widget>((seat) {
//                     bool isSelectable = seat['SeatStatus'] ?? true;
//                     bool isMaleSeat = seat['IsMalesSeat'] ?? false;
//                     bool isLadiesSeat = seat['IsLadiesSeat'] ?? false;
//                     double seatPrice = seat['Price']?['OfferedPriceRoundedOff']?.toDouble() ?? 0.0;
//
//                     Color borderColor = isMaleSeat
//                         ? Color(0xFF4A90E2) // Border color for male seats
//                         : isLadiesSeat
//                         ? Colors.pink.shade400 // Border color for ladies seats
//                         : Colors.black; // Default border color
//
//                     Color seatColor = !isSelectable ? Colors.grey.shade300 : Colors.white; // Default seat color
//
//                     Widget seatWidget;
//
//                     // before space
//                     if (seat['SeatType'] == 1) {
//                       // Custom stacked layout for SeatType 1 (medium size)
//                       seatWidget = Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0), // Space between seats (top, bottom, left, right)
//                         child: Container(
//                           width: 30, // Reduced width for medium size
//                           height: 30, // Reduced height for medium size
//                           child: Stack(
//                             children: [
//                               Positioned(
//                                 top: 3, // Adjusted top position
//                                 bottom: 3, // Adjusted bottom position
//                                 left: 3, // Adjusted left position
//                                 right: 3, // Adjusted right position
//                                 child: SizedBox(
//                                   child: DecoratedBox(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: borderColor,
//                                         width: 0.8,
//                                       ),
//                                       borderRadius: BorderRadius.circular(5),
//                                       color: _selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])
//                                           ? Colors.green
//                                           : seatColor,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 20, // Adjusted top position
//                                 bottom: 3, // Adjusted bottom position
//                                 left: 3, // Adjusted left position
//                                 right: 3, // Adjusted right position
//                                 child: SizedBox(
//                                   child: DecoratedBox(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: borderColor,
//                                         width: 0.8,
//                                       ),
//                                       borderRadius: BorderRadius.circular(5),
//                                       color: _selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])
//                                           ? Colors.green
//                                           : seatColor,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 10, // Adjusted top position
//                                 bottom: 3, // Adjusted bottom position
//                                 left: 2, // Adjusted left position
//                                 right: 20, // Adjusted right position
//                                 child: SizedBox(
//                                   child: DecoratedBox(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: borderColor,
//                                         width: 0.8,
//                                       ),
//                                       borderRadius: BorderRadius.circular(5),
//                                       color: _selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])
//                                           ? Colors.green
//                                           : seatColor,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 10, // Adjusted top position
//                                 bottom: 3, // Adjusted bottom position
//                                 left: 20, // Adjusted left position
//                                 right: 2, // Adjusted right position
//                                 child: SizedBox(
//                                   child: DecoratedBox(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: borderColor,
//                                         width: 0.8,
//                                       ),
//                                       borderRadius: BorderRadius.circular(5),
//                                       color: _selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])
//                                           ? Colors.green
//                                           : seatColor,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     } else if (seat['SeatType'] == 2) {
//                       // Custom layout for SeatType 2
//                       seatWidget = Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0), // Space between seats (top, bottom, left, right)
//                         child: Container(
//                           width: 30,
//                           height: 82,
//                           decoration: BoxDecoration(
//                             color: _selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])
//                                 ? Colors.green
//                                 : seatColor,
//                             border: Border.all(
//                               color: borderColor,
//                               width: 0.8,
//                             ),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: Center(
//                             child: Text(
//                               seat['SeatName'],
//                               style: TextStyle(color: Colors.black,fontSize: 8),
//                             ),
//                           ),
//                         ),
//                       );
//                     } else {
//                       // Default seat layout
//                       seatWidget = Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: _selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])
//                               ? Colors.green
//                               : seatColor,
//                           border: Border.all(
//                             color: borderColor,
//                             width: 1,
//                           ),
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         child: Center(
//                           child: Text(
//                             seat['SeatName'],
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ),
//                       );
//                     }
//
//                     return GestureDetector(
//                       onTap: isSelectable ? () => _toggleSeatSelection(seat) : null,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4.0), // Space between seats
//                         child: Column(
//                           children: [
//                             seatWidget,
//                             Text(
//                               // Display "Sold" if the seat is not selectable, otherwise display the price without decimal places
//                               !isSelectable ? "Sold" : "₹${seatPrice.toStringAsFixed(0)}",
//                               style: TextStyle(
//                                 color: !isSelectable ? Colors.green : Colors.black,
//                                 fontSize: 10,
//                                 fontWeight: !isSelectable ? FontWeight.bold : FontWeight.normal,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//                 // Add a SizedBox(width: 50) after the first column if all seats are of SeatType == 2 or if there are mixed seat types
//                 if ((isAllSeatType2 || hasMixedSeatTypes) && i == 0) SizedBox(width: 50),
//               ],
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// String _formatDate(String dateString) {
//   try {
//     DateTime date = DateTime.parse(dateString);
//     return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
//   } catch (e) {
//     return dateString; // Return the original string if parsing fails
//   }
// }

// mussy

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'bording_and_droping_point_selection_page.dart';

class SeatLayoutPage extends StatefulWidget {
  final String resultIndex;
  final String traceId;
  final String sourceCity;
  final String destinationCity;
  final String journeyDate;
  final String travelName;
  final String busType;
  final String arrivalTime;
  final String departureTime;
  final dynamic cancelationPolicies;

  const SeatLayoutPage(
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
      required this.cancelationPolicies});

  @override
  _SeatLayoutPageState createState() => _SeatLayoutPageState();
}

class _SeatLayoutPageState extends State<SeatLayoutPage> {
  bool _isLoading = true;
  String _errorMessage = "";
  Map<String, dynamic>? _seatLayoutData;
  List<Map<String, dynamic>> _selectedSeats = []; // To track selected seats
  static const int maxSeatSelection = 6;
  bool _isSeatSummaryVisible =
      false; // Flag to toggle the seat summary visibility
  String? _temporaryPrice;
  List<dynamic>? cancellationCharges;
  double _commission = 0;

  @override
  void initState() {
    super.initState();
    _fetchSeatLayout();
    // Parse the cancelationPolicies data
    if (widget.cancelationPolicies is String) {
      try {
        cancellationCharges = jsonDecode(widget.cancelationPolicies);
      } catch (e) {
        cancellationCharges = null;
      }
    } else if (widget.cancelationPolicies is List) {
      cancellationCharges = widget.cancelationPolicies;
    }
    _loadCommission();
  }

  Future<void> _loadCommission() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('settings')
          .doc('commission')
          .get();
      setState(() {
        _commission = doc.data()?['percentage']?.toDouble() ?? 0;
      });
      log("Commission: $_commission");
    } catch (e) {
      log('Error loading commission: $e');
    }
  }

  // Add this helper method
  double _calculatePriceWithCommission(dynamic basePrice) {
    final price = double.tryParse(basePrice.toString()) ?? 0;
    return price * (1 + _commission / 100);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchSeatLayout();
  // }

  Future<void> _fetchSeatLayout() async {
    // final String apiUrl = "https://bus.srdvapi.com/v5/rest/GetSeatLayOut";
    const String apiUrl =
        "https://namma-savaari-api-backend.vercel.app/get-seat-layout";

    final Map<String, dynamic> requestBody = {
      "ClientId": "180187",
      "UserName": "Namma434",
      "Password": "Namma@4341",
      "TraceId": widget.traceId,
      "ResultIndex": widget.resultIndex,
    };
    final headers = {
      "Content-Type": "application/json",
      "Api-Token": "Namma@90434#34",
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        setState(() {
          _seatLayoutData = responseBody;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Failed to fetch seat layout: ${response.body}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  // void _toggleSeatSelection(Map<String, dynamic> seat) {
  //   if (seat['SeatStatus'] == false) {
  //     // Optionally, show a message that the seat is unavailable
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("This seat is unavailable.")),
  //     );
  //     return;
  //   }
  //
  //   setState(() {
  //     if (_selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])) {
  //       // Deselect the seat and remove temporary price
  //       _selectedSeats.removeWhere((s) => s['SeatName'] == seat['SeatName']);
  //     } else {
  //       // Select the seat and add temporary price
  //       if (_selectedSeats.length < maxSeatSelection) {
  //         _selectedSeats.add({
  //           ...seat,
  //           'OfferedPriceRoundedOff': seat['Price']?['OfferedPriceRoundedOff'] ??
  //               0,
  //           'tempPrice': "₹${seat['Price']?['OfferedPriceRoundedOff'] ?? 0}",
  //         });
  //       } else {
  //         _showMaxSelectionDialog();
  //       }
  //     }
  //
  //     _isSeatSummaryVisible = _selectedSeats.isNotEmpty;
  //
  //     // Set the temporary price for this seat, which will disappear after 3 seconds
  //     Future.delayed(Duration(seconds: 3), () {
  //       setState(() {
  //         // Remove the temporary price from the seat after 3 seconds
  //         _selectedSeats = _selectedSeats.map((s) {
  //           if (s['SeatName'] == seat['SeatName']) {
  //             s.remove('tempPrice');
  //           }
  //           return s;
  //         }).toList();
  //       });
  //     });
  //   });
  // }

  void _toggleSeatSelection(Map<String, dynamic> seat) {
    if (seat['SeatStatus'] == false) {
      // Optionally, show a message that the seat is unavailable
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("This seat is unavailable.")),
      );
      return;
    }
    setState(() {
      if (_selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])) {
        _selectedSeats.removeWhere((s) => s['SeatName'] == seat['SeatName']);
      } else {
        if (_selectedSeats.length < maxSeatSelection) {
          _selectedSeats.add({
            ...seat,
            'OfferedPriceRoundedOff': _calculatePriceWithCommission(
                seat['Price']?['OfferedPriceRoundedOff'] ?? 0),
            'tempPrice':
                "₹${_calculatePriceWithCommission(seat['Price']?['OfferedPriceRoundedOff'] ?? 0).toStringAsFixed(2)}",
          });
        } else {
          _showMaxSelectionDialog();
        }
      }

      _isSeatSummaryVisible = _selectedSeats.isNotEmpty;

      // Set the temporary price for this seat, which will disappear after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          // Remove the temporary price from the seat after 3 seconds
          _selectedSeats = _selectedSeats.map((s) {
            if (s['SeatName'] == seat['SeatName']) {
              s.remove('tempPrice');
            }
            return s;
          }).toList();
        });
      });
    });
  }

  void _showMaxSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Icon(
          Icons.airline_seat_recline_extra,
          size: 50,
          color: Colors.indigo[300],
        ),
        content: const Text(
          "You can select a maximum of $maxSeatSelection seats.",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          Center(
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context), // Close the dialog
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.shade700,
                  // Set the button color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Optional: Rounded corners
                  ),
                ),
                child: const Text(
                  "Okay",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold), // Optional: Customize text color
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showSeatSelectionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Price Breakup",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.close,
                        size: 24.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ..._selectedSeats.map((seat) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          seat['SeatName'],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        // Text(
                        //   "₹${seat['OfferedPriceRoundedOff']}",
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     color: Colors.black,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),

                        Text(
                          "₹${seat['OfferedPriceRoundedOff']}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade700,
        iconTheme: IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Seats",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4), // Add some space between the two lines
            Text(
              "${widget.sourceCity} -> ${widget.destinationCity}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white, // Slightly lighter white for the subtitle
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _seatLayoutData != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (_temporaryPrice != null)
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              alignment: Alignment.center,
                              color: Colors.redAccent.shade700,
                              child: Text(
                                _temporaryPrice!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: _buildSeatRows(),
                              ),
                            ),
                          ),
                          const SizedBox(
                              height:
                                  10), // Spacing before the journey date container
                        ],
                      ),
                    )
                  : const Center(
                      child: Text(
                        "No data available.",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ),
      bottomNavigationBar: _isSeatSummaryVisible
          ? GestureDetector(
              onTap: _showSeatSelectionDialog,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Seats: ${_selectedSeats.length}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                        ),
                        // Text(
                        //   "Total: ₹${_selectedSeats.fold(0.0, (sum, seat) => sum +
                        //       (seat['OfferedPriceRoundedOff'] ?? 0))
                        //       .toStringAsFixed(2)}",
                        //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.black),
                        // ),
                        Text(
                          "Total: ₹${_selectedSeats.fold(0.0, (double sum, seat) => sum + (seat['OfferedPriceRoundedOff'] ?? 0)).toStringAsFixed(0)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Center(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.shade700),
                          onPressed: () {
                            log("$_selectedSeats");

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BoardingDroppingPage(
                                  resultIndex: widget.resultIndex,
                                  traceId: widget.traceId,
                                  sourceCity: widget.sourceCity,
                                  destinationCity: widget.destinationCity,
                                  journeyDate: widget.journeyDate,
                                  travelName: widget.travelName,
                                  busType: widget.busType,
                                  arrivalTime: widget.arrivalTime,
                                  departureTime: widget.departureTime,
                                  selectedSeats: _selectedSeats,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Boarding & Dropping Point Selection",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

// with Space
  List<Widget> _buildSeatRows() {
    final seatDetails = _seatLayoutData?['Result']?['SeatLayout']
        ?['SeatLayoutDetails']?['Layout']?['seatDetails'];
    if (seatDetails == null) {
      return [const Text("No seat details available")];
    }

    // Separate upper and lower seats
    List<List<dynamic>> lowerSeatRows = [];
    List<List<dynamic>> upperSeatRows = [];

    for (var row in seatDetails) {
      List<dynamic> lowerRow = [];
      List<dynamic> upperRow = [];
      for (var seat in row) {
        if (seat['IsUpper'] == true) {
          upperRow.add(seat);
        } else {
          lowerRow.add(seat);
        }
      }
      if (lowerRow.isNotEmpty) lowerSeatRows.add(lowerRow);
      if (upperRow.isNotEmpty) upperSeatRows.add(upperRow);
    }

    return [
      Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (lowerSeatRows.isNotEmpty) ...[
                _buildLowerDeck(lowerSeatRows),
                const SizedBox(width: 20),
              ],
              if (upperSeatRows.isNotEmpty) ...[
                _buildUpperDeck(upperSeatRows),
              ],
            ],
          ),
        ),
      ),
      const SizedBox(height: 20), // Space below the decks
      const Center(
        child: Text(
          "About Seat Types",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      const SizedBox(height: 20), // Space below the text
      Center(
        child: Container(
          height: 350, // Set container height to 350
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [],
          ),
          child: Column(
            children: [
              // First row with "Type", "Seater", "Sleeper"
              const SizedBox(
                height: 50, // Height for the first row
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Type",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    VerticalDivider(
                        color: Colors.grey, thickness: 1), // Vertical divider
                    Expanded(
                      child: Center(
                        child: Text(
                          "Seater",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    VerticalDivider(
                        color: Colors.grey, thickness: 1), // Vertical divider
                    Expanded(
                      child: Center(
                        child: Text(
                          "Sleeper",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                  color: Colors.grey,
                  thickness: 1), // Horizontal divider below the first row

              // Second row with "Available" and custom containers
              SizedBox(
                height: 50, // Height for the second row
                child: Row(
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Available",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                        color: Colors.grey, thickness: 1), // Vertical divider
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 5,
                                bottom: 5,
                                left: 5,
                                right: 5,
                                child: SizedBox(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors
                                            .black, // Border color for available seats
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white, // Background color
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 29,
                                bottom: 5,
                                left: 5,
                                right: 5,
                                child: SizedBox(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors
                                            .black, // Border color for available seats
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white, // Background color
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 15,
                                bottom: 5,
                                left: 4,
                                right: 30,
                                child: SizedBox(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors
                                            .black, // Border color for available seats
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white, // Background color
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 15,
                                bottom: 5,
                                left: 30,
                                right: 4,
                                child: SizedBox(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors
                                            .black, // Border color for available seats
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white, // Background color
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                        color: Colors.grey, thickness: 1), // Vertical divider
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 102,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors
                                  .black, // Border color for available seats
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white, // Background color
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                  color: Colors.grey,
                  thickness: 1), // Horizontal divider below the second row

              // Rows 3 to 5 with specific labels and custom containers
              Expanded(
                child: Column(
                  children: [
                    for (int i = 0; i < 3; i++) ...[
                      SizedBox(
                        height: 50, // Fixed height for each row
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  [
                                    "Already Booked",
                                    "Only for Female",
                                    "Only for Male"
                                  ][i], // Dynamic text for each row
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            const VerticalDivider(
                                color: Colors.grey,
                                thickness: 1), // Vertical divider
                            Expanded(
                              child: Center(
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 5,
                                        bottom: 5,
                                        left: 5,
                                        right: 5,
                                        child: SizedBox(
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: i == 0
                                                    ? Colors.grey
                                                        .shade300 // Already Booked
                                                    : i == 1
                                                        ? Colors.pink
                                                            .shade400 // Only for Female
                                                        : const Color(
                                                            0xFF4A90E2), // Only for Male
                                                width: 2, // Border width
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors
                                                  .white, // Background color
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 29,
                                        bottom: 5,
                                        left: 5,
                                        right: 5,
                                        child: SizedBox(
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: i == 0
                                                    ? Colors.grey
                                                        .shade300 // Already Booked
                                                    : i == 1
                                                        ? Colors.pink
                                                            .shade400 // Only for Female
                                                        : const Color(
                                                            0xFF4A90E2), // Only for Male
                                                width: 2, // Border width
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors
                                                  .white, // Background color
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 15,
                                        bottom: 5,
                                        left: 4,
                                        right: 30,
                                        child: SizedBox(
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: i == 0
                                                    ? Colors.grey
                                                        .shade300 // Already Booked
                                                    : i == 1
                                                        ? Colors.pink
                                                            .shade400 // Only for Female
                                                        : const Color(
                                                            0xFF4A90E2), // Only for Male
                                                width: 2, // Border width
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors
                                                  .white, // Background color
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 15,
                                        bottom: 5,
                                        left: 30,
                                        right: 4,
                                        child: SizedBox(
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: i == 0
                                                    ? Colors.grey
                                                        .shade300 // Already Booked
                                                    : i == 1
                                                        ? Colors.pink
                                                            .shade400 // Only for Female
                                                        : const Color(
                                                            0xFF4A90E2), // Only for Male
                                                width: 2, // Border width
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors
                                                  .white, // Background color
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const VerticalDivider(
                                color: Colors.grey,
                                thickness: 1), // Vertical divider
                            Expanded(
                              child: Center(
                                child: Container(
                                  width: 40,
                                  height: 102,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: i == 0
                                          ? Colors
                                              .grey.shade300 // Already Booked
                                          : i == 1
                                              ? Colors.pink
                                                  .shade400 // Only for Female
                                              : const Color(
                                                  0xFF4A90E2), // Only for Male
                                      width: 2, // Border width
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white, // Background color
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (i < 2)
                        const Divider(
                            color: Colors.grey,
                            thickness:
                                1), // Horizontal divider except for the last row
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      const Center(
        child: Text(
          "Cancellation Policies:",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      const SizedBox(height: 10),
      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Cancellation Charges
              if (cancellationCharges != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cancellation Charges:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...cancellationCharges!.map((charge) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Cancellation Charge: ", // Key
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "${charge['CancellationCharge']}", // Value
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent
                                        .shade700, // Different color for value
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Cancellation Charge Type: ", // Key
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "${charge['CancellationChargeType']}", // Value
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors
                                        .grey, // Different color for value
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Policy: ", // Key
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "${charge['PolicyString']}", // Value
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors
                                        .grey, // Different color for value
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "From: ", // Key
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "${charge['FromDate']}", // Value
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors
                                        .grey, // Different color for value
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Time Before Dept: ", // Key
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "${charge['TimeBeforeDept']}", // Value
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors
                                        .grey, // Different color for value
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "To: ", // Key
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "${charge['ToDate']}", // Value
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors
                                        .grey, // Different color for value
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }),
                  ],
                ),

              // Display the Remaining Policies (if any)
              const SizedBox(height: 20),
              const Text(
                "Other Policies:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                cancellationCharges != null
                    ? "Refer to the cancellation charges above."
                    : "No cancellation policies available.",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildLowerDeck(List<List<dynamic>> lowerSeatRows) {
    return _buildSeatDeck("Lower Deck", lowerSeatRows);
  }

  Widget _buildUpperDeck(List<List<dynamic>> upperSeatRows) {
    return _buildSeatDeck("Upper Deck", upperSeatRows);
  }

  Widget _buildSeatDeck(String title, List<List<dynamic>> seatRows) {
    // Reverse the order of the seat rows
    List<List<dynamic>> reversedRows = seatRows.reversed.toList();

    // Check if all seats in the deck are of SeatType == 2
    bool isAllSeatType2 = true;
    for (var row in seatRows) {
      for (var seat in row) {
        if (seat['SeatType'] != 2) {
          isAllSeatType2 = false;
          break;
        }
      }
      if (!isAllSeatType2) break;
    }

    // Check if there are both SeatType == 1 and SeatType == 2 in the same column
    bool hasMixedSeatTypes = false;
    for (var row in seatRows) {
      bool hasSeatType1 = false;
      bool hasSeatType2 = false;
      for (var seat in row) {
        if (seat['SeatType'] == 1) hasSeatType1 = true;
        if (seat['SeatType'] == 2) hasSeatType2 = true;
        if (hasSeatType1 && hasSeatType2) {
          hasMixedSeatTypes = true;
          break;
        }
      }
      if (hasMixedSeatTypes) break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(12),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12), // Top border radius
          bottom: Radius.circular(12),
        ),
        boxShadow: [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              if (title == "Lower Deck")
                SizedBox(
                  width: 26,
                  height: 26,
                  child: Image.asset(
                      "assets/icons/car-steering-icon-removebg-preview.png"),
                )
              //  Icon(Icons.pie_chart_outline_sharp)
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int i = 0; i < reversedRows.length; i++) ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: reversedRows[i].map<Widget>((seat) {
                    bool isSelectable = seat['SeatStatus'] ?? true;
                    bool isMaleSeat = seat['IsMalesSeat'] ?? false;
                    bool isLadiesSeat = seat['IsLadiesSeat'] ?? false;
                    double seatPrice =
                        seat['Price']?['OfferedPriceRoundedOff']?.toDouble() ??
                            0.0;

                    Color borderColor = isMaleSeat
                        ? const Color(0xFF4A90E2) // Border color for male seats
                        : isLadiesSeat
                            ? Colors
                                .pink.shade400 // Border color for ladies seats
                            : Colors.black; // Default border color

                    Color seatColor = !isSelectable
                        ? Colors.grey.shade300
                        : Colors.white; // Default seat color

                    Widget seatWidget;

                    // before space
                    if (seat['SeatType'] == 1) {
                      // Custom stacked layout for SeatType 1 (medium size)
                      seatWidget = Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal:
                                2.0), // Space between seats (top, bottom, left, right)
                        child: SizedBox(
                          width: 30, // Reduced width for medium size
                          height: 30, // Reduced height for medium size
                          child: Stack(
                            children: [
                              Positioned(
                                top: 3, // Adjusted top position
                                bottom: 3, // Adjusted bottom position
                                left: 3, // Adjusted left position
                                right: 3, // Adjusted right position
                                child: SizedBox(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: borderColor,
                                        width: 0.8,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      color: _selectedSeats.any((s) =>
                                              s['SeatName'] == seat['SeatName'])
                                          ? Colors.green
                                          : seatColor,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20, // Adjusted top position
                                bottom: 3, // Adjusted bottom position
                                left: 3, // Adjusted left position
                                right: 3, // Adjusted right position
                                child: SizedBox(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: borderColor,
                                        width: 0.8,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      color: _selectedSeats.any((s) =>
                                              s['SeatName'] == seat['SeatName'])
                                          ? Colors.green
                                          : seatColor,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10, // Adjusted top position
                                bottom: 3, // Adjusted bottom position
                                left: 2, // Adjusted left position
                                right: 20, // Adjusted right position
                                child: SizedBox(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: borderColor,
                                        width: 0.8,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      color: _selectedSeats.any((s) =>
                                              s['SeatName'] == seat['SeatName'])
                                          ? Colors.green
                                          : seatColor,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10, // Adjusted top position
                                bottom: 3, // Adjusted bottom position
                                left: 20, // Adjusted left position
                                right: 2, // Adjusted right position
                                child: SizedBox(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: borderColor,
                                        width: 0.8,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      color: _selectedSeats.any((s) =>
                                              s['SeatName'] == seat['SeatName'])
                                          ? Colors.green
                                          : seatColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (seat['SeatType'] == 2) {
                      // Custom layout for SeatType 2
                      seatWidget = Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal:
                                4.0), // Space between seats (top, bottom, left, right)
                        child: Container(
                          width: 30,
                          height: 82,
                          decoration: BoxDecoration(
                            color: _selectedSeats.any(
                                    (s) => s['SeatName'] == seat['SeatName'])
                                ? Colors.green
                                : seatColor,
                            border: Border.all(
                              color: borderColor,
                              width: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              seat['SeatName'],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 8),
                            ),
                          ),
                        ),
                      );
                    } else {
                      // Default seat layout
                      seatWidget = Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _selectedSeats
                                  .any((s) => s['SeatName'] == seat['SeatName'])
                              ? Colors.green
                              : seatColor,
                          border: Border.all(
                            color: borderColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            seat['SeatName'],
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    }

                    return GestureDetector(
                      onTap: isSelectable
                          ? () => _toggleSeatSelection(seat)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0), // Space between seats
                        child: Column(
                          children: [
                            seatWidget,
                            Text(
                              !isSelectable
                                  ? "Sold"
                                  : "₹${_calculatePriceWithCommission(seatPrice).toStringAsFixed(0)}",
                              style: TextStyle(
                                color:
                                    !isSelectable ? Colors.green : Colors.black,
                                fontSize: 10,
                                fontWeight: !isSelectable
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                // Add a SizedBox(width: 50) after the first column if all seats are of SeatType == 2 or if there are mixed seat types
                if ((isAllSeatType2 || hasMixedSeatTypes) && i == 0)
                  const SizedBox(width: 50),
              ],
            ],
          ),
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
