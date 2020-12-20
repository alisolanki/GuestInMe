import 'dart:convert';

import 'package:GuestInMe/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/auth.dart' as auth;

class UserProvider extends ChangeNotifier {
  UserModel _userModel;
  var _user = FirebaseAuth.instance.currentUser;

  UserModel get userModel {
    return _userModel;
  }

  Future<void> fetchUser() {
    final String _userURL =
        "${auth.url}users/${_user.phoneNumber}.json?auth=${auth.token}";

    if (_userModel == null) {
      print("_userModel is null");
      return http.get(_userURL).then((value) {
        var _extractedData = jsonDecode(value.body) as Map<String, dynamic>;
        if (value.body != "null") {
          _userModel = UserModel(
            phoneNumber: "${_user.phoneNumber}",
            name: _extractedData['name'],
            gender: _extractedData['gender'],
            email: _extractedData['email'],
            frequency: _extractedData['frequency'],
            place: _extractedData['place'],
            dateOfBirth: _extractedData['dob'],
          );
        } else {
          _userModel = UserModel(
            phoneNumber: "${_user.phoneNumber}",
            name: "Enter name",
            gender: "male",
            email: "name@mail.com",
            frequency: "null",
            place: "Mumbai",
            dateOfBirth: "19900101",
          );
        }
        notifyListeners();
      });
    }
    notifyListeners();
  }

  Future<void> putUser(UserModel _putUser) {
    _userModel = _putUser;
    notifyListeners();
    final String _userURL =
        "${auth.url}users/${_user.phoneNumber}.json?auth=${auth.token}";
    String _encodedData = jsonEncode({
      'name': _putUser.name,
      'gender': _putUser.gender,
      'email': _putUser.email,
      'place': _putUser.place,
      'frequency': _putUser.frequency,
      'dob': _putUser.dateOfBirth,
    });
    return http.put(_userURL,
        body: _encodedData,
        headers: {"Accept": "application/json"}).then((result) {
      print(result.statusCode);
    });
  }
}
