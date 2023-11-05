import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  String _username = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  Map<String, String> _registeredUsers = {};

  String get username => _username;
  String get password => _password;
  String get firstName => _firstName;
  String get lastName => _lastName;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setFirstName(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  void setLastName(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  void registerUser(
      String username, String password, String firstName, String lastName) {
    _registeredUsers[username] = password;
    _firstName = firstName;
    _lastName = lastName;
  }

  bool isUserRegistered(String username, String password) {
    return _registeredUsers[username] == password;
  }
}
