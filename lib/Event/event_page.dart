import 'dart:io';
import 'dart:math';

import 'package:GuestInMe/Home/widgets/place_card.dart';
import 'package:GuestInMe/models/event_model.dart';
import 'package:GuestInMe/models/place_model.dart';
import 'package:GuestInMe/models/user_model.dart';
import 'package:GuestInMe/providers/locations_provider.dart';
import 'package:GuestInMe/providers/payment.dart';
import 'package:GuestInMe/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatefulWidget {
  final EventModel eventModel;
  final String placeName;
  EventPage({@required this.eventModel, @required this.placeName});
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  var size = Size(0.0, 0.0);
  var _init = true;
  String _dateISO, _dateTodayISO, _referral, _selectedLocation;
  LocationsProvider _locationsProvider;
  PlaceModel _placeModel;
  UserModel _userModel;

  String _dirPath;
  List<FileSystemEntity> _files = [];

  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    if (_init) {
      _locationsProvider = Provider.of<LocationsProvider>(context);
      _userModel = Provider.of<UserProvider>(context).userModel;
      setState(() {
        _placeModel = _locationsProvider.places
            .firstWhere((e) => e.placeName == widget.placeName);
        _selectedLocation = _locationsProvider.selectedLocation;
        _dateISO = convertDatetoISO(widget.eventModel.date);
        _dateTodayISO = convertDate(DateTime.now());
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  void _listofFiles() async {
    _dirPath = (await getApplicationDocumentsDirectory()).path;
    await Directory("$_dirPath/tickets/").exists()
        ? setState(() {
            _files = Directory("$_dirPath/tickets/").listSync();
          })
        : _files = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161D),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: size.width,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.black,
              flexibleSpace: Image(
                image: NetworkImage('${widget.eventModel.image}'),
                fit: BoxFit.cover,
                semanticLabel: "${widget.eventModel.eventName} flyer",
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  //date and time
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    child: Text(
                      "${widget.eventModel.date} | ${widget.eventModel.time}",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16.0,
                        color: Colors.white70,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  //eventName
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "${widget.eventModel.eventName}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  //placeName
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        Text(
                          "${widget.placeName}",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () => Share.share(
                            "Are you coming to ${widget.eventModel.placeName} tonight for ${widget.eventModel.eventName}? Download GuestInMe Nightlife App to access and book for the most exclusive Clubs in Mumbai, Delhi, Goa, Bangalore and other cities in India. Download now: https://onelink.to/guestinme",
                          ),
                        ),
                      ],
                    ),
                  ),
                  //dressCode and ageLimit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          height: 150,
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                            border: Border.all(
                              color: const Color(0xFFBC6FF1),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.person_outline,
                              ),
                              Text(
                                "${widget.eventModel.dressCode}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Dress code",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          height: 150,
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                            border: Border.all(
                              color: const Color(0xFFBC6FF1),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.error_outline,
                              ),
                              Text(
                                "${widget.eventModel.ageLimit}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Age limit",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //booking title
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Book a spot:",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //tables
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      color: Colors.purple,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.local_bar,
                      ),
                      title: Text(
                        "${widget.eventModel.prices[1].typeData[i].typeName}",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${widget.eventModel.prices[1].typeData[i].description}",
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      trailing: Text(
                        widget.eventModel.prices[1].typeData[i].price == "0"
                            ? "FREE"
                            : "Rs.${widget.eventModel.prices[1].typeData[i].price}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      onTap: () =>
                          (int.parse(_dateISO) >= int.parse(_dateTodayISO))
                              ? _payableAlertDialog(
                                  widget.eventModel.prices[1].typeData[i],
                                )
                              : Fluttertoast.showToast(
                                  msg: "Cannot book for this event",
                                  backgroundColor: Colors.red,
                                ),
                    ),
                  );
                },
                childCount: widget.eventModel.prices[1].typeData.length,
              ),
            ),
            //crowd
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      color: Colors.purple,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                      ),
                      title: Text(
                        "${widget.eventModel.prices[0].typeData[i].typeName}",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${widget.eventModel.prices[0].typeData[i].description}",
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      trailing: Text(
                        widget.eventModel.prices[0].typeData[i].price == "0"
                            ? "FREE"
                            : "Rs.${widget.eventModel.prices[0].typeData[i].price}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      onTap: () {
                        if (int.parse(_dateISO) >= int.parse(_dateTodayISO)) {
                          widget.eventModel.prices[0].typeData[i].price == "0"
                              ? _nonPayableAlertDialog(
                                  widget.eventModel.prices[0].typeData[i],
                                )
                              : _payableAlertDialog(
                                  widget.eventModel.prices[0].typeData[i],
                                );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Cannot book for this event",
                            backgroundColor: Colors.red,
                          );
                        }
                      },
                    ),
                  );
                },
                childCount: widget.eventModel.prices[0].typeData.length,
              ),
            ),
            //details
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  //Info
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Info:",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  //description
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.black54,
                    ),
                    child: Text(
                      "${widget.eventModel.description}",
                    ),
                  ),
                  //lineup title
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Line up:",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  //lineup
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      color: Colors.deepPurpleAccent,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.account_circle,
                      ),
                      title: Text(
                        "${widget.eventModel.lineup}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //venue details
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  //venue title
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Venue:",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  //venue
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlaceCard(
                      placeModel: _placeModel,
                    ),
                  ),
                  SizedBox(height: 70.0)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _payableAlertDialog(TypeModel _typeModel) {
    int _num = 1;
    _files.length > 5
        ? Fluttertoast.showToast(
            msg:
                "Limit for booking tickets reached. Delete Tickets to book more.",
            backgroundColor: Colors.red,
          )
        : showDialog(
            context: context,
            builder: (cont) => StatefulBuilder(
              builder: (ctx, setState) => CupertinoAlertDialog(
                title: Text("Booking options"),
                content: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CupertinoButton(
                            child: Icon(Icons.remove),
                            onPressed: _num <= 1
                                ? null
                                : () => setState(() {
                                      _num = _num - 1;
                                    }),
                          ),
                          Text("$_num tickets"),
                          CupertinoButton(
                            child: Icon(Icons.add),
                            onPressed: _num > 4
                                ? null
                                : () => setState(() {
                                      _num = _num + 1;
                                    }),
                          ),
                        ],
                      ),
                      CupertinoTextField(
                        placeholder: "Referral Code (Optional)",
                        textCapitalization: TextCapitalization.characters,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue),
                        placeholderStyle: const TextStyle(
                          color: const Color(0x772196F3),
                        ),
                        onChanged: (r) => setState(() {
                          _referral = r;
                        }),
                      ),
                    ],
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                      child: Text("Get ticket and pay on entry"),
                      onPressed: () {
                        if (widget.eventModel.closeOffline) {
                          Fluttertoast.showToast(
                            msg: "Offline payment is closed for this event!",
                            backgroundColor: Colors.amber,
                            textColor: Colors.black,
                          );
                        } else {
                          RegistrationHttp().sendRegistration(
                            ctx: ctx,
                            paid: false,
                            typeModel: _typeModel,
                            code: Random().nextInt(9000) + 1000,
                            eventModel: widget.eventModel,
                            userModel: _userModel,
                            referral: _referral,
                            peopleNumber: _num,
                            location: _selectedLocation,
                          );
                        }
                      }),
                  CupertinoDialogAction(
                    child: Text("Online payment"),
                    onPressed: () {
                      if (widget.eventModel.closeOnline) {
                        Fluttertoast.showToast(
                          msg: 'Online payment is closed for this event!',
                          backgroundColor: Colors.amber,
                          textColor: Colors.black,
                        );
                      } else if (Platform.isIOS) {
                        Fluttertoast.showToast(
                          msg:
                              'Online payments are not available on IOS devices',
                          backgroundColor: Colors.amber,
                          textColor: Colors.black,
                        );
                      } else {
                        final _code = Random().nextInt(9000) + 1000;
                        PaymentProvider().openCheckout(
                          type: _typeModel,
                          eventModel: widget.eventModel,
                          userModel: _userModel,
                          code: _code,
                          ctx: ctx,
                          referral: _referral,
                          peopleNumber: _num,
                          selectedLocation: _selectedLocation,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
  }

  _nonPayableAlertDialog(TypeModel _typeModel) {
    int _num = 1;
    _files.length > 5
        ? Fluttertoast.showToast(
            msg:
                "Limit for booking tickets reached. Delete Tickets to book more.",
            backgroundColor: Colors.red,
          )
        : showDialog(
            context: context,
            builder: (ctx) => StatefulBuilder(
              builder: (context, setState) => CupertinoAlertDialog(
                title: Text("Get ticket"),
                content: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoButton(
                          child: Icon(Icons.remove),
                          onPressed: _num <= 1
                              ? null
                              : () => setState(() {
                                    _num = _num - 1;
                                  }),
                        ),
                        Text("$_num tickets"),
                        CupertinoButton(
                          child: Icon(Icons.add),
                          onPressed: _num > 4
                              ? null
                              : () => setState(() {
                                    _num = _num + 1;
                                  }),
                        ),
                      ],
                    ),
                    CupertinoTextField(
                      placeholder: "Referral Code (Optional)",
                      textCapitalization: TextCapitalization.characters,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue),
                      placeholderStyle: const TextStyle(
                        color: const Color(0x772196F3),
                      ),
                      onChanged: (r) => setState(() {
                        _referral = r;
                      }),
                    ),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text("Generate ticket"),
                    isDefaultAction: true,
                    onPressed: () {
                      if (widget.eventModel.closeOffline &&
                          widget.eventModel.closeOnline) {
                        Fluttertoast.showToast(
                          msg: "Event is sold out!",
                          backgroundColor: Colors.red,
                        );
                      } else {
                        RegistrationHttp().sendRegistration(
                          ctx: ctx,
                          paid: true,
                          typeModel: _typeModel,
                          code: Random().nextInt(9000) + 1000,
                          eventModel: widget.eventModel,
                          userModel: _userModel,
                          peopleNumber: _num,
                          location: _selectedLocation,
                          referral: _referral,
                        );
                      }
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text("Cancel"),
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
          );
  }

  String convertDatetoISO(String value) {
    String _month = value.split(" ")[2],
        _day = value.split(" ")[1].split(",")[0],
        _year = value.split(" ")[3];
    String _monthISO;
    switch (_month) {
      case "Jan":
        _monthISO = "01";
        break;
      case "Feb":
        _monthISO = "02";
        break;
      case "Mar":
        _monthISO = "03";
        break;
      case "Apr":
        _monthISO = "04";
        break;
      case "May":
        _monthISO = "05";
        break;
      case "Jun":
        _monthISO = "06";
        break;
      case "Jul":
        _monthISO = "07";
        break;
      case "Aug":
        _monthISO = "08";
        break;
      case "Sep":
        _monthISO = "09";
        break;
      case "Oct":
        _monthISO = "10";
        break;
      case "Nov":
        _monthISO = "11";
        break;
      case "Dec":
        _monthISO = "12";
        break;
      default:
        break;
    }
    if (int.parse(_day) < 10) {
      _day = "0$_day";
    }
    print("Date: $_year$_monthISO$_day");
    return "$_year$_monthISO$_day";
  }

  String convertDate(DateTime value) {
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
