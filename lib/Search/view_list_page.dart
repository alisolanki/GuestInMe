import 'package:GuestInMe/Home/widgets/event_card.dart';
import 'package:GuestInMe/Home/widgets/place_card.dart';
import 'package:GuestInMe/models/place_model.dart';
import 'package:flutter/material.dart';

class ViewListPage extends StatelessWidget {
  final List items;
  ViewListPage({@required this.items});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: items is List<PlaceModel>
            ? ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: PlaceCard(placeModel: items[i]),
                ),
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: EventCard(
                    eventModel: items[i],
                    placeName: items[i].placeName,
                  ),
                ),
              ),
      ),
    );
  }
}
