import 'dart:convert';

import 'package:flutter/material.dart';
import '../auth/auth.dart' as auth;
import 'package:http/http.dart' as http;

class LocationsProvider with ChangeNotifier {
  List<dynamic> _locations;
  String _selectedLocation;

  List<dynamic> get locations => _locations;
  String get selectedLocation => _selectedLocation;

  Future fetchLocations() async {
    final _locationsUrl = "${auth.url}locations.json?auth=${auth.token}";
    final _response = await http.get(_locationsUrl);
    final _decodedData = jsonDecode(_response.body) as List<dynamic>;
    print("locations: $_decodedData");
    _locations = _decodedData;
    notifyListeners();
  }

  void setSelectedLocation(String locationName) {
    _selectedLocation = locationName;
    notifyListeners();
  }
}
