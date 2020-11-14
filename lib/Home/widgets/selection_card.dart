import 'package:GuestInMe/category/category_page.dart';
import 'package:flutter/material.dart';
import 'package:GuestInMe/providers/place_provider.dart';
import 'package:provider/provider.dart';

class SelectionCard extends StatefulWidget {
  final String title;
  SelectionCard(this.title);

  @override
  _SelectionCardState createState() => _SelectionCardState();
}

class _SelectionCardState extends State<SelectionCard> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 180.0,
      height: 180.0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CategoryPage(widget.title),
            ),
          );
        },
        child: ClipRRect(
          child: Column(
            children: [
              Container(
                color: Colors.black87,
                height: 120,
                child: Image(
                  image: widget.title.toLowerCase() == "clubs"
                      ? NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/guestinme-3aafb.appspot.com/o/clubs.jpg?alt=media&token=5fbf22e7-9254-4ff3-8428-986d48505d79',
                        )
                      : NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/guestinme-3aafb.appspot.com/o/pubs.jpg?alt=media&token=1e4bb8ee-fc28-4f81-bab5-25a713eda3b2',
                        ),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.black,
                height: 60,
                width: 180.0,
                child: Center(
                  child: Text(
                    "${widget.title}",
                    style: TextStyle(
                      color: Color(0xFFCB6CE6),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
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
