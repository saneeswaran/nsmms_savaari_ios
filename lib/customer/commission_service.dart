// services/commission_service.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'commission_manager.dart';

class CommissionService {
  static const String _commissionKey = 'commission_data';

  Future<Commission> getCommission() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_commissionKey);

    if (jsonString != null) {
      return Commission.fromJson(json.decode(jsonString));
    }

    // Default commission if none set
    return Commission(percentage: 5.0, lastUpdated: DateTime.now());
  }

  Future<void> saveCommission(Commission commission) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _commissionKey,
      json.encode(commission.toJson()),
    );
  }
}