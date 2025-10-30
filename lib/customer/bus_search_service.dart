// total busses with ui


// title: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// "${widget.sourceCity} -> ${widget.destinationCity}",
// style: TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.bold,
// color: Colors.white,
// ),
// ),
// Text(
// "${_busResults.length} Buses",
// style: TextStyle(
// fontSize: 14,
// fontWeight: FontWeight.normal,
// color: Colors.white70, // Use a lighter white for the subtitle
// ),
// ),
// ],
// ),

// total busses without ui
// appBar: AppBar(
//   backgroundColor: Colors.pink[300],
//   title: Text(
//     "${widget.sourceCity} -> ${widget.destinationCity} (${_busResults.length} Buses)",
//     style: TextStyle(
//       fontSize: 20,
//       fontWeight: FontWeight.bold,
//       color: Colors.white,
//     ),
//   ),
// ),



// body: _isLoading
// ? Center(child: CircularProgressIndicator())
//     : _errorMessage.isNotEmpty
// ? Center(child: Text(_errorMessage))
//     : _seatLayoutData != null
// ? Padding(
// padding: const EdgeInsets.all(16.0),
// child: Column(
// children: [
// if (_temporaryPrice != null)
// Container(
// padding: EdgeInsets.symmetric(vertical: 10.0),
// alignment: Alignment.center,
// color: Colors.pink,
// child: Text(
// _temporaryPrice!,
// style: TextStyle(
// fontSize: 20,
// fontWeight: FontWeight.bold,
// color: Colors.white,
// ),
// ),
// ),
// Expanded( // Ensures the seat layout scrolls within the available space
// child: SingleChildScrollView(
// child: Column(
// children: _buildSeatRows(),
// ),
// ),
// ),
// SizedBox(height: 10), // Spacing before the journey date container
// Container(
// padding: EdgeInsets.all(16.0),
// decoration: BoxDecoration(
// color: Colors.white,
// border: Border.all(color: Colors.pink, width: 2),
// borderRadius: BorderRadius.circular(8.0),
// ),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Text(
// "Journey Date: ",
// style: TextStyle(
// fontSize: 16,
// fontWeight: FontWeight.bold,
// color: Colors.black54,
// ),
// ),
// Text(
// widget.journeyDate,
// style: TextStyle(
// fontSize: 16,
// fontWeight: FontWeight.bold,
// color: Colors.pink[400],
// ),
// ),
// ],
// ),
// ),
// ],
// ),
// )
//     : Center(
// child: Text(
// "No data available.",
// style: TextStyle(fontSize: 16, color: Colors.red),
// ),
// ),


//main

// Future<void> _fetchBoardingPointDetails() async {
//   const String apiUrl = "https://bus.srdvapi.com/v5/rest/GetBoardingPointDetails";
//   Map<String, dynamic> requestBody = {
//     "ClientId": "180187",
//     "UserName": "Namma434",
//     "Password": "Namma@4341",
//     "TraceId": widget.traceId,
//     "ResultIndex": widget.resultIndex,
//     // Add selectedSeats details as a separate field
//     "SelectedSeats": widget.selectedSeats.map((seat) {
//       return {
//         "SeatName": seat['seatName'],
//         "SeatType": seat['seatType'],
//         // Add any other details from the seat object if required
//       };
//     }).toList(),
//   };
//   const headers = {
//     "Content-Type": "application/json",
//     "Api-Token": "Namma@90434#34",
//   };
//
//   setState(() {
//     _isLoading = true;
//     _errorMessage = "";
//   });
//
//   try {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: headers,
//       body: jsonEncode(requestBody),
//     );
//
//     if (response.statusCode == 200) {
//       final responseBody = jsonDecode(response.body);
//       setState(() {
//         _boardingPointsDetails = responseBody['GetBusRouteDetailResult']['BoardingPointsDetails'] ?? [];
//         _droppingPointsDetails = responseBody['GetBusRouteDetailResult']['DroppingPointsDetails'] ?? [];
//       });
//     } else {
//       setState(() {
//         _errorMessage = "Failed to fetch details: ${response.body}";
//       });
//     }
//   } catch (e) {
//     setState(() {
//       _errorMessage = "Error: ${e.toString()}";
//     });
//   } finally {
//     setState(() {
//       _isLoading = false;
//     });
//   }
// }



