// bus_booking_application

import 'package:flutter/material.dart';

class OfferDetailsPage extends StatelessWidget {
  final String imageUrl;
  final String offerLine;
  final String couponCode;
  final String validTill;
  final String terms;

  const OfferDetailsPage({
    super.key,
    required this.imageUrl,
    required this.offerLine,
    required this.couponCode,
    required this.validTill,
    required this.terms,
  });

  Color _getBackgroundColor(String couponCode) {
    int length = couponCode.length;
    if (length <= 5) {
      return Colors.amber.shade900; // Shorter codes have a green background
    } else if (length <= 10) {
      return Colors.pink; // Medium-length codes have a blue background
    } else {
      return Colors.cyanAccent; // Longer codes have a red background
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offer Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Background image
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Adjust the value as needed
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: 340,
                      height: 200, // Set the height for the image
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text('Error loading image'));
                      },
                    ),
                  ),
                ),
                // Positioned offer line text
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Text(
                    offerLine,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                // Positioned valid till text
                Positioned(
                  bottom: 50,
                  left: 20,
                  right: 20,
                  child: Text(
                    'Valid Till: $validTill',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                // Positioned coupon code text
                Positioned(
                  bottom: 15,
                  left: 20,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 40, // Adjust based on padding
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getBackgroundColor(couponCode),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_offer,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          couponCode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis, // Prevents overflow by truncating
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Terms text below the image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Terms & Conditions:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    terms,
                    style: const TextStyle(fontSize: 14,color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
