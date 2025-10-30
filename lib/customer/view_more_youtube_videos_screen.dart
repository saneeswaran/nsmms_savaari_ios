// bus_booking_application

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewMorePage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   ViewMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trending Videos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent.shade700,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align "All Videos" to the left
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'All Videos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('admin')
                  .doc('youtube_video')
                  .collection('videos')
                  .snapshots(),
              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return Center(child: CircularProgressIndicator());
                // }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent.shade700),
                      strokeWidth: 6.0,
                    ),
                  );
                }

                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return LinearProgressIndicator(
                //     valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                //     minHeight: 5.0,
                //   );
                // }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final videos = snapshot.data!.docs;

                if (videos.isEmpty) {
                  return const Center(child: Text('No videos available'));
                }

                return ListView.separated(
                  itemCount: videos.length,
                  separatorBuilder: (context, index) => const Divider(height: 20),
                  itemBuilder: (context, index) {
                    final videoUrl = videos[index]['url'];
                    final videoId = _getVideoId(videoUrl);
                    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
                    final videoTitle = videos[index]['title'] ?? '';

                    return GestureDetector(
                      onTap: () => _playVideo(videoUrl),
                      child: Column(
                        children: [
                          Image.network(
                            thumbnailUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                            child: Text(
                              videoTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _playVideo(String videoUrl) async {
    if (await canLaunch(videoUrl)) {
      await launch(videoUrl);
    } else {
      throw 'Could not launch $videoUrl';
    }
  }

  String _getVideoId(String url) {
    final RegExp regExp = RegExp(
      r'(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?|watch|.+\?v)=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(url);
    if (match != null) {
      return match.group(1) ?? '';
    }
    return '';
  }
}