// final seatDetails = _seatLayoutData?['Result']?['SeatLayout']?['SeatLayoutDetails']?['Layout']?['seatDetails'];
// if (seatDetails == null) {
//   return [Text("No seat details available")];
// }


// print("Column No: ${widget.columnNo}");
// print("Seat Name: ${widget.seatName}");
// print("Seat Status: ${widget.seatStatus}");
// print("Height: ${widget.height}");
// print("Width: ${widget.width}");
// print("Is Male Seat: ${widget.isMalesSeat}");
// print("Is Ladies Seat: ${widget.isLadiesSeat}");
// print("Is Upper: ${widget.isUpper}");
// print("Row No: ${widget.rowNo}");
// print("Seat Fare: ${widget.seatFare}");
// print("Seat Index: ${widget.seatIndex}");
// print("Seat Type: ${widget.seatType}");
// print("Currency Code: ${widget.currencyCode}");
// print("Base Price: ${widget.basePrice}");
// print("Tax: ${widget.tax}");
// print("Other Charges: ${widget.otherCharges}");
// print("Discount: ${widget.discount}");
// print("Published Price: ${widget.publishedPrice}");
// print("Published Price RoundedOff: ${widget.publishedPriceRoundedOff}");
// print("Offer Price: ${widget.offeredPrice}");
// print("Offer Price RoundedOff: ${widget.offeredPriceRoundedOff}");
// print("Agent Commission: ${widget.agentCommission}");
// print("Agent MarkUp: ${widget.agentMarkUp}");
// print("Tds: ${widget.tds}");
// print("CGST Amount: ${widget.cgstAmount}");
// print("CGST Rate: ${widget.cgstRate}");
// print("CESS Amount: ${widget.cessAmount}");
// print("CESS Rate: ${widget.cessRate}");
// print("IGST Amount: ${widget.igstAmount}");
// print("IGST Rate: ${widget.igstRate}");
// print("SGST Amount: ${widget.sgstAmount}");
// print("SGST Rate: ${widget.sgstRate}");
// print("Taxable Amount: ${widget.taxableAmount}");
// print("Selected Boarding Point: $_selectedBoardingPoint");
// print("Selected Boarding Point Index: $_selectedBoardingPointIndex");
// print("Selected Droping Point: $_selectedDroppingPoint");
// print("Selected Droping Point Index: $_selectedDroppingPointIndex");



// if (response.statusCode == 200) {
// final responseBody = jsonDecode(response.body);
// if (responseBody['IsPriceChanged'] == true) {
// setState(() {
// _errorMessage = "Price has changed. Please try again.";
// });
// } else {
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(content: Text("Seat successfully blocked!")),
// );
// }
// } else {
// setState(() {
// _errorMessage = "Failed to block seat: ${response.statusCode} - ${response.body}";
// });
// }


// Seat Design


// Container(
// width: 40,
// height: 40,
// child: Stack(
// children: [
// Positioned(
// top: 5,
// bottom: 5,
// left: 5,
// right: 5,
// child:SizedBox(
// child: DecoratedBox(
// decoration: BoxDecoration(
// border: Border.all(
// color: Colors.black,
// width: 1,
// ),
// borderRadius: BorderRadius.circular(5),
// color: Colors.white
// ),
// ),
// ),),
// Positioned(
// top: 29,
// bottom: 5,
// left: 5,
// right: 5,
// child:SizedBox(
// child: DecoratedBox(
// decoration: BoxDecoration(
// border: Border.all(
// color: Colors.black,
// width: 1,
// ),
// borderRadius: BorderRadius.circular(5),
// color: Colors.white
// ),
// ),
// ),),
// Positioned(
// top: 15,
// bottom: 5,
// left: 4,
// right: 30,
// child:SizedBox(
// child: DecoratedBox(
// decoration: BoxDecoration(
// border: Border.all(
// color: Colors.black,
// width: 1,
// ),
// borderRadius: BorderRadius.circular(5),
// color: Colors.white
// ),
// ),
// ),),
// Positioned(
// top: 15,
// bottom: 5,
// left: 30,
// right: 4,
// child:SizedBox(
// child: DecoratedBox(
// decoration: BoxDecoration(
// border: Border.all(
// color: Colors.black,
// width: 1,
// ),
// borderRadius: BorderRadius.circular(5),
// color: Colors.white
// ),
// ),
// ),)
//
// ],
// ),
// ),


