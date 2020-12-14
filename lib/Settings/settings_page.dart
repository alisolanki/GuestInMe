import 'package:GuestInMe/LoginOTP/pages/login_page.dart';
import 'package:GuestInMe/Settings/owner/entrance_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/auth.dart' as auth;
import 'owner/add_event_page.dart';
import 'owner/add_place_page.dart';

class SettingsPage extends StatefulWidget {
  //TODO: Add Links to Share, Policy and Contact Us
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _isOwner = false;

  @override
  void initState() {
    _isOwner = FirebaseAuth.instance.currentUser.phoneNumber == auth.owner;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161D),
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: const Color(0xFF892CDC),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 8.0),
            child: FlatButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              label: Text(
                "Share",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 8.0),
            child: FlatButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.help,
                color: Colors.white,
              ),
              label: Text(
                "Policy",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 8.0),
            child: FlatButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
              label: Text(
                "Contact Us",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ),
          _isOwner
              ? Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 8.0),
                        child: FlatButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddPlacePage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.admin_panel_settings,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Add Place",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 8.0),
                        child: FlatButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddEventPage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.admin_panel_settings,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Add Event",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 8.0),
                        child: FlatButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => EntrancePage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.admin_panel_settings,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Entrance",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(height: 10.0),
          Spacer(),
          Divider(
            color: Colors.grey[800],
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.white70,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Log Out",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
