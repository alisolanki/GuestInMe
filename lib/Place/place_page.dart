import 'package:GuestInMe/models/place_model.dart';
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

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: size.width,
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
                    eventModel: widget.placeModel.event[i],
                    placeName: widget.placeModel.placeName,
                  );
                },
                childCount: widget?.placeModel?.event?.length ?? 0,
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
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
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
                    eventModel: widget.placeModel.event[i],
                    placeName: widget.placeModel.placeName,
                  );
                },
                childCount: widget?.placeModel?.event?.length ?? 0,
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
                [SizedBox(height: 100)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
