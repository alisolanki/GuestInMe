import 'package:flutter/material.dart';

class UserModel {
  //TODO: check for place, frequency datatype
  final String phoneNumber, name, email, place, frequency, gender, dateOfBirth;
  UserModel({
    @required this.name,
    @required this.gender,
    @required this.phoneNumber,
    @required this.email,
    @required this.frequency,
    @required this.place,
    @required this.dateOfBirth,
  });
}
