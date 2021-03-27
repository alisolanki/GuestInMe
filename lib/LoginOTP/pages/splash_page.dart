import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Home/homepage.dart';
import '../pages/login_page.dart';
import '../stores/login_store.dart';
import '../../auth/auth.dart' as auth;

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<LoginStore>(context).isAlreadyAuthenticated().then(
      (result) {
        if (result) {
          auth.getTk().then(
                (_) => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => HomePage()),
                    (Route<dynamic> route) => false),
              );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (Route<dynamic> route) => false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161D),
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.purple),
        ),
      ),
    );
  }
}
