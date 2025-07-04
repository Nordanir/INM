import 'package:flutter/foundation.dart';

class FormProvider extends ChangeNotifier {
  String email = "";
  String password = "";
  bool rememberMe = false;

  FormProvider({this.email = "", this.password = "", this.rememberMe = false});
  void updateEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }

  Future<void> init(String newEmail) async {
    email = newEmail;
    notifyListeners();
  }

  void updatePassword(String newPassword) {
    password = newPassword;
    notifyListeners();
  }

  void toggleRememberMe() {
    rememberMe = !rememberMe;
    notifyListeners();
  }
}
