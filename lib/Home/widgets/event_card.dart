import 'package:GuestInMe/Event/event_page.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  EventCard(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 180.0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EventPage("$title"),
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
                color: Colors.lightBlue,
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
                      "Sat 7, Nov | 17:00 - 01:30",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 8.0,
                      ),
                    ),
                    Text(
                      "$title",
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: const Color(0xFFBC6FF1),
                        ),
                        Text(
                          "Place",
                          style: TextStyle(
                            color: const Color(0xFFBC6FF1),
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                          ),
                        )
                      ],
                    )
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
