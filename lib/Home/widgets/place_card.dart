import 'package:GuestInMe/Place/place_page.dart';
import 'package:GuestInMe/models/place_model.dart';
import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final PlaceModel placeModel;
  PlaceCard({this.placeModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 180.0,
      height: 270.0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PlacePage(
                placeModel: placeModel,
              ),
            ),
          );
        },
        child: ClipRRect(
          child: Column(
            children: [
              Container(
                color: Colors.red,
                height: 180.0,
                width: double.maxFinite,
                child: Image(
                  image: NetworkImage("${placeModel.images[0]}"),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.purple[900].withOpacity(0.8),
                height: 90.0,
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Image(
                      image: NetworkImage("${placeModel.logo}"),
                      // color: Colors.white,
                    ),
                    radius: 30,
                    backgroundColor: Colors.black,
                  ),
                  title: Text(
                    "${placeModel.placeName}",
                    style: TextStyle(
                      fontSize: 18.0,
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
