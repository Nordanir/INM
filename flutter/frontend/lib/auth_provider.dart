import 'package:flutter/foundation.dart';

class AuthenticationProvider extends ChangeNotifier {
  String _email = "";
  String _password = "";
  String _username = "";
  bool _rememberMe = false;
  bool _isLogin = true;
  bool successfulRegistration = false;
  bool successfulLogin = false;

  bool get isLogin => _isLogin;
  String get email => _email;
  String get password => _password;
  String get username => _username;

  AuthenticationProvider({
    String email = "",
    String password = "",
    bool rememberMe = false,
  }) : _email = email,
       _password = password,
       _rememberMe = rememberMe;
  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void updatePassword(String newPassword) {
    _password = newPassword;
    notifyListeners();
  }

  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  void updateUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void toggleLogin() {
    _isLogin = !_isLogin;
    notifyListeners();
  }
}
