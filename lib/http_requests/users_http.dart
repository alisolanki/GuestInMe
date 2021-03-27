import 'dart:convert';

import 'package:guestinme/models/user_model.dart';

import '../auth/auth.dart' as auth;
import 'package:http/http.dart' as http;

class UsersHttp {
  Future<void> pushUserData(UserModel _user) {
    final String userUrl =
        "${auth.url}users/${_user.phoneNumber}.json?auth=${auth.token}";
    var _data = jsonEncode({
      "name": _user.name,
      "dob": _user.dateOfBirth,
      "mail": _user.email,
      "frequency": _user.frequency,
      "place": _user.place,
    });
    return http.put(userUrl, body: _data);
  }
}
