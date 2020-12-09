import 'package:GuestInMe/Home/widgets/event_card.dart';
import 'package:GuestInMe/New_Events/new_events_page.dart';
import 'package:GuestInMe/Popular_places/popular_places_page.dart';
import 'package:GuestInMe/models/event_model.dart';
import 'package:GuestInMe/models/place_model.dart';
import 'package:GuestInMe/providers/event_provider.dart';
import 'package:GuestInMe/providers/place_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './widgets/selection_card.dart';
import './widgets/place_card.dart';

class DiamondPage extends StatefulWidget {
  @override
  _DiamondPageState createState() => _DiamondPageState();
}

class _DiamondPageState extends State<DiamondPage> {
  var _init = true;
  var _loadingNewEvents = false;
  var size = Size(0.0, 0.0);

  List<PlaceModel> _places = [];
  List<EventModel> _events = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    if (_init) {
      _places = Provider.of<PlaceProvider>(context).places;
      _events = Provider.of<EventProvider>(context).newEventModels;
    }
    _init = false;
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
              onPressed: () => _title == "New events"
                  ? Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NewEventsPage(),
                      ),
                    )
                  : Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PopularPlacesPage(),
                      ),
                    ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.black,
          expandedHeight: size.height * 0.4,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            background: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/images/logo_white.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          bottom: PreferredSize(
            child: ClipRRect(
              child: Container(
                width: size.width,
                height: 50.0,
                color: const Color(0xFF16161D),
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.0),
              ),
            ),
            preferredSize: Size(size.width, 100.0),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                height: 180.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SelectionCard("Clubs"),
                    SelectionCard("Bars"),
                  ],
                ),
              ),
              heading("New events"),
              _loadingNewEvents
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: 270.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _events.length,
                        itemBuilder: (_, i) {
                          return EventCard(
                            eventModel: _events[i],
                            placeName: _events[i].placeName,
                          );
                        },
                      ),
                    ),
              heading("Popular places"),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext _, int i) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: PlaceCard(placeModel: _places[i]),
              );
            },
            childCount: _places.length == 0 ? 0 : 1,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.purple,
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PopularPlacesPage(),
                      ),
                    ),
                  ),
                  backgroundColor: Colors.white10,
                ),
              ),
              SizedBox(height: 80)
            ],
          ),
        ),
      ],
    );
  }
}
