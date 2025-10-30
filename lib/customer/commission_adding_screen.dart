import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommissionSettings extends StatefulWidget {
  const CommissionSettings({super.key});

  @override
  _CommissionSettingsState createState() => _CommissionSettingsState();
}

class _CommissionSettingsState extends State<CommissionSettings> {
  final TextEditingController _commissionController = TextEditingController();
  bool _isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadCurrentCommission();
  }

  Future<void> _loadCurrentCommission() async {
    setState(() => _isLoading = true);
    try {
      final doc = await _firestore.collection('settings').doc('commission').get();
      if (doc.exists) {
        _commissionController.text = doc.data()?['percentage']?.toString() ?? '0';
      }
    } catch (e) {
                            if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load commission: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveCommission() async {
    final commission = double.tryParse(_commissionController.text) ?? 0;
    if (commission < 0 || commission > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a value between 0 and 100')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _firestore.collection('settings').doc('commission').set({
        'percentage': commission,
        'updatedAt': FieldValue.serverTimestamp(),
      });
                            if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Commission saved successfully!')),
      );
      Navigator.pop(context); // Return to previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save commission: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Commission Settings',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Set Commission Percentage',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _commissionController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Commission (%)',
                    hintText: 'Enter percentage (0-100)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixText: '%',
                    prefixIcon: const Icon(Icons.percent),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    // icon: const Icon(Icons.save_alt),
                    label: _isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Save Commission',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: _isLoading ? null : _saveCommission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commissionController.dispose();
    super.dispose();
  }
}