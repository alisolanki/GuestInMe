import 'package:flutter/material.dart';

class RegistrationModel {
  final List<DateModel> dateModels;
  RegistrationModel({
    @required this.dateModels,
  });
}

class DateModel {
  final String date;
  final List<PlaceRegistrationModel> placeRegistrationModels;
  DateModel({
    @required this.date,
    @required this.placeRegistrationModels,
  });
}

class PlaceRegistrationModel {
  final String placeName;
  final List<EventRegistrationModel> eventRegistrationModels;
  PlaceRegistrationModel({
    @required this.placeName,
    @required this.eventRegistrationModels,
  });
}

class EventRegistrationModel {
  final String id, eventName;
  final List<UserRegistrationModel> userRegistrationModels;
  EventRegistrationModel({
    @required this.id,
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
  final String id, typeName, userName;
  String takenBy;
  final double typePrice;
  final int code, quantity;
  bool paid, entered;
  TypeRegistrationModel({
    @required this.id,
    @required this.typeName,
    @required this.typePrice,
    @required this.code,
    @required this.paid,
    @required this.userName,
    @required this.quantity,
    this.entered,
    this.takenBy,
  });
}
