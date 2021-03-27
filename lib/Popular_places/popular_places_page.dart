import 'package:guestinme/Home/widgets/place_card.dart';
import 'package:guestinme/models/place_model.dart';
import 'package:guestinme/providers/locations_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularPlacesPage extends StatefulWidget {
  @override
  _PopularPlacesPageState createState() => _PopularPlacesPageState();
}

class _PopularPlacesPageState extends State<PopularPlacesPage> {
  var _init = true;
  LocationsProvider _locationsProvider;
  List<PlaceModel> _places;

  @override
  void didChangeDependencies() {
    if (_init) {
      _locationsProvider = Provider.of<LocationsProvider>(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
      _places = _locationsProvider.places;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF16161D),
        appBar: AppBar(
          title: Text(
            "Places",
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
        ),
        body: ListView.builder(
          itemCount: _places == null ? 0 : _places.length,
          itemBuilder: (_, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: PlaceCard(
                placeModel: _places[i],
              ),
            );
          },
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
      ),
    );
  }
}
