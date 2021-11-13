import 'package:flutter/foundation.dart';

class UserContext with ChangeNotifier {
  Map? _user;

  setUser(Map user) {
    _user = user;
  }

  getUser() => _user;
}
