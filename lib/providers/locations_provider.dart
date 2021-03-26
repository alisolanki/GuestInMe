import 'dart:convert';

import 'package:GuestInMe/models/event_model.dart';
import 'package:GuestInMe/models/place_model.dart';
import 'package:flutter/material.dart';
import '../auth/auth.dart' as auth;
import 'package:http/http.dart' as http;

class LocationsProvider with ChangeNotifier {
  List<dynamic> _locations;
  String _selectedLocation;
  List<PlaceModel> _places = [];
  List<EventModel> _newEventModels = [];
  Map<String, List<EventModel>> _datewiseEventsMap = {};

  List<dynamic> get locations => _locations;
  String get selectedLocation => _selectedLocation;
  List<PlaceModel> get places => _places;
  List<EventModel> get newEventModels => _newEventModels;
  Map<String, List<EventModel>> get datewiseEvents => _datewiseEventsMap;

  //locations
  Future fetchLocations() async {
    final _locationsUrl = "${auth.url}locations.json?auth=${auth.token}";
    final _response = await http.get(_locationsUrl);
    print("_response:${_response.body}");
    final _decodedData = jsonDecode(_response.body) as List<dynamic>;
    print("locations: $_decodedData");
    _locations = _decodedData;
    setSelectedLocation(_locations[0]);
    notifyListeners();
  }

  void setSelectedLocation(String locationName) {
    _selectedLocation = locationName;
    print("_selectedLocation: $_selectedLocation");
    notifyListeners();
    fetchPlaces(location: _selectedLocation);
    fetchNewEvents(location: _selectedLocation);
    fetchDatewiseEvents(location: _selectedLocation);
    notifyListeners();
  }

  //places
  Future<void> fetchPlaces({@required String location}) async {
    if (location != null) {
      final String placeUrl =
          "${auth.url}$location/place.json?auth=${auth.token}";
      _places = [];
      print("fetching places");
      return http.get(placeUrl).then((value) {
        var _extractedData = jsonDecode(value.body) as Map<String, dynamic>;
        _extractedData?.forEach((_placeName, _details) {
          var _events = _details['events'] as Map<String, dynamic>;
          List<EventModel> events = [];
          _events != null
              ? _events.forEach((_eventId, _eventDetail) {
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
                    closeOnline:
                        _eventDetail['closeOnline'].toString().toLowerCase() ==
                            "true",
                    closeOffline:
                        _eventDetail['closeOffline'].toString().toLowerCase() ==
                            "true",
                  );
                  events.add(_eventModel);
                })
              : null;
          var _placeModel = PlaceModel(
            description: _details['description'],
            event: events,
            images: _details['images'],
            address: _details['address'],
            menu: _details['menu'] as List<dynamic>,
            placeName: _placeName,
            stars: double.parse("${_details['stars']}"),
            logo: _details['logo'],
            category: _details['category'],
          );
          _places.add(_placeModel);
        });
        notifyListeners();
      }).then((_) {
        notifyListeners();
      }).catchError((e) {
        print(e);
      });
    } else {
      print("Locations is null in locations provider");
      notifyListeners();
    }
  }

  //events
  Future<void> fetchNewEvents({@required String location}) async {
    final String newEventUrl =
        "${auth.url}$location/newEvents.json?auth=${auth.token}";
    _newEventModels = [];
    print("_newEventModels.length: ${_newEventModels.length}");
    await http.get(newEventUrl).then((value) {
      var _extractedData = jsonDecode(value.body) as Map<String, dynamic>;
      _extractedData?.forEach((_eventId, _eventDetail) {
        List<PriceModel> prices = [];
        var _price = _eventDetail['price'] as Map<String, dynamic>;
        _price != null
            ? _price.forEach((_type, _typeDetail) {
                List<TypeModel> typeModelList = [];
                _typeDetail != null
                    ? _typeDetail.forEach((_typeName, _typeSubDetail) {
                        var typeModel = TypeModel(
                          typeName: _typeName.toString(),
                          description: _typeSubDetail['description'].toString(),
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
          closeOnline:
              _eventDetail['closeOnline'].toString().toLowerCase() == "true",
          closeOffline:
              _eventDetail['closeOffline'].toString().toLowerCase() == "true",
        );
        _newEventModels.add(_eventModel);
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> fetchDatewiseEvents({@required String location}) async {
    final String datewiseEventsUrl =
        "${auth.url}$location/datewiseEvents.json?auth=${auth.token}";
    _datewiseEventsMap = {};
    print("_datewiseEvents.length: ${_datewiseEventsMap.length}");
    await http.get(datewiseEventsUrl).then((value) {
      var _extractedData = jsonDecode(value.body) as Map<String, dynamic>;

      _extractedData?.forEach((_date, _eventModel) {
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
            closeOnline:
                _eventDetail['closeOnline'].toString().toLowerCase() == "true",
            closeOffline:
                _eventDetail['closeOffline'].toString().toLowerCase() == "true",
          );
          if (_datewiseEventsMap[_date] == null) {
            _datewiseEventsMap[_date] = [];
          }
          _datewiseEventsMap[_date].add(_eventModel);
        });
      });
      notifyListeners();
    }).catchError((e) {
      print(e);
    });
  }
}
