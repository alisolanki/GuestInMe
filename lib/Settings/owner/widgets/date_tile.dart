import 'package:GuestInMe/Settings/owner/widgets/place_tile.dart';
import 'package:GuestInMe/models/registration_model.dart';
import 'package:flutter/material.dart';

class DateTile extends StatefulWidget {
  final DateModel _dateModel;
  DateTile(this._dateModel);
  @override
  _DateTileState createState() => _DateTileState();
}

class _DateTileState extends State<DateTile> {
  var _showDateDetails = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          decoration: BoxDecoration(
            borderRadius: _showDateDetails
                ? const BorderRadius.vertical(top: const Radius.circular(10.0))
                : const BorderRadius.all(const Radius.circular(10.0)),
            color: Colors.purple,
          ),
          child: ListTile(
            title: Text("${widget._dateModel.date}"),
            onTap: () {
              setState(() {
                _showDateDetails = !_showDateDetails;
              });
            },
          ),
        ),
        _showDateDetails
            ? Column(
                children: [
                  ...widget._dateModel.placeRegistrationModels.map(
                    (e) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        padding: EdgeInsets.only(bottom: 10.0),
                        color: Colors.purple,
                        child: PlaceTile(
                          e,
                          e.eventRegistrationModels,
                          widget._dateModel.date,
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
