import 'package:GuestInMe/Settings/owner/widgets/type_tile.dart';
import 'package:GuestInMe/models/registration_model.dart';
import 'package:flutter/material.dart';

class UserTile extends StatefulWidget {
  final String date;
  final EventRegistrationModel _eventRegistrationModel;
  final List<UserRegistrationModel> _userRegistrationModels;
  UserTile(
    this._eventRegistrationModel,
    this._userRegistrationModels,
    this.date,
  );
  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  var _showUserDetails = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            borderRadius: _showUserDetails
                ? const BorderRadius.vertical(top: const Radius.circular(10.0))
                : const BorderRadius.all(const Radius.circular(10.0)),
            color: Colors.deepPurple,
          ),
          child: ListTile(
            title: Text("${widget._eventRegistrationModel.eventName}"),
            dense: true,
            onTap: () {
              setState(() {
                _showUserDetails = !_showUserDetails;
              });
            },
          ),
        ),
        _showUserDetails
            ? Column(
                children: [
                  ...widget._userRegistrationModels.map(
                    (e) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        padding: EdgeInsets.only(bottom: 10.0),
                        color: Colors.deepPurple,
                        child: TypeTile(
                          e.typeRegistrationModels,
                          widget.date,
                          e.phoneNumber,
                          widget._eventRegistrationModel.eventName,
                          widget._eventRegistrationModel.id,
                        ),
                      );
                    },
                  ).toList(),
                ],
              )
            : SizedBox(height: 0.0)
      ],
    );
  }
}
