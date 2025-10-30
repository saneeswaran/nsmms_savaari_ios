// bus_booking_application

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // For clipboard functionality
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerViewOtherQueriesFaqs extends StatefulWidget {
  final String faqId; // ID of the FAQ document

  const CustomerViewOtherQueriesFaqs({super.key, required this.faqId});

  @override
  _CustomerViewOtherQueriesFaqsState createState() => _CustomerViewOtherQueriesFaqsState();
}

class _CustomerViewOtherQueriesFaqsState extends State<CustomerViewOtherQueriesFaqs> {
  int _currentIndex = 0; // Track the current index of the image
  bool _feedbackGiven = false; // Track if feedback has been given

  void _handleFeedback(bool isHelpful) {
    setState(() {
      _feedbackGiven = true; // Set feedback given to true
    });

    // Show the thank you message for 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _feedbackGiven = false; // Reset feedback state after delay
      });
    });

    // You can handle feedback storage or analytics here if needed
    // For example:
    // storeFeedback(isHelpful);
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference faqDoc = FirebaseFirestore.instance
        .collection('admin')
        .doc('other_queries_faqs')
        .collection('faqs')
        .doc(widget.faqId); // Firestore path to the specific FAQ document

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade700,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Namma Savaari',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'FAQs',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: faqDoc.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading FAQ details'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No FAQ details found'));
          }

          Map<String, dynamic> faqData = snapshot.data!.data() as Map<String, dynamic>;

          String? question = faqData['question'];
          String? answer = faqData['answer'];
          List<dynamic>? images = faqData['images'];
          String? videoLink = faqData['video_link'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Container
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text(
                      question ?? 'No question available',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Answer Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        answer ?? 'No answer available',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),

                      // Images Section
                      if (images != null && images.isNotEmpty) ...[
                        if (images.length == 1) ...[
                          // Display single image without carousel
                          Image.network(
                            images[0],
                            fit: BoxFit.cover,
                            height: 200, // Adjust height as needed
                          ),
                        ] else ...[
                          // Display carousel slider for multiple images
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Carousel Slider
                              CarouselSlider.builder(
                                itemCount: images.length,
                                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Image.network(
                                        images[itemIndex],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                options: CarouselOptions(
                                  height: 200, // Adjust height as needed
                                  autoPlay: false,
                                  enlargeCenterPage: true,
                                  aspectRatio: 16 / 9,
                                  pageSnapping: true,
                                  initialPage: _currentIndex,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _currentIndex = index; // Update current index
                                    });
                                  },
                                ),
                              ),

                              // Left and Right Indicators
                              Positioned(
                                left: 10,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: _currentIndex > 0
                                      ? () {
                                    setState(() {
                                      _currentIndex--;
                                    });
                                  }
                                      : null,
                                ),
                              ),
                              Positioned(
                                right: 10,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_forward),
                                  onPressed: _currentIndex < images.length - 1
                                      ? () {
                                    setState(() {
                                      _currentIndex++;
                                    });
                                  }
                                      : null,
                                ),
                              ),
                            ],
                          ),

                          // Bottom Indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: images.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () => setState(() {
                                  _currentIndex = entry.key;
                                }),
                                child: Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (Colors.black.withOpacity(0.5)).withOpacity(
                                        (entry.key == _currentIndex ? 1 : 0.5)),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                        const SizedBox(height: 16),
                      ],

                      // Video Link Section
                      // Video Link Section
                      if (videoLink != null) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            // Try to launch the video link
                            final Uri url = Uri.parse(videoLink);
                            if (await canLaunch(url.toString())) {
                              await launch(url.toString());
                            } else {
                              // If the link cannot be launched, show a snackbar with an error message
                                                    if(!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Could not launch the video link')),
                              );
                            }
                          },
                          onLongPress: () {
                            // Copy the video link to the clipboard
                            Clipboard.setData(ClipboardData(text: videoLink));
                            // Show a snackbar to confirm that the link has been copied
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Video link copied to clipboard')),
                            );
                          },
                          child: Text(
                            videoLink,
                            style: const TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 25,),
                // Conditional rendering for feedback
                if (_feedbackGiven) ...[
                  // Show thank you message
                  const Center(
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, size: 50, color: Colors.green), // Welcome icon
                        SizedBox(height: 8),
                        Text(
                          'Thank you for giving your feedback!',
                          style: TextStyle(fontSize: 16,color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Display "Was this helpful?" text
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Was this helpful?',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16), // Spacing before buttons
                        // Row for YES and NO buttons
                        Center(
                          child: SizedBox(
                            height: 50,
                            width: 320,
                            child: ElevatedButton(
                              onPressed: () {
                                _handleFeedback(true); // Handle YES feedback
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // YES button color
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero, // Remove border radius
                                ),
                              ),
                              child: const Text('YES',style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Center(
                          child: SizedBox(
                            height: 50,
                            width: 320,
                            child: ElevatedButton(
                              onPressed: () {
                                _handleFeedback(false); // Handle NO feedback
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // NO button color
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero, // Remove border radius
                                ),
                              ),
                              child: const Text('NO',style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                      ]
                  )
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
