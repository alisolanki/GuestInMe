import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './LoginOTP/stores/login_store.dart';
import './LoginOTP/pages/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _name = "none";

  @override
  void initState() {
    super.initState();
    // _handleDynamicLink();
  }

  Future _handleDynamicLink() async {
    //Started the app through Dynamic Link
    final PendingDynamicLinkData _data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri _deeplink = _data?.link;
    if (_deeplink != null) {
      print('_handleDeepLink | _deeplink: $_deeplink');
      if (_deeplink.pathSegments.contains('post')) {
        _name = _deeplink.queryParameters['name'];
        print("_name = ${_deeplink.queryParameters['name']}");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('affiliateName', _name);
        Fluttertoast.showToast(
          msg: "Invited by: $_name",
          backgroundColor: Colors.purple,
        );
      }
    }
    //If app is in the background
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData _dynamicLink) async {
        final Uri _dynamicdeeplink = _dynamicLink?.link;

        if (_dynamicdeeplink != null) {
          print('_handleDynamicLink | _dynamicdeeplink: $_dynamicdeeplink');
          if (_deeplink.pathSegments.contains('post')) {
            _name = _deeplink.queryParameters['name'];
            print("_name = ${_deeplink.queryParameters['name']}");
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('affiliateName', _name);
            Fluttertoast.showToast(
              msg: "Invited by: $_name",
              backgroundColor: Colors.purple,
            );
          }
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError: ${e.message}');
        throw (e.message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return throw ("Firebase.initializeApp() went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Provider.value(
            value: LoginStore(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashPage(),
              theme: ThemeData.dark(),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
