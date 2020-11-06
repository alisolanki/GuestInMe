import 'package:flutter/material.dart';

class SelectionCard extends StatelessWidget {
  final String title;
  SelectionCard(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 180.0,
      child: InkWell(
        onTap: () {
          print("tapped");
        },
        child: ClipRRect(
          child: Column(
            children: [
              Container(
                color: Colors.pink,
                height: 120,
              ),
              Container(
                color: Colors.white,
                height: 60,
                width: 180.0,
                child: Center(
                  child: Text(
                    "$title",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
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
