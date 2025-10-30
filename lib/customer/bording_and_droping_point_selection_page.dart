import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:namma_savaari/customer/passenger_details_form.dart';

class BoardingDroppingPage extends StatefulWidget {
  final String resultIndex;
  final String traceId;
  final String sourceCity;
  final String destinationCity;
  final String journeyDate;
  final String travelName;
  final String busType;
  final String arrivalTime;
  final String departureTime;
  final List<Map<String, dynamic>>
      selectedSeats; // Changed to accept list of seats

  const BoardingDroppingPage({
    super.key,
    required this.resultIndex,
    required this.traceId,
    required this.sourceCity,
    required this.destinationCity,
    required this.journeyDate,
    required this.travelName,
    required this.busType,
    required this.arrivalTime,
    required this.departureTime,
    required this.selectedSeats,
  });

  @override
  _BoardingDroppingPageState createState() => _BoardingDroppingPageState();
}

class _BoardingDroppingPageState extends State<BoardingDroppingPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  String _errorMessage = "";
  List<dynamic> _boardingPointsDetails = [];
  List<dynamic> _droppingPointsDetails = [];
  late TabController _tabController;

  String? _selectedBoardingPoint;
  int? _selectedBoardingPointIndex;
  String? _selectedDroppingPoint;
  int? _selectedDroppingPointIndex;

  Future<void> _fetchBoardingPointDetails() async {
    // const String apiUrl = "https://bus.srdvapi.com/v5/rest/GetBoardingPointDetails";
    const String apiUrl =
        "https://namma-savaari-api-backend.vercel.app/get-boarding-point";

    Map<String, dynamic> requestBody = {
      "ClientId": "180187",
      "UserName": "Namma434",
      "Password": "Namma@4341",
      "TraceId": widget.traceId,
      "ResultIndex": widget.resultIndex,
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
        setState(() {
          // Extract BoardingPointsDetails and DroppingPointsDetails
          _boardingPointsDetails = responseBody['GetBusRouteDetailResult']
                  ['BoardingPointsDetails'] ??
              [];
          _droppingPointsDetails = responseBody['GetBusRouteDetailResult']
                  ['DroppingPointsDetails'] ??
              [];
        });
      } else {
        setState(() {
          _errorMessage = "Failed to fetch details: ${response.body}";
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
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchBoardingPointDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        toolbarHeight: 100,
        backgroundColor: Colors.redAccent.shade700,
        title: const Text(
          "Boarding & Dropping Points",
          style: TextStyle(color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Boarding Points",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      if (_selectedBoardingPoint != null)
                        Text(
                          "$_selectedBoardingPoint",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[200],
                              fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ),
              Tab(
                height: 70,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Dropping Points",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      if (_selectedDroppingPoint != null)
                        Text(
                          "$_selectedDroppingPoint",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[300],
                              fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBoardingPointsTab(),
                    _buildDroppingPointsTab(),
                  ],
                ),
    );
  }

  Widget _buildBoardingPointsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _boardingPointsDetails.isEmpty
              ? const Text("No Boarding Points available")
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _boardingPointsDetails.length,
                  itemBuilder: (context, index) {
                    final boardingPoint = _boardingPointsDetails[index];
                    String cityPointTime = boardingPoint['CityPointTime'] ?? '';
                    String formattedTime = cityPointTime.contains('T')
                        ? cityPointTime
                            .split('T')[1]
                            .split(':')
                            .take(2)
                            .join(':')
                        : cityPointTime.split(':').take(2).join(':');

                    return ListTile(
                      leading: Text(
                        formattedTime,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      title: Text(boardingPoint['CityPointName'] ?? 'Unknown'),
                      subtitle: Text(boardingPoint['CityPointLocation'] ??
                          'No location available'),
                      onTap: () {
                        setState(() {
                          _selectedBoardingPoint =
                              boardingPoint['CityPointName'] ?? 'Unknown';
                          _selectedBoardingPointIndex = boardingPoint[
                              'CityPointIndex']; // Extract CityPointIndex
                        });
                        _tabController.animateTo(1);
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildDroppingPointsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _droppingPointsDetails.isEmpty
              ? const Text("No Dropping Points available")
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _droppingPointsDetails.length,
                  itemBuilder: (context, index) {
                    final droppingPoint = _droppingPointsDetails[index];
                    String cityPointTime = droppingPoint['CityPointTime'] ?? '';
                    String formattedTime = cityPointTime.contains('T')
                        ? cityPointTime
                            .split('T')[1]
                            .split(':')
                            .take(2)
                            .join(':')
                        : cityPointTime.split(':').take(2).join(':');

                    return ListTile(
                      leading: Text(
                        formattedTime,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      title: Text(droppingPoint['CityPointName'] ?? 'Unknown'),
                      subtitle: Text(droppingPoint['CityPointLocation'] ??
                          'No location available'),
                      onTap: () {
                        setState(() {
                          _selectedDroppingPoint =
                              droppingPoint['CityPointName'] ?? 'Unknown';
                          _selectedDroppingPointIndex =
                              droppingPoint['CityPointIndex'];
                        });

                        // Print all selected seats for debugging
                        log("Selected Seats:");
                        for (var seat in widget.selectedSeats) {
                          log("Seat Name: ${seat['SeatName']}");
                          log("Seat Fare: ${seat['SeatFare']}");
                          // Add other seat details you want to log
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlockSeatPage(
                              boardingPointIndex: _selectedBoardingPointIndex,
                              droppingPointIndex: _selectedDroppingPointIndex,
                              selectedBoardingPoint:
                                  _selectedBoardingPoint ?? 'Unknown',
                              selectedDroppingPoint:
                                  _selectedDroppingPoint ?? 'Unknown',
                              resultIndex: widget.resultIndex,
                              traceId: widget.traceId,
                              sourceCity: widget.sourceCity,
                              destinationCity: widget.destinationCity,
                              journeyDate: widget.journeyDate,
                              travelName: widget.travelName,
                              busType: widget.busType,
                              arrivalTime: widget.arrivalTime,
                              departureTime: widget.departureTime,
                              selectedSeats: widget.selectedSeats,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }
}
