import 'package:GuestInMe/Settings/settings_page.dart';
import 'package:GuestInMe/models/user_model.dart';
import 'package:GuestInMe/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../New_Events/new_events_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _init = true;
  var _loading = false;
  var size = Size(0.0, 0.0);
  var _editing = false;
  var _user = FirebaseAuth.instance.currentUser;
  UserModel _userModel;
  String _v;

  String _userName = "";
  String _userGender = "Gender";
  String _userEmail = "";
  String _userDOB = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    if (_init) {
      _userModel = Provider.of<UserProvider>(context).userModel;
    }
    _init = false;
  }

  void formSave() {
    _formKey.currentState.save();
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
            _loading
                ? Center(child: CircularProgressIndicator())
                : Positioned(
                    top: 150 + size.width * 0.3,
                    width: size.width * 0.8,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //editing
                          Container(
                            margin: const EdgeInsets.only(bottom: 50.0),
                            child: CircleAvatar(
                              child: IconButton(
                                icon: Icon(
                                  _editing ? Icons.check : Icons.edit,
                                  color: Colors.white70,
                                ),
                                onPressed: () => {
                                  if (_editing)
                                    {
                                      if (_formKey.currentState.validate())
                                        {
                                          setState(() {
                                            _editing = !_editing;
                                            print("editing: $_editing");
                                          }),
                                          formSave(),
                                          _saveUserDetails(),
                                        }
                                    }
                                  else
                                    {
                                      setState(() {
                                        _editing = !_editing;
                                        print("editing: $_editing");
                                      })
                                    }
                                },
                              ),
                              backgroundColor: const Color(0xAAC97CFF),
                            ),
                          ),
                          //name field
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Name: ${_userModel?.name}",
                                  hintStyle: TextStyle(
                                    color: Colors.white70,
                                  ),
                                  fillColor: _editing
                                      ? const Color(0x00C97CFF)
                                      : Colors.white70,
                                  filled: true,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  enabled: _editing,
                                ),
                                cursorColor: Colors.white,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                keyboardType: TextInputType.name,
                                validator: (value) => value.isEmpty
                                    ? "Enter Your Name"
                                    : (RegExp('[a-zA-Z]').hasMatch(value)
                                        ? null
                                        : "Enter a Valid Name"),
                                onSaved: (_input) {
                                  setState(() {
                                    _userName = _input;
                                  });
                                }),
                          ),
                          //gender field
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                              value: _v,
                              items: _editing
                                  ? [
                                      DropdownMenuItem(
                                        child: Text("  Male"),
                                        value: "male",
                                      ),
                                      DropdownMenuItem(
                                        child: Text("  Female"),
                                        value: "female",
                                      ),
                                      DropdownMenuItem(
                                        child: Text("  Other"),
                                        value: "other",
                                      ),
                                    ]
                                  : null,
                              isExpanded: true,
                              disabledHint: Text(_userModel?.gender),
                              onChanged: (value) {
                                setState(() {
                                  _v = value;
                                  _userGender = _v;
                                });
                              },
                            ),
                          ),
                          //phone number field
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "${_user.phoneNumber}",
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                ),
                                fillColor: Colors.white70,
                                filled: true,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabled: false,
                              ),
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              onSaved: (_input) => null,
                            ),
                          ),
                          //email field
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Email: ${_userModel?.email}",
                                  hintMaxLines: 2,
                                  hintStyle: TextStyle(
                                    color: Colors.white70,
                                  ),
                                  fillColor: _editing
                                      ? const Color(0x00C97CFF)
                                      : Colors.white70,
                                  filled: true,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  enabled: _editing,
                                ),
                                cursorColor: Colors.white,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (email) =>
                                    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(email)
                                        ? null
                                        : "Enter a valid email",
                                onSaved: (_input) {
                                  setState(() {
                                    _userEmail = _input;
                                  });
                                }),
                          ),
                          _editing
                              ? Container(
                                  margin: const EdgeInsets.all(8.0),
                                  height: 300,
                                  child: CupertinoDatePicker(
                                    onDateTimeChanged: (DateTime _selected) => {
                                      setState(() {
                                        _userDOB = convertDate(_selected);
                                      }),
                                    },
                                    mode: CupertinoDatePickerMode.date,
                                    maximumDate: DateTime.now(),
                                    minimumDate: DateTime(1920),
                                    initialDateTime: DateTime(
                                      int.parse(_userModel.dateOfBirth
                                          .substring(0, 4)),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      const Radius.circular(40.0),
                                    ),
                                    color: const Color(0xAAC97CFF),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText:
                                          "Date of Birth: ${_userModel.dateOfBirth.substring(6, 8)}/${_userModel.dateOfBirth.substring(4, 6)}/${_userModel.dateOfBirth.substring(0, 4)}",
                                      hintStyle: TextStyle(
                                        color: Colors.white70,
                                      ),
                                      fillColor: Colors.white70,
                                      filled: true,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      enabled: false,
                                    ),
                                    cursorColor: Colors.white,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    keyboardType: TextInputType.name,
                                    onSaved: (_input) => null,
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

  void _saveUserDetails() {
    print(
        "Name: $_userName, Gender: $_userGender, Email: $_userEmail, DOB: $_userDOB");
    var _sendUser = UserModel(
      name: _userName,
      gender: _userGender,
      phoneNumber: _user.phoneNumber,
      email: _userEmail,
      frequency: "infinite",
      place: "Mumbai",
      dateOfBirth: _userDOB,
    );
    UserProvider().putUser(_sendUser);
  }

  String convertDate(DateTime value) {
    String _datePicked;
    if (value.month < 10 && value.day < 10) {
      _datePicked = "${value.year}0${value.month}0${value.day}";
    } else if (value.day < 10) {
      _datePicked = "${value.year}${value.month}0${value.day}";
    } else if (value.month < 10) {
      _datePicked = "${value.year}0${value.month}${value.day}";
    } else {
      _datePicked = "${value.year}${value.month}${value.day}";
    }
    print("Date: $_datePicked");
    return _datePicked;
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
