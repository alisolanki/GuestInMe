import 'dart:convert';

import 'package:guestinme/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/auth.dart' as auth;

class UserProvider extends ChangeNotifier {
  UserModel _userModel;
  var _user = FirebaseAuth.instance.currentUser;

  var _ownerStatus = false;

  bool get ownerStatus => _ownerStatus;

  UserModel get userModel {
    return _userModel;
  }

  Future<void> fetchUser({bool forced = false}) async {
    final String _userURL =
        "${auth.url}users/${_user.phoneNumber}.json?auth=${auth.token}";
    final String _ownersURL = "${auth.url}owners.json?auth=${auth.token}";

    if (_userModel == null || forced) {
      var _r = await http.get(_ownersURL);
      var _e = jsonDecode(_r.body) as Map<String, dynamic>;
      print(_e['${_user.phoneNumber}']);
      if (_e['${_user.phoneNumber}'] != null) {
        _ownerStatus = true;
        notifyListeners();
      }

      return http.get(_userURL).then((value) {
        var _extractedData = jsonDecode(value.body) as Map<String, dynamic>;
        print("Fetching user");
        if (value.body != "null") {
          _userModel = UserModel(
            phoneNumber: _user.phoneNumber,
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
    } else {
      print("User Fetched");
    }
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
