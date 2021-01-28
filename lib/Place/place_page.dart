import 'package:GuestInMe/Place/widgets/menu_card.dart';
import 'package:GuestInMe/models/event_model.dart';
import 'package:GuestInMe/models/place_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'package:GuestInMe/Event/widgets/star_widget.dart';
import 'package:GuestInMe/Home/widgets/event_card.dart';

class PlacePage extends StatefulWidget {
  final PlaceModel placeModel;
  PlacePage({@required this.placeModel});
  @override
  _PlacePageState createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  var size = Size(0.0, 0.0);
  var _init = true;
  int _dateTodayISO;
  List<EventModel> _upcomingEvents = [];
  List<EventModel> _pastEvents = [];

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    if (_init) {
      _dateTodayISO = int.parse(convertDate(DateTime.now()));
      _upcomingEvents = widget.placeModel.event
          .where((e) => int.parse(convertDatetoISO(e.date)) >= _dateTodayISO)
          .toList();
      _pastEvents = widget.placeModel.event
          .where((e) => int.parse(convertDatetoISO(e.date)) < _dateTodayISO)
          .toList();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161D),
      bottomSheet: Container(
        color: const Color(0xFF16161D),
        child: Container(
          alignment: Alignment.center,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
            color: const Color(0xFF52057B),
          ),
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Colors.black12,
              ),
              padding: EdgeInsets.all(4.0),
              width: 240,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleAvatar(
                      child: Icon(
                        Icons.directions,
                        size: 20.0,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.white12,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Directions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              MapsLauncher.launchQuery('${widget.placeModel.location}');
            },
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: size.width * 0.6,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.black,
              flexibleSpace: CarouselSlider(
                items: widget.placeModel.images.map((link) {
                  return Image(
                    image: NetworkImage("$link"),
                    fit: BoxFit.cover,
                    semanticLabel: "${widget.placeModel.placeName}",
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  height: size.width,
                  enlargeCenterPage: true,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage('${widget.placeModel.logo}'),
                        backgroundColor: Colors.black87,
                        radius: 28.0,
                      ),
                      title: Text(
                        "${widget.placeModel.placeName}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: StarWidget(stars: widget.placeModel.stars),
                      enabled: false,
                    ),
                  ),
                  if (_upcomingEvents.length != 0)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Upcoming Events:",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext _, int i) {
                  return EventCard(
                    eventModel: _upcomingEvents[i],
                    placeName: widget.placeModel.placeName,
                  );
                },
                childCount: _upcomingEvents?.length ?? 0,
              ),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                crossAxisSpacing: 0.0,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 0.0,
                maxCrossAxisExtent: 270,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
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
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.black54,
                    ),
                    child: Text(
                      "${widget.placeModel.description}",
                    ),
                  ),
                  //menu
                  if (widget.placeModel.menu?.length != 0)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Menu:",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  CarouselSlider.builder(
                    itemCount: widget.placeModel.menu?.length,
                    options: CarouselOptions(
                      height: 400,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    itemBuilder: (_, _i) => InkWell(
                      child: Image(
                        image: NetworkImage(
                          widget.placeModel.menu[_i],
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => MenuCard(
                            widget.placeModel.menu[_i],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (_pastEvents.length != 0)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Past Events:",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext _, int i) {
                  return EventCard(
                    eventModel: _pastEvents[i],
                    placeName: widget.placeModel.placeName,
                  );
                },
                childCount: _pastEvents?.length ?? 0,
              ),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                crossAxisSpacing: 0.0,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 0.0,
                maxCrossAxisExtent: 270,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [SizedBox(height: 200.0)],
              ),
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
