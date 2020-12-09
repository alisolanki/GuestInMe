import 'package:flutter/material.dart';

class EventModel {
  final String eventName,
      description,
      image,
      date,
      dressCode,
      ageLimit,
      time,
      placeName,
      lineup;
  final List<PriceModel> prices;
  EventModel({
    @required this.eventName,
    @required this.description,
    @required this.date,
    @required this.prices,
    @required this.image,
    @required this.lineup,
    @required this.ageLimit,
    @required this.dressCode,
    @required this.time,
    @required this.placeName,
  });
}

class PriceModel {
  String type;
  List<TypeModel> typeData;
  PriceModel({
    this.type,
    this.typeData,
  });
}

class TypeModel {
  String typeName, description, price;
  TypeModel({
    this.description,
    this.price,
    this.typeName,
  });
}
