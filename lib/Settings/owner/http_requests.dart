import 'dart:convert';

import 'package:GuestInMe/models/place_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:GuestInMe/models/event_model.dart';
import 'package:GuestInMe/auth/auth.dart' as auth;

class TransferData {
  String convertDate(DateTime value) {
    String _datePicked, _month, _weekday;

    // Month
    switch (value.month) {
      case 1:
        _month = "Jan";
        break;
      case 2:
        _month = "Feb";
        break;
      case 3:
        _month = "Mar";
        break;
      case 4:
        _month = "Apr";
        break;
      case 5:
        _month = "May";
        break;
      case 6:
        _month = "Jun";
        break;
      case 7:
        _month = "Jul";
        break;
      case 8:
        _month = "Aug";
        break;
      case 9:
        _month = "Sep";
        break;
      case 10:
        _month = "Oct";
        break;
      case 11:
        _month = "Nov";
        break;
      case 12:
        _month = "Dec";
        break;
      default:
        break;
    }
    //weekday
    switch (value.weekday) {
      case 1:
        _month = "Mon";
        break;
      case 2:
        _month = "Tue";
        break;
      case 3:
        _month = "Wed";
        break;
      case 4:
        _month = "Thu";
        break;
      case 5:
        _month = "Fri";
        break;
      case 6:
        _month = "Sat";
        break;
      case 7:
        _month = "Sun";
        break;
      default:
        break;
    }
    _datePicked = "$_weekday ${value.day}, $_month ${value.year}";
    print("Date: $_datePicked");
    return _datePicked;
  }

  Future<void> addEvent({
    @required EventModel eventModel,
    @required DateTime date,
    @required bool newEvent,
  }) async {
    final String _date = convertDate(date);
    //urls
    var _eventPlaceUrl =
        "${auth.url}place/${eventModel.placeName}/events/${eventModel.eventName}.json?auth=${auth.token}";
    var _eventDatewiseUrl =
        "${auth.url}datewiseEvents/$_date/${eventModel.eventName}.json?auth=${auth.token}";
    var _eventNewUrl =
        "${auth.url}newEvents/${eventModel.eventName}.json?auth=${auth.token}";

    var _priceModelList = eventModel.prices;
    //crowd
    var _jsonCrowdDetails = [
      {
        'description': '${_priceModelList[0].typeData[0].description}',
        'price': '${_priceModelList[0].typeData[0].price}'
      },
      {
        'description': '${_priceModelList[0].typeData[1].description}',
        'price': '${_priceModelList[0].typeData[1].price}'
      },
      {
        'description': '${_priceModelList[0].typeData[2].description}',
        'price': '${_priceModelList[0].typeData[2].price}'
      },
    ];
    var _jsonCrowd = {
      '${_priceModelList[0].typeData[0].typeName}': _jsonCrowdDetails[0],
      '${_priceModelList[0].typeData[1].typeName}': _jsonCrowdDetails[1],
      '${_priceModelList[0].typeData[2].typeName}': _jsonCrowdDetails[2],
    };
    //tables
    var _jsonTable = {};
    _priceModelList[1].typeData.forEach(
          (e) => _jsonTable.putIfAbsent(
            e.typeName,
            () => {'description': '${e.description}', 'price': '${e.price}'},
          ),
        );
    var _jsonPrice = {
      '${_priceModelList[0].type}': _jsonCrowd,
      '${_priceModelList[1].type}': _jsonTable,
    };

    var _encodedBody = jsonEncode({
      'agelimit': eventModel.ageLimit,
      'date': _date,
      'description': eventModel.description,
      'dresscode': eventModel.dressCode,
      'image': eventModel.image,
      'lineup': eventModel.lineup,
      'placename': eventModel.placeName,
      'price': _jsonPrice,
      'time': eventModel.time,
    });
    await http.put(_eventPlaceUrl,
        body: _encodedBody,
        headers: {"Accept": "application/json"}).then((result) {
      print(result.statusCode);
      print(result.body);
    });
    await http.put(_eventDatewiseUrl,
        body: _encodedBody,
        headers: {"Accept": "application/json"}).then((result) {
      print(result.statusCode);
      print(result.body);
    });
    if (newEvent) {
      await http.put(_eventNewUrl,
          body: _encodedBody,
          headers: {"Accept": "application/json"}).then((result) {
        print(result.statusCode);
        print(result.body);
      });
    }
  }

  Future<void> addPlace({
    @required PlaceModel placeModel,
  }) async {
    //urls
    var _placeUrl =
        "${auth.url}place/${placeModel.placeName}.json?auth=${auth.token}";

    var _encodedBody = jsonEncode({
      'category': placeModel.category,
      'description': placeModel.description,
      'images': placeModel.images as List<String>,
      'location': placeModel.location,
      'logo': placeModel.logo,
      'menu': placeModel.menu as List<String>,
      'stars': placeModel.stars,
    });
    await http.patch(_placeUrl,
        body: _encodedBody,
        headers: {"Accept": "application/json"}).then((result) {
      print(result.statusCode);
      print(result.body);
    });
  }
}
