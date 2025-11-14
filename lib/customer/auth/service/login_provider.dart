import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLogin = false;

  bool get isLogin => _isLogin;

  void setLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  Future<void> createLogin() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool("isLogin", true);
    _isLogin = true;
    notifyListeners();
  }

  Future<void> handleLocalAuth() async {
    final pref = await SharedPreferences.getInstance();
    _isLogin = pref.getBool("isLogin") ?? false;
    notifyListeners();
  }
}
