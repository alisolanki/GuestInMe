import 'package:GuestInMe/LoginOTP/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
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
          FlatButton.icon(
            padding: const EdgeInsets.only(top: 30.0, left: 8.0),
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
          FlatButton.icon(
            padding: const EdgeInsets.only(top: 30.0, left: 8.0),
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
          FlatButton.icon(
            padding: const EdgeInsets.only(top: 30.0, left: 8.0),
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
          Spacer(),
          Divider(
            color: Colors.grey[800],
          ),
          FlatButton.icon(
            padding: const EdgeInsets.only(bottom: 20.0, left: 8.0),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (Route<dynamic> route) => false);
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white70,
            ),
            label: Text(
              "Log Out",
              style: TextStyle(color: Colors.white70, fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}
