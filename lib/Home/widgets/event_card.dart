import 'package:GuestInMe/Event/event_page.dart';
import 'package:GuestInMe/models/event_model.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final EventModel eventModel;
  final String placeName;
  EventCard({@required this.eventModel, @required this.placeName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 180.0,
      child: InkWell(
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
        child: Column(
          children: [
            Container(
              height: 180.0,
              width: 180.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage("${eventModel.image}"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 90.0,
              width: 180.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20.0),
                ),
                color: Colors.white,
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
                        color: Colors.blueGrey,
                        fontSize: 8.0,
                      ),
                    ),
                    Text(
                      "${eventModel.eventName}",
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
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
                          height: 15.0,
                          child: Text(
                            "$placeName",
                            style: TextStyle(
                              color: const Color(0xFFBC6FF1),
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
