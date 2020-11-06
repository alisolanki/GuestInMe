import 'package:GuestInMe/Settings/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var size = Size(0.0, 0.0);
  var _editing = false;
  var _user = FirebaseAuth.instance.currentUser;
  var _value = 1;

  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              child: Container(
                width: size.width,
                height: size.height,
              ),
              painter: HeaderCurvedContainer(),
            ),
            Positioned(
              top: 120.0,
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.png'),
                radius: size.width * 0.15,
                backgroundColor: Colors.transparent,
              ),
            ),
            Positioned(
              top: 10.0,
              right: 10.0,
              child: Container(
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SettingsPage(),
                      ),
                    ),
                  },
                ),
              ),
            ),
            Positioned(
              top: 150 + size.width * 0.3,
              height: size.height,
              width: size.width * 0.8,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    formField("Name", "name"),
                    _editing
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                              value: _value,
                              items: [
                                DropdownMenuItem(
                                  child: Text("  Male"),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text("  Female"),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                  child: Text("  Other"),
                                  value: 3,
                                ),
                              ],
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  _value = value;
                                });
                              },
                            ),
                          )
                        : formField("Gender", "gender"),
                    formField("${_user.phoneNumber}", "number"),
                    formField("Email", "email"),
                    _editing
                        ? Container(
                            margin: const EdgeInsets.all(8.0),
                            height: 300,
                            child: CupertinoDatePicker(
                              onDateTimeChanged: (DateTime _selected) => {
                                //TODO: Save DOB
                              },
                              mode: CupertinoDatePickerMode.date,
                              maximumDate: DateTime.now(),
                              minimumDate: DateTime(1920),
                              initialDateTime: DateTime(2001),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                const Radius.circular(40.0),
                              ),
                              color: const Color(0xAAC97CFF),
                            ),
                          )
                        : formField("Date of Birth", "dob"),
                    Container(
                      margin: const EdgeInsets.only(bottom: 50.0),
                      child: CircleAvatar(
                        child: IconButton(
                          icon: Icon(
                            _editing ? Icons.check : Icons.edit,
                            color: Colors.white70,
                          ),
                          onPressed: () => {
                            setState(() {
                              _editing = !_editing;
                              print("editing: $_editing");
                            }),
                          },
                        ),
                        backgroundColor: const Color(0xAAC97CFF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget formField(String _hint, String _type) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "$_hint",
          hintStyle: TextStyle(
            color: Colors.white70,
          ),
          fillColor: _editing && _type != "number"
              ? const Color(0x00C97CFF)
              : Colors.white70,
          filled: true,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabled: _type == "number" ? false : _editing,
        ),
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
        ),
        keyboardType:
            _type == "email" ? TextInputType.emailAddress : TextInputType.name,
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFF892CDC);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 250, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
