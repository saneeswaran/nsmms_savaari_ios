// Center(
// child: Container(
// height: 55,
// width: double.infinity,
// child: ElevatedButton(
// onPressed: () => Navigator.pop(context), // Close the dialog
// style: ElevatedButton.styleFrom(
// backgroundColor: Colors.pink, // Set the button color
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
// ),
// ),
// child: Text(
// "Okay",
// style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold), // Optional: Customize text color
// ),
// ),
// ),
// )
//
//
// Future<void> _fetchSeatLayout() async {
// final String apiUrl = "https://bus.srdvtest.com/v5/rest/GetSeatLayOut";
// final Map<String, dynamic> requestBody = {
// "ClientId": "180131",
// "UserName": "Namma434",
// "Password": "Namma@4341",
// "TraceId": "1",
// "ResultIndex": widget.resultIndex,
// };
// final headers = {
// "Content-Type": "application/json",
// "Api-Token": "Namma@90434#34",
// };
//
// try {
// final response = await http.post(
// Uri.parse(apiUrl),
// headers: headers,
// body: jsonEncode(requestBody),
// );
//
// if (response.statusCode == 200) {
// final responseBody = jsonDecode(response.body);
//
// setState(() {
// _seatLayoutData = responseBody;
// _isLoading = false;
// });
// } else {
// setState(() {
// _errorMessage = "Failed to fetch seat layout: ${response.body}";
// _isLoading = false;
// });
// }
// } catch (e) {
// setState(() {
// _errorMessage = "Error: ${e.toString()}";
// _isLoading = false;
// });
// }
// }
//
// void _toggleSeatSelection(String seatName) {
// setState(() {
// if (_selectedSeats.contains(seatName)) {
// _selectedSeats.remove(seatName); // Deselect seat
// } else {
// if (_selectedSeats.length < maxSeatSelection) {
// _selectedSeats.add(seatName); // Select seat
// } else {
// _showMaxSelectionDialog(); // Show alert dialog if max limit is reached
// }
// }
// });
// }
//
// void _showMaxSelectionDialog() {
// showDialog(
// context: context,
// builder: (context) =>
// AlertDialog(
// title: Icon(Icons.airline_seat_recline_extra, size: 80,
// color: Colors.indigo[300],),
// content: Text(
// "You can select a maximum of $maxSeatSelection seats.",
// style: TextStyle(color: Colors.black,
// fontSize: 20,
// fontWeight: FontWeight.bold),),
// actions: [
// TextButton(
// onPressed: () => Navigator.pop(context), // Close the dialog
// child: Text("Okay"),
// ),
// ],
// ),
// );
// }
//
//
//
// void _toggleSeatSelection(Map<String, dynamic> seat) {
// setState(() {
// if (_selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])) {
// _selectedSeats.removeWhere((s) => s['SeatName'] == seat['SeatName']);
// } else {
// if (_selectedSeats.length < maxSeatSelection) {
// _selectedSeats.add(seat);
// } else {
// _showMaxSelectionDialog();
// }
// }
// });
//
// // Show the seat summary dialog only when there are selected seats
// if (_selectedSeats.isNotEmpty) {
// _showSeatSummaryDialog();
// } else {
// Navigator.pop(context); // Close the dialog if no seats are selected
// }
// }
//
// void _showSeatSummaryDialog() {
// if (_selectedSeats.isEmpty) {
// // Keep the bottom sheet open only when seats are selected
// return;
// }
//
// // Show the bottom sheet when there are selected seats
// showModalBottomSheet(
// context: context,
// isScrollControlled: true, // Allow the height to adjust based on content
// builder: (context) {
// int totalSelectedSeats = _selectedSeats.length;
// double totalPrice = _selectedSeats.fold(0.0, (sum, seat) => sum + seat['SeatFare']);
//
// return Container(
// padding: EdgeInsets.all(16.0),
// height: 200, // Set a fixed height for the bottom sheet
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(
// "Seats: $totalSelectedSeats",
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// Text(
// "Total: ₹${totalPrice.toStringAsFixed(2)}",
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// ],
// ),
// Spacer(),
// ElevatedButton(
// onPressed: () {
// // Add boarding & dropping point selection logic here
// },
// child: Text("Boarding & Dropping Point Selection"),
// ),
// ],
// ),
// );
// },
// );
// }
