import 'package:GuestInMe/Home/diamond_page.dart';
import 'package:GuestInMe/Profile/profile_page.dart';
import 'package:GuestInMe/Search/search_page.dart';
import 'package:GuestInMe/assets/guest_in_me_icons.dart';
import 'package:GuestInMe/models/user_model.dart';
import 'package:GuestInMe/providers/event_provider.dart';
import 'package:GuestInMe/providers/locations_provider.dart';
import 'package:GuestInMe/providers/place_provider.dart';
import 'package:GuestInMe/providers/user_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class NavigationPage extends StatefulWidget {
  final bool askDetails;
  NavigationPage({@required this.askDetails});
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  var _isInit = true;
  Size _size = Size(0.0, 0.0);
  var _loading = true;
  String _name, _email, _city;
  int _selected = 1, _gender;
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate;

  List<dynamic> _locations = [];

  @override
  void didChangeDependencies() {
    _size = MediaQuery.of(context).size;
    if (_isInit) {
      _fetchData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _fetchData() async {
    await Provider.of<PlaceProvider>(context, listen: false).fetchPlaces();
    await Provider.of<EventProvider>(context, listen: false).fetchNewEvents();
    await Provider.of<LocationsProvider>(context, listen: false)
        .fetchLocations();
    setState(() {
      _loading = false;
      _locations =
          Provider.of<LocationsProvider>(context, listen: false).locations;
    });
    if (widget.askDetails) {
      await _userForm(context);
    }
    await Provider.of<UserProvider>(context, listen: false).fetchUser();
  }

  int _calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Future<void> _userForm(BuildContext ctx) {
    return showDialog(
      context: ctx,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (cont, StateSetter setInnerState) {
            void _selectDate(BuildContext c) async {
              final DateTime _picked = await showDatePicker(
                context: c,
                initialDate:
                    _selectedDate == null ? DateTime.now() : _selectedDate,
                firstDate: DateTime(1920),
                lastDate: DateTime.now(),
              );
              if (_picked != null && _picked != _selectedDate) {
                setInnerState(() {
                  _selectedDate = _picked;
                });
                print(_selectedDate.toString());
              }
            }

            return AlertDialog(
              title: Text("Enter your details"),
              backgroundColor: Colors.deepPurple[700],
              scrollable: true,
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        validator: (_n) {
                          if (_n.isEmpty) {
                            return 'Please enter a name';
                          } else if (!RegExp("^([a-zA-Z])+\$")
                              .hasMatch(_n.replaceAll(RegExp(r' '), ''))) {
                            return 'Enter a valid name';
                          }
                          return null;
                        },
                        onSaved: (_n) => _name = _n,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: FlatButton(
                            child: Text(
                              "Male",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                color: _gender == 1
                                    ? Colors.purple
                                    : Colors.transparent,
                              ),
                            ),
                            onPressed: () => setInnerState(() {
                              _gender = 1;
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: FlatButton(
                            child: Text(
                              "Female",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                color: _gender == 2
                                    ? Colors.purple
                                    : Colors.transparent,
                              ),
                            ),
                            onPressed: () => setInnerState(() {
                              _gender = 2;
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: FlatButton(
                            child: Text(
                              "Other",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                color: _gender == 3
                                    ? Colors.purple
                                    : Colors.transparent,
                              ),
                            ),
                            onPressed: () => setInnerState(() {
                              _gender = 3;
                            }),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        validator: (_e) {
                          if (_e.isEmpty) {
                            return 'Please enter an email';
                          } else if (RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(_e)) {
                            return null;
                          }
                          return "Enter a valid email";
                        },
                        onSaved: (_e) => _email = _e,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "City",
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        validator: (_c) {
                          if (_c.isEmpty) {
                            return 'Please choose a city';
                          }
                          return null;
                        },
                        onSaved: (_c) => _city = _c,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                      ),
                      title: _selectedDate != null
                          ? Text(
                              "Age: ${_calculateAge(_selectedDate)}",
                            )
                          : Text("Date of Birth"),
                      dense: true,
                      onTap: () => _selectDate(cont),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text("Submit"),
                        color: Colors.purple[700],
                        onPressed: () {
                          if (_formKey.currentState.validate() &&
                              _selectedDate != null &&
                              _gender != null) {
                            _formKey.currentState.save();
                            var _sendUser = UserModel(
                              name: _name,
                              gender: _gender == 1
                                  ? "male"
                                  : _gender == 2
                                      ? "female"
                                      : "other",
                              phoneNumber:
                                  FirebaseAuth.instance.currentUser.phoneNumber,
                              email: _email,
                              frequency: null,
                              place: _city,
                              dateOfBirth: _convertDate(_selectedDate),
                            );
                            UserProvider()
                                .putUser(_sendUser)
                                .then((_) => Navigator.pop(cont));
                          } else {
                            Fluttertoast.showToast(
                              msg: "Fill all the details",
                              backgroundColor: Colors.black87,
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161D),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selected,
        backgroundColor: const Color(0xFF16161D),
        items: <Widget>[
          Icon(
            Icons.search,
            size: _size.height * 0.03,
            color: Colors.black,
          ),
          Icon(
            GuestInMe.diamond_2,
            size: _selected == 1 ? _size.height * 0.05 : _size.height * 0.03,
            color: _selected == 1 ? Colors.purple : Colors.black,
          ),
          Icon(
            Icons.person_outline,
            size: _size.height * 0.03,
            color: Colors.black,
          ),
        ],
        color: const Color(0xFFFFFFFF),
        onTap: (_i) {
          setState(() {
            _selected = _i;
          });
          print(_selected);
        },
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(backgroundColor: Colors.purple),
            )
          : SafeArea(
              child: _selected == 1
                  ? DiamondPage(_locations)
                  : _selected == 0
                      ? SearchPage()
                      : ProfilePage(),
            ),
    );
  }

  String _convertDate(DateTime value) {
    String _datePicked;
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
    return _datePicked;
  }
}
