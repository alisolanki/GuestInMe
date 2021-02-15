import 'package:GuestInMe/models/event_model.dart';
import 'package:GuestInMe/models/place_model.dart';
import 'package:GuestInMe/providers/locations_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import './http_requests.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  int _value = 0;
  int _priceNum = 0;
  var _isInit = true;
  var _newEvent = false;

  String _eventName;
  String _description;
  String _datePicked;
  DateTime _dateTime;
  List<PriceModel> _prices = [];
  String _image;
  String _lineup;
  String _ageLimit;
  String _dressCode;
  String _time;

  EventModel _eventModel;
  List<PlaceModel> _placeList = [];
  PriceModel _tablePrice = PriceModel(type: "tables");
  PriceModel _crowdPrice = PriceModel(type: "crowd");
  var _coupleType = TypeModel(typeName: "Couple");
  var _femaleType = TypeModel(typeName: "Female");
  var _malestagsType = TypeModel(typeName: "Male Stags");

  void formSave() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _prices.addAll([_crowdPrice, _tablePrice]);
      _crowdPrice.typeData = [_coupleType, _femaleType, _malestagsType];

      _eventModel = EventModel(
        eventName: _eventName,
        description: _description,
        date: _datePicked,
        prices: _prices,
        image: _image,
        lineup: _lineup,
        ageLimit: _ageLimit,
        dressCode: _dressCode,
        time: _time,
        placeName: _placeList[_value].placeName,
        closeOnline: true,
        closeOffline: false,
      );
      Fluttertoast.showToast(
        msg: 'Adding event!',
        backgroundColor: Colors.amber,
      );
      await TransferData().addEvent(
        eventModel: _eventModel,
        newEvent: _newEvent,
        date: _dateTime,
      );
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _placeList = Provider.of<LocationsProvider>(context).places;
      _tablePrice.typeData = [];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _textField("Event Name"),
                _textField("Description"),
                //Place name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    value: _placeList.length != 0 ? _value : null,
                    items: _placeList.map((_placeModel) {
                      return DropdownMenuItem(
                        child: Text("   ${_placeModel?.placeName}"),
                        value: _placeList.indexOf(_placeModel),
                      );
                    }).toList(),
                    isExpanded: true,
                    disabledHint: Text("Place Name"),
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                ),
                //date
                ListTile(
                  leading: Text("Date Select:"),
                  trailing: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: _datePicked != null ? 20 : 25,
                          ),
                          _datePicked != null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    _datePicked.substring(6),
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 1.0,
                                  width: 1.0,
                                ),
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
                          _dateTime = value;
                          convertDate(value);
                        });
                      }
                    }),
                  ),
                ),
                _textField("Time"),
                _textField("Age limit"),
                _textField("Dress code"),
                _textField("Image"),
                _textField("Lineup"),
                //newEvent
                ListTile(
                  leading: Text("Is it a new Event?"),
                  trailing: Checkbox(
                    value: _newEvent,
                    onChanged: (v) => setState(() {
                      _newEvent = v;
                    }),
                    activeColor: Colors.pink,
                  ),
                ),
                _crowdField(),
                //table
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Table",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (_prices.length != 0) {
                                _prices.removeLast();
                              }
                              if (_priceNum > 0) {
                                setState(() {
                                  _priceNum = _priceNum - 1;
                                });
                              }
                            }),
                        Text(
                          "$_priceNum",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => setState(() {
                            _priceNum = _priceNum + 1;
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                //table list
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _priceNum,
                  itemBuilder: (context, _i) {
                    return Column(
                      children: [
                        _tableField(_i),
                      ],
                    );
                  },
                ),
                //submit
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RaisedButton.icon(
                      icon: Icon(
                        Icons.check,
                        size: 20.0,
                      ),
                      label: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      color: Colors.purple[700],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        formSave();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField(String hint) {
    return TextFormField(
      key: ValueKey("$hint"),
      initialValue: "$hint",
      decoration: InputDecoration(
        labelText: "$hint",
        labelStyle: TextStyle(
          color: Colors.white70,
        ),
        fillColor: const Color(0x00C97CFF),
        filled: true,
        disabledBorder: InputBorder.none,
      ),
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
      ),
      keyboardType: TextInputType.name,
      validator: (value) => value.isEmpty ? "Enter $hint" : null,
      onSaved: (_input) {
        hint == "Event Name"
            ? setState(() {
                _eventName = _input;
              })
            : hint == "Description"
                ? setState(() {
                    _description = _input;
                  })
                : hint == "Image"
                    ? setState(() {
                        _image = _input;
                      })
                    : hint == "Age limit"
                        ? setState(() {
                            _ageLimit = _input;
                          })
                        : hint == "Dress code"
                            ? setState(() {
                                _dressCode = _input;
                              })
                            : hint == "Lineup"
                                ? setState(() {
                                    _lineup = _input;
                                  })
                                : setState(() {
                                    _time = _input;
                                  });
      },
    );
  }

  Widget _crowdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        //crowd
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Crowd",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        //couple
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text("Couple"),
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: "Guestlist closes at 23:00",
                decoration: InputDecoration(
                  hintText: "Description",
                ),
                onSaved: (d) {
                  setState(() {
                    _coupleType.description = d;
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Price",
                ),
                keyboardType: TextInputType.number,
                onSaved: (p) => setState(() {
                  _coupleType.price = p;
                }),
              ),
            ),
          ],
        ),
        //female
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text("Female"),
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: "Guestlist closes at 23:00",
                decoration: InputDecoration(
                  hintText: "Description",
                ),
                onSaved: (d) {
                  setState(() {
                    _femaleType.description = d;
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Price",
                ),
                keyboardType: TextInputType.number,
                onSaved: (p) => setState(() {
                  _femaleType.price = p;
                }),
              ),
            ),
          ],
        ),
        //male stag
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text("Male Stag"),
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: "Guestlist closes at 23:00",
                decoration: InputDecoration(
                  hintText: "Description",
                ),
                onSaved: (d) {
                  setState(() {
                    _malestagsType.description = d;
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Price",
                ),
                keyboardType: TextInputType.number,
                onSaved: (p) => setState(() {
                  _malestagsType.price = p;
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tableField(int _i) {
    var _tableType = TypeModel();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Table Name",
            ),
            onSaved: (n) => setState(() {
              _tableType.typeName = n;
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: "Exclusive table provided for _ people",
                  decoration: InputDecoration(
                    hintText: "Description",
                  ),
                  onSaved: (d) => setState(() {
                    _tableType.description = d;
                  }),
                ),
              ),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 2,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Price",
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (p) => setState(() {
                    _tableType.price = p;
                    _tablePrice.typeData.add(_tableType);
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void convertDate(DateTime value) {
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
  }
}
