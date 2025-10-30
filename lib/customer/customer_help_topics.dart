// bus_booking_application

import 'package:flutter/material.dart';

import 'cust_tick_book_faqs/customer_tick_bok_faqs.dart';
import 'cust_ticket_reschedule_cancel_faqs/cust_tik_resche_cancl_faqs.dart';
import 'customer_bus_cancelation_faqs/cust_bus_cancl_faqs.dart';
import 'customer_offers_faqs/cust_ofers_faqs.dart';
import 'customer_other_queries_faqs/cust_other_queries_faqs.dart';
import 'customer_process_payment_and_refund_faqs/cust_payment_and_refund_faqs.dart';
import 'customer_refund_guarantee_program_faqs/cust_refund_guarantee_faqs.dart';
import 'customer_trip_rewards_faqs/cust_trip_rewards_faqs.dart';
import 'customer_wallet_transaction_faqs/customer_wallet_faqs.dart';

class HelpTopicsScreen extends StatelessWidget {
  const HelpTopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade700,
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Namma Savaari',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'FAQs',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Help Topics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildHelpOption(Icons.confirmation_number, 'Ticket Booking', context),
                  _buildHelpOption(Icons.sync, 'Ticket Reschedule / Cancellation', context),
                  _buildHelpOption(Icons.cancel, 'Bus Cancellation', context),
                  _buildHelpOption(Icons.local_offer, 'Offers', context),
                  _buildHelpOption(Icons.attach_money, 'Payments & Refunds', context),
                  _buildHelpOption(Icons.account_balance_wallet, 'Namma Savaari Wallet', context),
                  _buildHelpOption(Icons.security, 'Refund Guarantee Program', context),
                  _buildHelpOption(Icons.help_outline, 'Other Queries', context),
                  _buildHelpOption(Icons.card_giftcard, 'Trip Rewards', context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build each list item
  Widget _buildHelpOption(IconData icon, String title, BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.redAccent.shade700),
          title: Text(title, style: const TextStyle(fontSize: 15)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 15),
          onTap: () {
            // Navigate to respective pages based on the help topic
            if (title == 'Ticket Booking') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQListPage()),
              );
            } else if (title == 'Ticket Reschedule / Cancellation') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustTikRescheCanclFaqs()),
              );
            } else if (title == 'Bus Cancellation') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustBusCanclFaqs()),
              );
            } else if (title == 'Offers') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustofersFaqs()),
              );
            } else if (title == 'Payments & Refunds') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustPaymentAndRefundFaqs()),
              );
            } else if (title == 'Namma Savaari Wallet') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustomerWalletFaqs()),
              );
            } else if (title == 'Refund Guarantee Program') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustomerRefundGuaranteeFaqs()),
              );
            } else if (title == 'Other Queries') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustomerOtherQueriesFaqs()),
              );
            } else if (title == 'Trip Rewards') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustomerTripRewardsFaqs()),
              );
            }
            // Add similar conditions for other pages
          },
        ),
        const Divider(),
      ],
    );
  }
}



