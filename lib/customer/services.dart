import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:namma_savaari/model/city_list.dart';

class CityProvider with ChangeNotifier {
  List<ApiResponse> _cities = [];
  bool _loading = false;
  String? _error;

  List<ApiResponse> get cities => _cities;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchCities() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("https://namma-savaari-api-backend.vercel.app/city-list"),
        headers: {
          "Content-Type": "application/json",
          "Api-Token": "Namma@90434#34",
        },
        body: jsonEncode({
          "ClientId": "180187",
          "UserName": "Namma434",
          "Password": "Namma@4341",
          "EndUserIp": "157.48.136.69"
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(json);

        if (apiResponse.error.errorCode == 0) {
          _cities = apiResponse.result.cityList
              .map((e) => ApiResponse.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          _error = apiResponse.error.errorMessage ?? 'Unknown error';
        }
      } else {
        _error = 'Error ${response.statusCode}: ${response.body}';
      }
    } catch (e) {
      _error = 'Network Error: $e';
    }

    _loading = false;
    notifyListeners();
  }
}
