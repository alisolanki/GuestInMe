import 'package:GuestInMe/Home/diamond_page.dart';
import 'package:GuestInMe/Profile/profile_page.dart';
import 'package:GuestInMe/Search/search_page.dart';
import 'package:GuestInMe/assets/guest_in_me_icons.dart';
import 'package:GuestInMe/providers/event_provider.dart';
import 'package:GuestInMe/providers/place_provider.dart';
import 'package:GuestInMe/providers/user_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationPage extends StatefulWidget {
  final int selected;
  NavigationPage({@required this.selected});
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  var _isInit = true;
  int _selected;
  Size _size = Size(0.0, 0.0);
  var _loading = true;

  @override
  void didChangeDependencies() {
    _size = MediaQuery.of(context).size;
    if (_isInit) {
      _selected = widget.selected;
      Provider.of<UserProvider>(context, listen: false).fetchUser().then((_) {
        setState(() {
          _loading = false;
        });
        Provider.of<PlaceProvider>(context, listen: false).fetchPlaces().then(
            (_) => Provider.of<EventProvider>(context, listen: false)
                .fetchNewEvents());
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161D),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selected,
        backgroundColor: const Color(0xFF16161D),
        items: <Widget>[
          Icon(
            Icons.search,
            size: _size.height * 0.03,
            color: Colors.black,
          ),
          Icon(
            GuestInMe.diamond_2,
            size: _selected == 1 ? _size.height * 0.05 : _size.height * 0.03,
            color: _selected == 1 ? Colors.purple : Colors.black,
          ),
          Icon(Icons.person_outline, size: 30, color: Colors.black),
        ],
        onTap: (_i) => setState(() {
          _selected = _i;
        }),
        color: const Color(0xFFFFFFFF),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.deepPurpleAccent,
              ),
            )
          : SafeArea(
              child: _selected == 1
                  ? DiamondPage()
                  : _selected == 0
                      ? SearchPage()
                      : ProfilePage(),
            ),
    );
  }
}
