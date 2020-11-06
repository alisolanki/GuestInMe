import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 36.0,
              right: 18.0,
              left: 18.0,
              bottom: 18.0,
            ),
            child: TextField(
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
              ),
              cursorColor: Colors.white10,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  color: const Color(0xEEC97CFF),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: const Color(0xEEC97CFF),
                ),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          Text(
            "Search for Club, Bar, Event or Artist",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
