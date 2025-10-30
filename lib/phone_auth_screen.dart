import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clear Razorpay instance when not needed
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _showDialog(
      title: "Payment Successful",
      message: "Payment ID: ${response.paymentId}",
      isSuccess: true,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showDialog(
      title: "Payment Failed",
      message: "Error: ${response.message}",
      isSuccess: false,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showDialog(
      title: "External Wallet Selected",
      message: "Wallet: ${response.walletName}",
      isSuccess: true,
    );
  }

  void _openCheckout() async {
    var options = {
      'key': 'rzp_test_0JqfNU3fC2HG7Z', // Replace with your Razorpay key
      'amount': 10000, // Amount in paise (10000 = ₹100)
      'name': 'Namma Savaari',
      'description': 'Payment for your order',
      'theme': {'color': '#ff2291'},
      'prefill': {
        'contact': '9999999999',
        'email': 'test@example.com',
      },
      'retry': {'enabled': true, 'max_count': 3},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: $e");
      _showDialog(
        title: "Error",
        message: "An error occurred while opening the payment gateway.",
        isSuccess: false,
      );
    }
  }

  void _showDialog({required String title, required String message, required bool isSuccess}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Screen"),
        backgroundColor: Colors.redAccent.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Make a Payment",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Pay securely with Razorpay for your journey.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _openCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Pay with Razorpay",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
