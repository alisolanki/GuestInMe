import 'package:GuestInMe/category/category_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        child: ClipRRect(
          child: Stack(
            children: [
              Container(
                height: 180.0,
                width: 180.0,
                child: Image(
                  image: widget.title.toLowerCase() == "clubs"
                      ? NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/guestinme-3aafb.appspot.com/o/club.jpg?alt=media&token=b989018a-b40d-49f4-be46-8c697e8bc1ca',
                        )
                      : widget.title.toLowerCase() == "bars"
                          ? NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/guestinme-3aafb.appspot.com/o/pubs.jpg?alt=media&token=1e4bb8ee-fc28-4f81-bab5-25a713eda3b2',
                            )
                          : NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/guestinme-3aafb.appspot.com/o/concert.jpg?alt=media&token=ef13dcd9-9c6f-44e6-9215-f6090b2f5786',
                            ),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0.0,
                child: Container(
                  height: 180.0,
                  width: 180.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12.0,
                left: 0.0,
                right: 0.0,
                child: Text(
                  "${widget.title}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => CategoryPage(widget.title),
            ),
          );
        },
      ),
    );
  }
}
