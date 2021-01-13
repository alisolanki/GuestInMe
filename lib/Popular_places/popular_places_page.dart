import 'package:GuestInMe/Home/widgets/place_card.dart';
import 'package:GuestInMe/models/place_model.dart';
import 'package:GuestInMe/providers/place_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularPlacesPage extends StatefulWidget {
  @override
  _PopularPlacesPageState createState() => _PopularPlacesPageState();
}

class _PopularPlacesPageState extends State<PopularPlacesPage> {
  var _init = true;
  PlaceProvider _placeProvider;
  List<PlaceModel> _places;

  @override
  void didChangeDependencies() {
    if (_init) {
      _placeProvider = Provider.of<PlaceProvider>(context);
      _placeProvider.fetchPlaces();
      _places = _placeProvider.places;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF16161D),
        appBar: AppBar(
          title: Text("Places"),
          backgroundColor: const Color(0xFF892CDC),
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
