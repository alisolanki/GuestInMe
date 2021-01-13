import 'package:GuestInMe/Home/navigation_page.dart';
import 'package:GuestInMe/LoginOTP/stores/login_store.dart';
import 'package:GuestInMe/providers/event_provider.dart';
import 'package:GuestInMe/providers/place_provider.dart';
import 'package:GuestInMe/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final bool askDetails;
  HomePage({this.askDetails = false});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          home: NavigationPage(askDetails: widget.askDetails),
        );
      },
    );
  }
}
