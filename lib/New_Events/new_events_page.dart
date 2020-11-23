import 'package:GuestInMe/Home/widgets/event_card.dart';
import 'package:GuestInMe/models/event_model.dart';
import 'package:GuestInMe/providers/event_provider.dart';
import 'package:GuestInMe/providers/place_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewEventsPage extends StatefulWidget {
  @override
  _NewEventsPageState createState() => _NewEventsPageState();
}

class _NewEventsPageState extends State<NewEventsPage> {
  var _init = true;
  Map<String, List<EventModel>> _datewiseEvents = {};

  @override
  void didChangeDependencies() {
    if (_init) {
      Provider.of<EventProvider>(context).fetchDatewiseEvents();
    }
    _init = false;
    _datewiseEvents = Provider.of<EventProvider>(context).datewiseEvents;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2019),
                      lastDate: DateTime(2022))
                  .then((value) {
                value.month < 10 && value.day < 10
                    ? print("${value.year}0${value.month}0${value.day}")
                    : value.day < 10
                        ? print("${value.year}${value.month}0${value.day}")
                        : value.month < 10
                            ? print("${value.year}0${value.month}${value.day}")
                            : print("${value.year}${value.month}${value.day}");
              }),
            )
          ],
          title: Text("New Events"),
          backgroundColor: const Color(0xFF892CDC),
        ),
        body: ListView.builder(
          itemCount: _datewiseEvents.length,
          itemBuilder: (_, i) {
            String key = _datewiseEvents.keys.elementAt(i);
            return Column(
              children: [
                Text(key),
                Container(
                  height: 270.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _datewiseEvents[key]?.length,
                    itemBuilder: (_, j) {
                      return EventCard(
                        eventModel: _datewiseEvents[key][j],
                        placeName: _datewiseEvents[key][j].placeName,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
