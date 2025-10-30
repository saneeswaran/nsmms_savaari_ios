// bus_booking_application

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cust_view_other_queries_faqs.dart';

class CustomerOtherQueriesFaqs extends StatelessWidget {
  const CustomerOtherQueriesFaqs({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference faqsCollection = FirebaseFirestore.instance
        .collection('admin')
        .doc('other_queries_faqs')
        .collection('faqs'); // Firestore path to the FAQs subcollection

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
      body: FutureBuilder<QuerySnapshot>(
        future: faqsCollection.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading FAQs'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No FAQs available'));
          }

          // Map each document to a list of question widgets
          List<Widget> faqItems = snapshot.data!.docs.asMap().entries.map((entry) {
            int index = entry.key;
            DocumentSnapshot doc = entry.value;
            Map<String, dynamic> faqData = doc.data() as Map<String, dynamic>;
            String question = faqData['question'] ?? 'No question available';

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                      question,
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      // Navigate to FAQ Detail Page on tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerViewOtherQueriesFaqs(faqId: doc.id),
                        ),
                      );
                    },
                  ),
                ),
                if (index < snapshot.data!.docs.length - 1) // Don't add divider after the last item
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                    thickness: 1,
                    // indent: 16,
                    // endIndent: 16,
                  ),
              ],
            );
          }).toList();

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'FAQs',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: faqItems,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}