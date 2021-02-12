import 'package:flutter/material.dart';

class EventModel {
  final String id,
      eventName,
      description,
      image,
      date,
      dressCode,
      ageLimit,
      time,
      placeName,
      lineup;
  final bool closeOnline, closeOffline;
  final List<PriceModel> prices;
  EventModel({
    this.id,
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
    @required this.closeOnline,
    @required this.closeOffline,
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
  String id, typeName, description, price;
  TypeModel({
    this.id,
    this.description,
    this.price,
    this.typeName,
  });
}
