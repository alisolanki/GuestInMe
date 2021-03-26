import 'package:GuestInMe/models/event_model.dart';
import 'package:flutter/material.dart';

class AddEventModel {
  final Map<String, dynamic> eventTemplate;
  final List<TypeModel> tableTemplate;
  final List<TypeModel> crowdTemplate;
  AddEventModel({
    @required this.eventTemplate,
    @required this.crowdTemplate,
    @required this.tableTemplate,
  });
}

class TypeContModel {
  final TextEditingController typeName, description, price;
  TypeContModel({
    this.typeName,
    this.description,
    this.price,
  });
}
