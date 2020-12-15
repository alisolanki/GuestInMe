import 'package:flutter/material.dart';

class RegistrationModel {
  final List<DateModel> dateModels;
  RegistrationModel({
    @required this.dateModels,
  });
}

class DateModel {
  final String date;
  final List<EventRegistrationModel> eventRegistrationModels;
  DateModel({
    @required this.date,
    @required this.eventRegistrationModels,
  });
}

class EventRegistrationModel {
  final String eventName;
  final List<UserRegistrationModel> userRegistrationModels;
  EventRegistrationModel({
    @required this.eventName,
    @required this.userRegistrationModels,
  });
}

class UserRegistrationModel {
  final String phoneNumber;
  final List<TypeRegistrationModel> typeRegistrationModels;
  UserRegistrationModel({
    @required this.phoneNumber,
    @required this.typeRegistrationModels,
  });
}

class TypeRegistrationModel {
  final String typeName, userName;
  final double typePrice;
  final int code;
  bool paid;
  TypeRegistrationModel({
    @required this.typeName,
    @required this.typePrice,
    @required this.code,
    @required this.paid,
    @required this.userName,
  });
}
