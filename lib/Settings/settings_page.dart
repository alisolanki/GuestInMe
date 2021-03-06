import 'package:GuestInMe/LoginOTP/pages/login_page.dart';
import 'package:GuestInMe/Settings/owner/entrance_page.dart';
import 'package:GuestInMe/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'owner/add_event_page.dart';
import 'owner/add_place_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _isOwner = false;

  @override
  void didChangeDependencies() {
    _isOwner = Provider.of<UserProvider>(context, listen: false).ownerStatus;
    super.didChangeDependencies();
  }

  _launchURL(bool _policy) async {
    final url = _policy
        ? 'https://www.guestinme.com/terms-and-conditions'
        : 'http://wa.me/+918850283085?text=Hey!%20I%20would%20like%20to%20talk%20to%20you%20regarding%20GuestInMe';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161D),
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 8.0),
            child: FlatButton.icon(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              label: Text(
                "Share",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: () => Share.share(
                "Download our app for getting into Guestlists, Booking tables and having your Nightlife sorted. Also book Concert tickets at extremely cheap prices. *GuestInMe PlayStore App*: https://play.google.com/store/apps/details?id=com.guestinme.guestinme",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 8.0),
            child: FlatButton.icon(
              icon: Icon(
                Icons.help,
                color: Colors.white,
              ),
              label: Text(
                "Policy",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: () => _launchURL(true),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 8.0),
            child: FlatButton.icon(
              icon: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
              label: Text(
                "Contact Us",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: () => _launchURL(false),
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
                            CupertinoPageRoute(
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
                            CupertinoPageRoute(
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
                            CupertinoPageRoute(
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
          //logout
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
                  CupertinoPageRoute(builder: (_) => const LoginPage()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
