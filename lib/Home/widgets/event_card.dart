import 'package:guestinme/Event/event_page.dart';
import 'package:guestinme/models/event_model.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final EventModel eventModel;
  final String placeName;
  EventCard({@required this.eventModel, @required this.placeName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 270.0,
      width: 200,
      child: InkWell(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                height: 270.0,
                width: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.black,
                  image: DecorationImage(
                    image: NetworkImage("${eventModel.image}"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                height: 270.0,
                width: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.black,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 90.0,
                width: 200.0,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "${eventModel.date} | ${eventModel.time}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 10.0,
                        ),
                      ),
                      Text(
                        "${eventModel.eventName}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: const Color(0xFFBC6FF1),
                            size: 14.0,
                          ),
                          Container(
                            width: 134.0,
                            height: 17.0,
                            child: Text(
                              "$placeName",
                              style: TextStyle(
                                color: const Color(0xFFBC6FF1),
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //date front
            Positioned(
              top: 5.0,
              left: 5.0,
              child: Container(
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Colors.purple,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purple,
                      Colors.purple[900],
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "${eventModel.date.split(' ')[1].split(',')[0]} ${eventModel.date.split(' ')[2]}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EventPage(
                eventModel: eventModel,
                placeName: placeName,
              ),
            ),
          );
        },
      ),
    );
  }
}
