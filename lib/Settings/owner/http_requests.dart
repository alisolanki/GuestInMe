import 'dart:convert';

import 'package:GuestInMe/models/place_model.dart';
import 'package:GuestInMe/models/registration_model.dart';
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
        _weekday = "Mon";
        break;
      case 2:
        _weekday = "Tue";
        break;
      case 3:
        _weekday = "Wed";
        break;
      case 4:
        _weekday = "Thu";
        break;
      case 5:
        _weekday = "Fri";
        break;
      case 6:
        _weekday = "Sat";
        break;
      case 7:
        _weekday = "Sun";
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
    final String _datePicked = convertDate(date);
    //urls
    var _eventPlaceUrl =
        "${auth.url}place/${eventModel.placeName}/events.json?auth=${auth.token}";
    var _eventDatewiseUrl =
        "${auth.url}datewiseEvents/${eventModel.date}.json?auth=${auth.token}";
    var _eventNewUrl = "${auth.url}newEvents.json?auth=${auth.token}";

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
      'date': _datePicked,
      'description': eventModel.description,
      'dresscode': eventModel.dressCode,
      'eventName': eventModel.eventName,
      'image': eventModel.image,
      'lineup': eventModel.lineup,
      'placename': eventModel.placeName,
      'price': _jsonPrice,
      'time': eventModel.time,
    });
    await http.post(_eventPlaceUrl,
        body: _encodedBody,
        headers: {"Accept": "application/json"}).then((result) {
      print(result.statusCode);
      print(result.body);
    });
    await http.post(_eventDatewiseUrl,
        body: _encodedBody,
        headers: {"Accept": "application/json"}).then((result) {
      print(result.statusCode);
      print(result.body);
    });
    if (newEvent) {
      await http.post(_eventNewUrl,
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

  Future<void> changeEntranceState({
    @required String date,
    @required String userNumber,
    @required String placeName,
    @required String eventName,
    @required String eventId,
    @required TypeRegistrationModel typeModel,
  }) async {
    final _paidUrl =
        "${auth.url}registrations/$date/$placeName/$eventId/$eventName/$userNumber/${typeModel.id}.json?auth=${auth.token}";
    await http.patch(_paidUrl,
        body: json.encode({
          'paid': '${typeModel.paid}',
        }),
        headers: {"Accept": "application/json"}).then((result) {
      print(result.statusCode);
      print(result.body);
    });
  }

  Future<RegistrationModel> getEntranceState() async {
    final String _registrationUrl =
        "${auth.url}registrations.json?auth=${auth.token}";
    List<TypeRegistrationModel> _typeModels = [];
    List<UserRegistrationModel> _userModels = [];
    List<EventRegistrationModel> _eventModels = [];
    List<PlaceRegistrationModel> _placeModels = [];
    List<DateModel> _dateModels = [];
    RegistrationModel _registrationModel;

    await http.get(_registrationUrl).then((res) {
      var _extractedData = json.decode(res.body) as Map<String, dynamic>;
      _extractedData.forEach((_date, _details) {
        var _placeDetails = _details as Map<String, dynamic>;
        _placeDetails.forEach((_placeName, _details0) {
          var _eventDetails = _details0 as Map<String, dynamic>;
          _eventDetails.forEach((_eventId, _details1) {
            var _eventNameDetails = _details1 as Map<String, dynamic>;
            print(_details1.toString());
            _eventNameDetails.forEach((_eventName, _details2) {
              print(_details2.toString());
              var _userDetails = _details2 as Map<String, dynamic>;
              _userDetails.forEach((_phoneNumber, _details3) {
                print(_details3.toString());
                var _type = _details3 as Map<String, dynamic>;
                _type.forEach((_typeId, _details4) {
                  _typeModels.add(
                    TypeRegistrationModel(
                      id: _typeId.toString(),
                      typeName: _details4['typeName'],
                      typePrice: double.parse(_details4['price'].toString()),
                      code: int.parse(_details4['code'].toString()),
                      paid:
                          _details4['paid'].toString().toLowerCase() == "true",
                      userName: _details4['name'],
                    ),
                  );
                });
                _userModels.add(
                  UserRegistrationModel(
                    phoneNumber: _phoneNumber,
                    typeRegistrationModels: _typeModels,
                  ),
                );
                _typeModels = [];
              });
              _eventModels.add(
                EventRegistrationModel(
                  id: _eventId.toString(),
                  eventName: _eventName,
                  userRegistrationModels: _userModels,
                ),
              );
              _userModels = [];
            });
          });
          _placeModels.add(
            PlaceRegistrationModel(
              placeName: _placeName,
              eventRegistrationModels: _eventModels,
            ),
          );
          _eventModels = [];
        });
        _dateModels.add(
          DateModel(
            date: _date,
            placeRegistrationModels: _placeModels,
          ),
        );
        _placeModels = [];
      });
      _registrationModel = RegistrationModel(dateModels: _dateModels);
      print("Fetched Registration Model");
    });
    return _registrationModel;
  }
}
