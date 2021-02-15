import 'package:GuestInMe/models/event_model.dart';
import 'package:flutter/material.dart';

class PlaceModel {
  String placeName, description, address, logo, category;
  List<dynamic> images, menu;
  double stars;
  List<EventModel> event;
  PlaceModel({
    @required this.placeName,
    @required this.description,
    @required this.address,
    this.event,
    @required this.images,
    @required this.menu,
    @required this.stars,
    @required this.logo,
    @required this.category,
  });
}
