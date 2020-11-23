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
  Map<String, List<EventModel>> _datewiseExtracted = {};

  @override
  void didChangeDependencies() {
    if (_init) {
      Provider.of<EventProvider>(context).fetchDatewiseEvents();
      _datewiseEvents = Provider.of<EventProvider>(context).datewiseEvents;
      _datewiseExtracted = _datewiseEvents;
    }
    _init = false;
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
                if (value != null) {
                  setState(() {
                    _dateIs(value);
                  });
                }
              }),
            )
          ],
          title: Text("New Events"),
          backgroundColor: const Color(0xFF892CDC),
        ),
        body: ListView.builder(
          itemCount: _datewiseExtracted.length,
          itemBuilder: (_, i) {
            String key = _datewiseExtracted.keys
                .elementAt(_datewiseExtracted.length - i - 1);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "${key.substring(6, 8)}/${key.substring(4, 6)}/${key.substring(0, 4)}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                Container(
                  margin: const EdgeInsets.all(16.0),
                  height: 270.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _datewiseExtracted[key]?.length,
                    itemBuilder: (_, j) {
                      return EventCard(
                        eventModel: _datewiseExtracted[key][j],
                        placeName: _datewiseExtracted[key][j].placeName,
                      );
                    },
                  ),
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _dateIs(DateTime value) {
    String _datePicked = "";
    _datewiseExtracted = _datewiseEvents;
    if (value.month < 10 && value.day < 10) {
      _datePicked = "${value.year}0${value.month}0${value.day}";
      print("Date: $_datePicked");
      _datewiseEvents[_datePicked] != null
          ? _datewiseExtracted = {_datePicked: _datewiseEvents[_datePicked]}
          : null;
    } else if (value.day < 10) {
      _datePicked = "${value.year}${value.month}0${value.day}";
      print("Date: $_datePicked");
      _datewiseEvents[_datePicked] != null
          ? _datewiseExtracted = {_datePicked: _datewiseEvents[_datePicked]}
          : null;
    } else if (value.month < 10) {
      _datePicked = "${value.year}0${value.month}${value.day}";
      print("Date: $_datePicked");
      _datewiseEvents[_datePicked] != null
          ? _datewiseExtracted = {_datePicked: _datewiseEvents[_datePicked]}
          : null;
    } else {
      _datePicked = "${value.year}${value.month}${value.day}";
      print("Date: $_datePicked");
      _datewiseEvents[_datePicked] != null
          ? _datewiseExtracted = {_datePicked: _datewiseEvents[_datePicked]}
          : null;
    }
  }
}
