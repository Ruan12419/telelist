import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  String userId = '';
  String username;
  String password;

  User(this.username, this.password);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['username'], json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }

  void setUser(User user) {
    username = user.username;
    password = user.password;
    userId = user.userId;
    notifyListeners();
  }

  void setUsername(String username) {
    this.username = username;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }
}
