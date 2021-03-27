import 'package:guestinme/Home/widgets/event_card.dart';
import 'package:guestinme/Home/widgets/place_card.dart';
import 'package:guestinme/Search/view_list_page.dart';
import 'package:guestinme/models/event_model.dart';
import 'package:guestinme/providers/locations_provider.dart';
import 'package:flutter/cupertino.dart';

import '../models/place_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _init = true;
  var _loadingSearch = false;
  List<PlaceModel> _clubsList = [];
  List<PlaceModel> _barsList = [];
  List<EventModel> _eventsList = [];
  String _searchTerm = "";
  List<PlaceModel> _places;

  @override
  void didChangeDependencies() {
    if (_init) {
      var _locationsProvider = Provider.of<LocationsProvider>(context);
      _places = _locationsProvider.places;
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 36.0,
              right: 18.0,
              left: 18.0,
              bottom: 18.0,
            ),
            child: TextField(
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
              ),
              cursorColor: Colors.white10,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  color: const Color(0xEEC97CFF),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: const Color(0xEEC97CFF),
                ),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onSubmitted: (value) {
                setState(() {
                  _searchTerm = value.toLowerCase();
                  //nulify
                  _clubsList = [];
                  _barsList = [];
                  _eventsList = [];
                  _clubsList = _places.where((placeModel) {
                    return placeModel.placeName
                            .toLowerCase()
                            .contains(_searchTerm) &&
                        placeModel.category == "clubs" || placeModel.category == "hybrid";
                  }).toList();
                  _barsList = _places.where((placeModel) {
                    return placeModel.placeName
                            .toLowerCase()
                            .contains(_searchTerm) &&
                        placeModel.category == "bars" || placeModel.category == "hybrid";
                  }).toList();
                  _places.forEach((placeModel) {
                    placeModel.event.forEach((eventModel) => eventModel
                                .eventName
                                .toLowerCase()
                                .contains(_searchTerm) ||
                            eventModel.lineup
                                .toLowerCase()
                                .contains(_searchTerm)
                        ? _eventsList.add(eventModel)
                        : null);
                  });
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Search for Club, Bar, Event or Artist",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12.0,
              ),
            ),
          ),
          _searchTerm != ""
              ? Expanded(
                  child: ListView(
                    children: [
                      heading("Events"),
                      SizedBox(
                        height: _eventsList.length == 0 ? 10.0 : 270.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _eventsList.length,
                          itemBuilder: (_, i) {
                            return EventCard(
                              eventModel: _eventsList[i],
                              placeName: _eventsList[i].placeName,
                            );
                          },
                        ),
                      ),
                      heading("Clubs"),
                      SizedBox(
                        height: _clubsList.length == 0 ? 10.0 : 270.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _clubsList.length,
                          itemBuilder: (_, i) {
                            return PlaceCard(placeModel: _clubsList[i]);
                          },
                        ),
                      ),
                      heading("Bars"),
                      SizedBox(
                        height: _barsList.length == 0 ? 10.0 : 270.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _barsList.length,
                          itemBuilder: (_, i) {
                            return PlaceCard(placeModel: _barsList[i]);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 100.0,
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 100.0,
                ),
        ],
      ),
    );
  }

  Widget heading(String _title) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$_title",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.purple,
            ),
            onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (_) => ViewListPage(
                    items: _title == "Events"
                        ? _eventsList
                        : _title == "Clubs"
                            ? _clubsList
                            : _barsList),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
