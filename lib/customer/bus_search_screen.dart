// import 'package:flutter/material.dart';
// import 'bus_search_service.dart'; // Ensure correct import
//
// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   final ApiService _apiService = ApiService();
//   List<dynamic> _busResults = [];
//   bool _isLoading = false;
//   String _errorMessage = "";
//
//   // Controllers for the input fields
//   final TextEditingController _sourceCityController = TextEditingController();
//   final TextEditingController _destinationCityController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//
//   // Function to handle bus search
//   Future<void> _searchBuses() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = "";
//     });
//
//     final String sourceCity = _sourceCityController.text;
//     final String destinationCity = _destinationCityController.text;
//     final String departDate = _dateController.text;
//
//     if (sourceCity.isEmpty || destinationCity.isEmpty || departDate.isEmpty) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = "All fields must be filled!";
//       });
//       return;
//     }
//
//     try {
//       // Ensure that all parameters are passed correctly
//       final response = await _apiService.search(
//         clientId: "180131",
//         username: "Namma434",
//         password: "Namma@4341",
//         sourceCity: sourceCity,
//         sourceCode: 3534, // Ensure correct source code
//         destinationCity: destinationCity,
//         destinationCode: 9771, // Ensure correct destination code
//         departDate: departDate,
//       );
//
//       print('API Response: $response');  // Debugging: print the full API response
//
//       setState(() {
//         // Handle the response if there are bus results
//         _busResults = response['Result']?['BusResults'] ?? [];
//       });
//     } catch (e) {
//       print('Error: $e');  // Debugging: print the error
//       setState(() {
//         _errorMessage = e.toString();
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search Buses'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // TextFields for Source City, Destination City, and Date
//             TextField(
//               controller: _sourceCityController,
//               decoration: InputDecoration(labelText: "Source City"),
//             ),
//             TextField(
//               controller: _destinationCityController,
//               decoration: InputDecoration(labelText: "Destination City"),
//             ),
//             TextField(
//               controller: _dateController,
//               decoration: InputDecoration(labelText: "Departure Date (YYYY-MM-DD)"),
//               keyboardType: TextInputType.datetime,
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _searchBuses,
//               child: Text('Search Buses'),
//             ),
//             if (_isLoading)
//               CircularProgressIndicator(),
//             if (_errorMessage.isNotEmpty)
//               Text(
//                 _errorMessage,
//                 style: TextStyle(color: Colors.red),
//               ),
//             if (_busResults.isNotEmpty)
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _busResults.length,
//                   itemBuilder: (context, index) {
//                     final bus = _busResults[index];
//
//                     return Container(
//                       margin: EdgeInsets.symmetric(vertical: 8.0),
//                       padding: EdgeInsets.all(12.0),
//                       decoration: BoxDecoration(
//                         color: Colors.blue[50],
//                         borderRadius: BorderRadius.circular(8.0),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.3),
//                             spreadRadius: 1,
//                             blurRadius: 5,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '${bus['ServiceName']} (${bus['TravelName']})',
//                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                           ),
//                           SizedBox(height: 8),
//                           Text('Bus Type: ${bus['BusType']}'),
//                           SizedBox(height: 4),
//                           Text('Departure: ${bus['DepartureTime']}'),
//                           SizedBox(height: 4),
//                           Text('Arrival: ${bus['ArrivalTime']}'),
//                           SizedBox(height: 4),
//                           Text('Available Seats: ${bus['AvailableSeats']}'),
//                           Divider(),
//                           Text('Price: ₹${bus['Price']['PublishedPrice']} (Discounted: ₹${bus['Price']['OfferedPrice']})'),
//                           SizedBox(height: 4),
//                           Text('Route ID: ${bus['RouteId']}'),
//                           SizedBox(height: 4),
//                           Text('Live Tracking: ${bus['LiveTrackingAvailable'] ? 'Yes' : 'No'}'),
//                           SizedBox(height: 4),
//                           Text('M-Ticket Enabled: ${bus['MTicketEnabled'] ? 'Yes' : 'No'}'),
//                           Divider(),
//
//                           // Boarding Points
//                           if (bus['BoardingPoints'] != null && bus['BoardingPoints'].isNotEmpty)
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Boarding Points:',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 ...bus['BoardingPoints'].map<Widget>((point) {
//                                   return Text(
//                                     '${point['CityPointName']} at ${point['CityPointTime']}',
//                                   );
//                                 }).toList(),
//                               ],
//                             ),
//
//                           Divider(),
//
//                           // Dropping Points
//                           if (bus['DroppingPoints'] != null && bus['DroppingPoints'].isNotEmpty)
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Dropping Points:',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 ...bus['DroppingPoints'].map<Widget>((point) {
//                                   return Text(
//                                     '${point['CityPointName']} at ${point['CityPointTime']}',
//                                   );
//                                 }).toList(),
//                               ],
//                             ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
