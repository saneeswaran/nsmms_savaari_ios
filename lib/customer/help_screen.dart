// bus_booking_application

import 'package:flutter/material.dart';

import 'customer_chat_screen.dart';
import 'customer_help_topics.dart';
import 'customer_new_bus_booking_predefined_messages.dart';
import 'customer_offers_predefined_screen.dart';
import 'customer_prefered_questions.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<HelpItem> helpItems = [
    HelpItem(
      title: 'Bus Tickets',
      icon: Icons.help,
      color: Colors.white,
      destination: const HelpTopicsScreen(),
    ),
    HelpItem(
      title: 'Technical Issues',
      icon: Icons.support,
      color: Colors.white,
      destination: const TechnicalSupportScreen(),
    ),
    HelpItem(
      title: 'New Bus Booking Help',
      icon: Icons.bus_alert,
      color: Colors.white,
      destination: const CustomerNewBusBookingPredefinedScreen(),
    ),
    HelpItem(
      title: 'Offers Help',
      icon: Icons.stars,
      color: Colors.white,
      destination: const CustomerOffersPredefinedScreen(),
    ),
    HelpItem(
      title: 'Chat with Us',
      icon: Icons.chat,
      color: Colors.white,
      destination: const CustomerChatScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.pink[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title at the top left of the body
            const Padding(
              padding: EdgeInsets.only(left: 16.0,top: 16),
              child: Text(
                'FAQS (Select a Help Topic)',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ),
            // White container for "Bus Tickets"
            _buildHelpTile(helpItems[0]),

            // Help topics label below the container
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                'Help topics',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // White containers for Technical Issues, New Bus Booking Help, and Offers Help
            _buildHelpTile(helpItems[1]),
            _buildHelpTile(helpItems[2]),
            _buildHelpTile(helpItems[3]),

            // Label for "Live Chat"
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                'Live Chat',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // White container for "Chat with Us"
            _buildHelpTile(helpItems[4]),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpTile(HelpItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: item.color,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: Colors.redAccent.shade700,
          size: 24,
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            item.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item.destination),
          );
        },
      ),
    );
  }
}

class HelpItem {
  final String title;
  final IconData icon;
  final Color color;
  final Widget destination;

  HelpItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.destination,
  });
}












