import 'package:GuestInMe/Home/widgets/event_card.dart';
import 'package:GuestInMe/models/event_model.dart';
import 'package:GuestInMe/providers/event_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewEventsPage extends StatefulWidget {
  @override
  _NewEventsPageState createState() => _NewEventsPageState();
}

class _NewEventsPageState extends State<NewEventsPage> {
  var _init = true;
  var _noEventSelected = false;
  var _loadingEvents = true;
  String _datePicked = "";
  Map<String, List<EventModel>> _datewiseEvents = {};
  Map<String, List<EventModel>> _datewiseExtracted = {};

  @override
  void didChangeDependencies() {
    if (_init) {
      _fetchData();
      _datewiseEvents = Provider.of<EventProvider>(context).datewiseEvents;
      _datewiseExtracted = _datewiseEvents;
    }
    _init = false;
    super.didChangeDependencies();
  }

  void _fetchData() async {
    await Provider.of<EventProvider>(context, listen: false)
        .fetchDatewiseEvents();
    setState(() {
      _loadingEvents = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: _datePicked != "" ? 20 : 25,
                    ),
                    _datePicked != ""
                        ? Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              _datePicked.substring(6),
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              onTap: () => showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2019),
                      lastDate: DateTime(2030))
                  ?.then((value) {
                if (value != null) {
                  setState(() {
                    convertDate(value);
                  });
                }
              }),
            ),
          ],
          title: Text("New Events"),
          backgroundColor: const Color(0xFF892CDC),
        ),
        body: _loadingEvents
            ? Center(child: CircularProgressIndicator())
            : _noEventSelected
                ? Center(
                    child: Text(
                      "No Events on ${_datePicked.substring(6, 8)}/${_datePicked.substring(4, 6)}/${_datePicked.substring(0, 4)}",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
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
                                  placeName:
                                      _datewiseExtracted[key][j].placeName,
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

  void convertDate(DateTime value) {
    _datewiseExtracted = _datewiseEvents;
    if (value.month < 10 && value.day < 10) {
      _datePicked = "${value.year}0${value.month}0${value.day}";
    } else if (value.day < 10) {
      _datePicked = "${value.year}${value.month}0${value.day}";
    } else if (value.month < 10) {
      _datePicked = "${value.year}0${value.month}${value.day}";
    } else {
      _datePicked = "${value.year}${value.month}${value.day}";
    }
    print("Date: $_datePicked");
    if (_datewiseEvents[_datePicked] != null) {
      _noEventSelected = false;
      _datewiseExtracted = {_datePicked: _datewiseEvents[_datePicked]};
    } else {
      _noEventSelected = true;
    }
  }
}
