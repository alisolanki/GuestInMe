import 'package:GuestInMe/Place/place_page.dart';
import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final String title;
  PlaceCard({this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 180.0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PlacePage(title: "$title"),
            ),
          );
        },
        child: ClipRRect(
          child: Column(
            children: [
              Container(
                color: Colors.red,
                height: 180.0,
              ),
              Container(
                color: Colors.blue,
                height: 90.0,
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Image(
                      image: AssetImage('assets/logofilled.png'),
                      color: Colors.white30,
                    ),
                    radius: 30,
                  ),
                  title: Text(
                    "Place Name",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
