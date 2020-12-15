import 'package:GuestInMe/LoginOTP/stores/login_store.dart';
import 'package:GuestInMe/Profile/profile_page.dart';
import 'package:GuestInMe/providers/event_provider.dart';
import 'package:GuestInMe/providers/place_provider.dart';
import 'package:GuestInMe/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../assets/guest_in_me_icons.dart';
import '../Home/diamond_page.dart';
import '../Search/search_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selected = 1;
  var _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlaceProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider.value(value: LoginStore()),
      ],
      builder: (ctx, child) {
        Provider.of<UserProvider>(ctx, listen: false)
            .fetchUser()
            ?.then((_) => setState(() => _loading = false));
        Provider.of<PlaceProvider>(ctx, listen: false).fetchPlaces();
        Provider.of<EventProvider>(ctx, listen: false).fetchNewEvents();
        child = CurvedNavigationBar(
          index: 1,
          backgroundColor: const Color(0xFF16161D),
          items: <Widget>[
            Icon(Icons.search, size: 30, color: Colors.black),
            Icon(
              GuestInMe.diamond_2,
              size: _selected == 1 ? 50 : 30,
              color: _selected == 1 ? Colors.purple : Colors.black,
            ),
            Icon(Icons.person_outline, size: 30, color: Colors.black),
          ],
          onTap: (_i) => setState(() {
            _selected = _i;
          }),
          color: const Color(0xFFFFFFFF),
        );
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          home: Scaffold(
            backgroundColor: const Color(0xFF16161D),
            bottomNavigationBar: child,
            body: SafeArea(
              child: _selected == 1
                  ? DiamondPage()
                  : _selected == 0
                      ? SearchPage()
                      : ProfilePage(),
            ),
          ),
        );
      },
    );
  }
}
