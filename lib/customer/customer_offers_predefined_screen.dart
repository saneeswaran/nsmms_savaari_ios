// bus_booking_application

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerOffersPredefinedScreen extends StatefulWidget {
  const CustomerOffersPredefinedScreen({super.key});

  @override
  _CustomerOffersPredefinedScreenState createState() => _CustomerOffersPredefinedScreenState();
}

class _CustomerOffersPredefinedScreenState extends State<CustomerOffersPredefinedScreen> {
  List<String> _questions = []; // Questions from Firestore
  List<String> _answers = [];   // Answers from Firestore
  final List<String> _selectedQuestions = []; // List to store selected questions
  final List<String> _selectedAnswers = [];   // List to store selected answers
  bool _isContainerVisible = false;     // Controls visibility of the container
  final ScrollController _scrollController = ScrollController(); // Controller for scrolling

  // Fetch questions and answers from Firestore
  Future<void> _fetchQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('admin')
        .doc('admin_offers_prefred_messages')
        .get();

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null) {
        setState(() {
          _questions = List<String>.from(data['questions'] ?? []);
          _answers = List<String>.from(data['answers'] ?? []);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  // Add selected question and answer to the lists
  void _onQuestionTap(String question) {
    int index = _questions.indexOf(question);

    setState(() {
      _selectedQuestions.add(question); // Add the selected question
      _selectedAnswers.add(
          _answers.length > index ? _answers[index] : "Answer not available."
      ); // Add corresponding answer or fallback to default
      _isContainerVisible = false; // Auto-close container after selection
    });

    // Scroll to the bottom of the list to show the new question
    _scrollToBottom();
  }

  // Scroll to the bottom of the screen to show the latest selected question
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent, // Scroll to the bottom
          duration: const Duration(milliseconds: 500),     // Animation duration
          curve: Curves.easeInOut,                   // Animation curve
        );
      }
    });
  }

  // Toggle the visibility of the question container
  void _toggleQuestionContainer() {
    setState(() {
      _isContainerVisible = !_isContainerVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the row items
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange, // Set the background color to orange
              radius: 20, // Adjust the radius for size
              child: Icon(
                Icons.directions_bus, // Use bus icon
                size: 24, // Adjust size of the icon inside the avatar
                color: Colors.white, // Set the color of the icon (white for contrast)
              ),
            ),
            SizedBox(width: 8), // Space between icon and text
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                children: [
                  Text(
                    'Offers Help',
                    style: TextStyle(fontSize: 18), // Adjusted text size
                    overflow: TextOverflow.ellipsis, // Add this to handle overflow
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Need some technical help?',
                    style: TextStyle(fontSize: 13, color: Colors.grey), // Adjust text style as needed
                    overflow: TextOverflow.ellipsis, // Add this to handle overflow
                  ),
                ],
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false, // Prevent back button
      ),
      body: Stack(
        children: [
          // Scrollable content to display selected questions and answers
          SingleChildScrollView(
            controller: _scrollController, // Attach the scroll controller here
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display all selected questions and answers with images
                  for (int i = 0; i < _selectedQuestions.length; i++) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image beside the question
                        const CircleAvatar(
                          backgroundColor: Colors.teal,
                          radius: 20, // Adjust radius for size
                          child: Text(
                            'You',
                            style: TextStyle(
                              color: Colors.white, // Text color to contrast with the teal background
                              fontSize: 14, // Adjust text size as needed
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10), // Space between image and text
                        Expanded( // Ensures text takes up the remaining space
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _selectedQuestions[i],
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image beside the answer
                        const CircleAvatar(
                          backgroundImage: AssetImage('assets/Namma_Savaari_LOGO1.png'), // Your asset path
                          radius: 20, // Adjust radius for size
                        ),
                        const SizedBox(width: 10), // Space between image and text
                        Expanded( // Ensures text takes up the remaining space
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _selectedAnswers[i],
                              style: const TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Floating container for questions (only visible when _isContainerVisible is true)
          if (_isContainerVisible)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 80, right: 20), // Adjust for floating button position
                decoration: BoxDecoration(
                  color: Colors.redAccent.shade200,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.6, // Adjust width as per requirement
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Ensures the column takes minimal space
                  children: _questions.map((question) {
                    return GestureDetector(
                      onTap: () => _onQuestionTap(question),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          question,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),

      // Floating Action Button to toggle the visibility of the question container
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleQuestionContainer, // Toggle icon
        backgroundColor: Colors.redAccent.shade200,
        child: Icon(_isContainerVisible ? Icons.close : Icons.question_answer,color: Colors.white,),
      ),
    );
  }
}


