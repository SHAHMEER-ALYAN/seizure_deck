
import 'package:flutter/material.dart';

import '../data/user_data.dart';

class UserProvider with ChangeNotifier{

  User? _user;

  User? get user => _user;

  int? get uid => user?.uid;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

}