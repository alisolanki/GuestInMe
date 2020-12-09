import 'dart:convert';

import 'package:GuestInMe/models/event_model.dart';
import 'package:GuestInMe/models/place_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/auth.dart' as auth;

class PlaceProvider extends ChangeNotifier {
  List<PlaceModel> _places = [];

  List<PlaceModel> get places {
    return _places;
  }

  Future<void> fetchPlaces() {
    final String placeUrl = "${auth.url}place.json?auth=${auth.token}";

    if (_places.length == 0) {
      return http.get(placeUrl).then((value) {
        var _extractedData = jsonDecode(value.body) as Map<String, dynamic>;
        _extractedData.forEach((_placeName, _details) {
          var _events = _details['events'] as Map<String, dynamic>;
          List<EventModel> events = [];
          _events != null
              ? _events.forEach((_event, _eventDetail) {
                  List<PriceModel> prices = [];
                  var _price = _eventDetail['price'] as Map<String, dynamic>;
                  _price != null
                      ? _price.forEach((_type, _typeDetail) {
                          List<TypeModel> typeModelList = [];
                          _typeDetail != null
                              ? _typeDetail
                                  .forEach((_typeName, _typeSubDetail) {
                                  var typeModel = TypeModel(
                                    typeName: _typeName.toString(),
                                    description: _typeSubDetail['description']
                                        .toString(),
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
                    ageLimit: _eventDetail['agelimit'].toString(),
                    date: _eventDetail['date'].toString(),
                    description: _eventDetail['description'].toString(),
                    dressCode: _eventDetail['dresscode'].toString(),
                    eventName: _event.toString(),
                    image: _eventDetail['image'].toString(),
                    lineup: _eventDetail['lineup'].toString(),
                    prices: prices,
                    time: _eventDetail['time'].toString(),
                    placeName: _eventDetail['placename'].toString(),
                  );
                  events.add(_eventModel);
                })
              : null;
          var _placeModel = PlaceModel(
            description: _details['description'],
            event: events,
            images: _details['images'],
            location: _details['location'],
            menu: _details['menu'],
            placeName: _placeName,
            stars: double.parse("${_details['stars']}"),
            logo: _details['logo'],
            category: _details['category'],
          );
          _places.add(_placeModel);
        });
      }).then((_) {
        print("This is final: ${places[0].images[0]}");
        notifyListeners();
      }).catchError((e) {
        print(e);
      });
    } else {
      print("place data of length: ${_places.length} already fetched.");
      notifyListeners();
    }
  }
}
