// commission_settings_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommissionSettingsPage extends StatefulWidget {
  const CommissionSettingsPage({super.key});

  @override
  _CommissionSettingsPageState createState() => _CommissionSettingsPageState();
}

class _CommissionSettingsPageState extends State<CommissionSettingsPage> {
  double _commission = 0.0;
  final TextEditingController _customCommissionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCommission();
  }

  Future<void> _loadCommission() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _commission = prefs.getDouble('commission') ?? 0.0;
      _customCommissionController.text = _commission.toString();
    });
  }

  Future<void> _saveCommission(double commission) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('commission', commission);
    setState(() {
      _commission = commission;
    });
                          if(!mounted) return;
    Navigator.pop(context, commission);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commission Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveCommission(double.tryParse(_customCommissionController.text) ?? _commission),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Commission Percentage', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCommissionButton(10),
                _buildCommissionButton(20),
                _buildCommissionButton(30),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Or enter custom percentage:'),
            TextField(
              controller: _customCommissionController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text('Current Commission: ${_commission.toStringAsFixed(1)}%',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildCommissionButton(int percentage) {
    return ElevatedButton(
      onPressed: () => _saveCommission(percentage.toDouble()),
      style: ElevatedButton.styleFrom(
        backgroundColor: _commission == percentage ? Colors.blue : null,
      ),
      child: Text('$percentage%'),
    );
  }
}