import 'package:flutter/material.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Ticket'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Displaying the Snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Insufficient balance',
                  style: TextStyle(fontSize: 16.0),
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3), // Snackbar duration
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Book',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}




// if (seat['SeatType'] == 1) {
// // Custom stacked layout for SeatType 1
// seatWidget = Padding(
// padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0), // Space between seats (top, bottom, left, right)
// child: Container(
// width: 40,
// height: 40,
// child: Stack(
// children: [
// Positioned(
// top: 5,
// bottom: 5,
// left: 5,
// right: 5,
// child: SizedBox(
// child: DecoratedBox(
// decoration: BoxDecoration(
// border: Border.all(
// color: isMaleSeat
// ? Colors.indigo.shade400 // Border color for male seats
//     : isLadiesSeat
// ? Colors.pink.shade400 // Border color for ladies seats
//     : Colors.black, // Default border color
// width: 0.5,
// ),
// borderRadius: BorderRadius.circular(5),
// color: _selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])
// ? Colors.green
//     : Colors.white, // Default seat color
// ),
// ),
// ),
// ),
// // Other Positioned widgets for SeatType 1...
// ],
// ),
// ),
// );
// }



//
// if (seat['SeatType'] == 1) {
// // Custom stacked layout for SeatType 1
// seatWidget = Padding(
// padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0), // Space between seats (top, bottom, left, right)
// child: Container(
// width: 40,
// height: 40,
// child: Stack(
// children: [
// Positioned(
// top: 5,
// bottom: 5,
// left: 5,
// right: 5,
// child: SizedBox(
// child: DecoratedBox(
// decoration: BoxDecoration(
// border: Border.all(
// color: isMaleSeat
// ? Colors.indigo.shade400 // Border color for male seats
//     : isLadiesSeat
// ? Colors.pink.shade400 // Border color for ladies seats
//     : Colors.black, // Default border color
// width: 0.5,
// ),
// borderRadius: BorderRadius.circular(5),
// color: _selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])
// ? Colors.green
//     : seatColor,
// // color: seatColor,
// ),
// ),
// ),
// ),
// Positioned(
// top: 29,
// bottom: 5,
// left: 5,
// right: 5,
// child: SizedBox(
// child: DecoratedBox(
// decoration: BoxDecoration(
// border: Border.all(
// color: isMaleSeat
// ? Colors.indigo.shade400 // Border color for male seats
//     : isLadiesSeat
// ? Colors.pink.shade400 // Border color for ladies seats
//     : Colors.black, // Default border color
// width: 0.5,
// ),
// borderRadius: BorderRadius.circular(5),
// color: _selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])
// ? Colors.green
//     : seatColor,
// // color: seatColor,
// ),
// ),
// ),
// ),
// Positioned(
// top: 15,
// bottom: 5,
// left: 4,
// right: 30,
// child: SizedBox(
// child: DecoratedBox(
// decoration: BoxDecoration(
// border: Border.all(
// color: isMaleSeat
// ? Colors.indigo.shade400 // Border color for male seats
//     : isLadiesSeat
// ? Colors.pink.shade400 // Border color for ladies seats
//     : Colors.black, // Default border color
// width: 0.5,
// ),
// borderRadius: BorderRadius.circular(5),
// color: _selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])
// ? Colors.green
//     : seatColor,
// // color: seatColor,
// ),
// ),
// ),
// ),
// Positioned(
// top: 15,
// bottom: 5,
// left: 30,
// right: 4,
// child: SizedBox(
// child: DecoratedBox(
// decoration: BoxDecoration(
// border: Border.all(
// color: isMaleSeat
// ? Colors.indigo.shade400 // Border color for male seats
//     : isLadiesSeat
// ? Colors.pink.shade400 // Border color for ladies seats
//     : Colors.black, // Default border color
// width: 0.5,
// ),
// borderRadius: BorderRadius.circular(5),
// color: _selectedSeats.any((s) => s['SeatName'] == seat['SeatName'])
// ? Colors.green
//     : seatColor,
// // color: seatColor,
// ),
// ),
// ),
// ),
// ],
// ),
// ),
// );
// }



