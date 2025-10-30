import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_savaari/customer/video/video_player_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ViewMoreShortsScreen extends StatefulWidget {
  const ViewMoreShortsScreen({super.key});

  @override
  _ViewMoreShortsScreenState createState() => _ViewMoreShortsScreenState();
}

class _ViewMoreShortsScreenState extends State<ViewMoreShortsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _getVideoId(String url) {
    // Extract the video ID from the YouTube Shorts URL
    final RegExp regExp = RegExp(
      r'(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:shorts\/|(?:v|e(?:mbed)?|watch|.+\?v)=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(url);
    if (match != null) {
      return match.group(1) ?? '';
    }
    return '';
  }

  void _playVideo(String videoUrl) async {
    final videoId = _getVideoId(videoUrl);
    if (videoId.isNotEmpty) {
      final youtubeUrl = 'https://www.youtube.com/watch?v=$videoId';
      if (await canLaunch(youtubeUrl)) {
        await launch(youtubeUrl);
      } else {
        throw 'Could not launch $youtubeUrl';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade700,
        title: const Text(
          'Trending Shorts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        // centerTitle: true,
        // elevation: 4,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [Colors.pinkAccent, Colors.purple],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //     ),
        //   ),
        // ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('admin')
            .doc('youtube_short')
            .collection('shorts')
            .snapshots(),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(child: CircularProgressIndicator());
          // }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.redAccent.shade700),
              minHeight: 5.0,
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final shorts = snapshot.data!.docs;

          return ListView.separated(
            itemCount: shorts.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.pinkAccent.withOpacity(0.5),
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
            itemBuilder: (context, index) {
              final short = shorts[index];
              final videoUrl = short['url'];
              final videoId = _getVideoId(videoUrl);
              Widget thumbnailWidget;
              if (videoUrl.contains("youtu")) {
                final thumbnailUrl =
                    'https://img.youtube.com/vi/$videoId/0.jpg';
                thumbnailWidget = Image.network(
                  thumbnailUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                );
              } else if (videoUrl.endsWith('.mp4')) {
                thumbnailWidget = FutureBuilder<Uint8List?>(
                  future: VideoThumbnail.thumbnailData(
                    video: videoUrl,
                    imageFormat: ImageFormat.JPEG,
                    maxHeight: 250,
                    quality: 75,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data != null) {
                      return Image.memory(
                        snapshot.data!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      );
                    } else {
                      return Container(
                        width: double.infinity,
                        height: 250,
                        color: Colors.grey.shade300,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                );
              } else {
                thumbnailWidget = Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.grey.shade300,
                  child: Center(child: Icon(Icons.videocam_off)),
                );
              }

              return InkWell(
                onTap: () async {
                  if (videoUrl.contains("youtu")) {
                    _playVideo(videoUrl); // existing YouTube logic
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoPlayerScreen(videoUrl: videoUrl),
                      ),
                    );
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      ClipRRect(child: thumbnailWidget),
                      // Video Title below the thumbnail
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          short['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
