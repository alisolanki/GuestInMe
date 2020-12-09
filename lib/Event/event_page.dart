import 'package:GuestInMe/Home/widgets/place_card.dart';
import 'package:GuestInMe/models/event_model.dart';
import 'package:GuestInMe/models/place_model.dart';
import 'package:GuestInMe/providers/place_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  PlaceProvider _placeProvider;
  PlaceModel _placeModel;

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    if (_init) {
      _placeProvider = Provider.of<PlaceProvider>(context);
      setState(() {
        _placeModel = _placeProvider.places
            .firstWhere((e) => e.placeName == widget.placeName);
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.location_on,
                            color: const Color(0xFFBC6FF1),
                          ),
                        ),
                        Text(
                          "${widget.placeName}",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: const Color(0xFFBC6FF1),
                          ),
                        ),
                      ],
                    ),
                  ),
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
            //tables
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
                      color: const Color(0xEEBC6FF1),
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
                        "Rs.${widget.eventModel.prices[1].typeData[i].price}",
                        style: TextStyle(fontSize: 18.0),
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
                      color: const Color(0xEEBC6FF1),
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
                        "Rs.${widget.eventModel.prices[0].typeData[i].price}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  );
                },
                childCount: widget.eventModel.prices[0].typeData.length,
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
                      "${widget.eventModel.description}",
                    ),
                  ),
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
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      color: const Color(0xAABC6FF1),
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
            SliverList(
              delegate: SliverChildListDelegate(
                [
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
}
