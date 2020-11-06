import 'package:GuestInMe/Home/widgets/event_card.dart';
import 'package:flutter/material.dart';

import './widgets/selection_card.dart';

class DiamondPage extends StatefulWidget {
  @override
  _DiamondPageState createState() => _DiamondPageState();
}

class _DiamondPageState extends State<DiamondPage> {
  var size = Size(0.0, 0.0);

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  Widget heading(String _title) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$_title",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.purple,
            ),
            onPressed: () => {},
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.black,
          expandedHeight: size.height * 0.4,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            background: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/images/logo_white.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          bottom: PreferredSize(
            child: ClipRRect(
              child: Container(
                width: size.width,
                height: 50.0,
                color: const Color(0xFF16161D),
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.0),
              ),
            ),
            preferredSize: Size(size.width, 100.0),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                height: 180.0,
                child: ListView.builder(
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SelectionCard("Clubs");
                  },
                ),
              ),
              heading("This week's events"),
              Container(
                height: 270.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return EventCard("Event Name");
                  },
                ),
              ),
              heading("Popular parties"),
              Container(
                height: 270.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return EventCard("Event Name");
                  },
                ),
              ),
              SizedBox(height: 50.0),
            ],
          ),
        )
      ],
    );
  }
}
