import 'package:GuestInMe/Settings/owner/widgets/user_tile.dart';
import 'package:GuestInMe/models/registration_model.dart';
import 'package:flutter/material.dart';

class PlaceTile extends StatefulWidget {
  final String date;
  final PlaceRegistrationModel _placeRegistrationModel;
  final List<EventRegistrationModel> _eventRegistrationModels;
  PlaceTile(
    this._placeRegistrationModel,
    this._eventRegistrationModels,
    this.date,
  );
  @override
  _PlaceTileState createState() => _PlaceTileState();
}

class _PlaceTileState extends State<PlaceTile> {
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
            title: Text("${widget._placeRegistrationModel.placeName}"),
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
                  ...widget._eventRegistrationModels.map(
                    (e) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        padding: EdgeInsets.only(bottom: 10.0),
                        color: Colors.deepPurple,
                        child: UserTile(
                          e,
                          e.userRegistrationModels,
                          widget.date,
                          widget._placeRegistrationModel.placeName,
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
