import 'dart:convert';

import 'package:GuestInMe/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/auth.dart' as auth;

class EventProvider extends ChangeNotifier {
  List<EventModel> _newEventModels = [];
  Map<String, List<EventModel>> _datewiseEventsMap =
      Map<String, List<EventModel>>();

  List<EventModel> get newEventModels {
    return _newEventModels;
  }

  Map<String, List<EventModel>> get datewiseEvents {
    return _datewiseEventsMap;
  }

  Future<void> fetchNewEvents() {
    final String newEventUrl = "${auth.url}newEvents.json?auth=${auth.token}";

    if (_newEventModels.length == 0) {
      print("_newEventModels.length: ${_newEventModels.length}");
      return http.get(newEventUrl).then((value) {
        var _extractedData = jsonDecode(value.body) as Map<String, dynamic>;
        _extractedData.forEach((_eventId, _eventDetail) {
          List<PriceModel> prices = [];
          var _price = _eventDetail['price'] as Map<String, dynamic>;
          _price != null
              ? _price.forEach((_type, _typeDetail) {
                  List<TypeModel> typeModelList = [];
                  _typeDetail != null
                      ? _typeDetail.forEach((_typeName, _typeSubDetail) {
                          var typeModel = TypeModel(
                            typeName: _typeName.toString(),
                            description:
                                _typeSubDetail['description'].toString(),
                            price: _typeSubDetail['price'].toString(),
                          );
                          typeModelList.add(typeModel);
                        })
                      : null;
                  var priceModel = PriceModel(
                    type: _type,
                    typeData: typeModelList,
                  );
                  prices.add(priceModel);
                })
              : null;
          var _eventModel = EventModel(
            id: _eventId,
            ageLimit: _eventDetail['agelimit'].toString(),
            date: _eventDetail['date'].toString(),
            description: _eventDetail['description'].toString(),
            dressCode: _eventDetail['dresscode'].toString(),
            eventName: _eventDetail['eventName'].toString(),
            image: _eventDetail['image'].toString(),
            lineup: _eventDetail['lineup'].toString(),
            prices: prices,
            time: _eventDetail['time'].toString(),
            placeName: _eventDetail['placename'].toString(),
            closed: _eventDetail['closed'].toString().toLowerCase() == "true",
          );
          _newEventModels.add(_eventModel);
        });
      }).then((_) {
        notifyListeners();
      }).catchError((e) {
        print(e);
      });
    } else {
      print(
          "newEvents data of length: ${_newEventModels.length} already fetched.");
      notifyListeners();
    }
  }

  Future<void> fetchDatewiseEvents() {
    final String datewiseEventsUrl =
        "${auth.url}datewiseEvents.json?auth=${auth.token}";

    if (_datewiseEventsMap.length == 0) {
      print("_datewiseEvents.length: ${_datewiseEventsMap.length}");
      return http.get(datewiseEventsUrl).then((value) {
        var _extractedData = jsonDecode(value.body) as Map<String, dynamic>;

        _extractedData.forEach((_date, _eventModel) {
          _eventModel.forEach((_eventId, _eventDetail) {
            List<PriceModel> prices = [];
            var _price = _eventDetail['price'] as Map<String, dynamic>;
            _price != null
                ? _price.forEach((_type, _typeDetail) {
                    List<TypeModel> typeModelList = [];
                    _typeDetail != null
                        ? _typeDetail.forEach((_typeName, _typeSubDetail) {
                            var typeModel = TypeModel(
                              typeName: _typeName.toString(),
                              description:
                                  _typeSubDetail['description'].toString(),
                              price: _typeSubDetail['price'].toString(),
                            );
                            typeModelList.add(typeModel);
                          })
                        : null;
                    var priceModel = PriceModel(
                      type: _type,
                      typeData: typeModelList,
                    );
                    prices.add(priceModel);
                  })
                : null;
            var _eventModel = EventModel(
              id: _eventId,
              ageLimit: _eventDetail['agelimit'].toString(),
              date: _eventDetail['date'].toString(),
              description: _eventDetail['description'].toString(),
              dressCode: _eventDetail['dresscode'].toString(),
              eventName: _eventDetail['eventName'].toString(),
              image: _eventDetail['image'].toString(),
              lineup: _eventDetail['lineup'].toString(),
              prices: prices,
              time: _eventDetail['time'].toString(),
              placeName: _eventDetail['placename'].toString(),
              closed: _eventDetail['closed'].toString().toLowerCase() == "true",
            );
            if (_datewiseEventsMap[_date] == null) {
              _datewiseEventsMap[_date] = [];
            }
            _datewiseEventsMap[_date].add(_eventModel);
          });
        });
      }).then((_) {
        print(
            "This is final length of datewise data: ${_datewiseEventsMap['20201106'].length}");
        notifyListeners();
      }).catchError((e) {
        print(e);
      });
    } else {
      print(
          "datewiseEvents data of length: ${_datewiseEventsMap.length} already fetched.");
      notifyListeners();
    }
  }
}
