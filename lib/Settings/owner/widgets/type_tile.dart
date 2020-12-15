import 'package:GuestInMe/Settings/owner/http_requests.dart';
import 'package:GuestInMe/models/registration_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TypeTile extends StatefulWidget {
  final String _date, _eventName, _userNumber;
  final List<TypeRegistrationModel> _typeRegistrationModels;
  TypeTile(
    this._typeRegistrationModels,
    this._date,
    this._userNumber,
    this._eventName,
  );
  @override
  _TypeTileState createState() => _TypeTileState();
}

class _TypeTileState extends State<TypeTile> {
  var _showTypeDetails = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            borderRadius: _showTypeDetails
                ? const BorderRadius.vertical(top: const Radius.circular(10.0))
                : const BorderRadius.all(const Radius.circular(10.0)),
            color: Colors.deepPurpleAccent,
          ),
          child: ListTile(
            title: Text("${widget._userNumber}"),
            dense: true,
            onTap: () {
              setState(() {
                _showTypeDetails = !_showTypeDetails;
              });
            },
          ),
        ),
        _showTypeDetails
            ? Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.only(bottom: 10.0),
                color: Colors.deepPurpleAccent,
                child: Column(
                  children: widget._typeRegistrationModels
                      .map(
                        (_t) => ListTile(
                          leading: Text("${_t.typeName}"),
                          subtitle:
                              Text("Code: ${_t.code} Name:${_t.userName}"),
                          title: Text("Rs. ${_t.typePrice}"),
                          trailing: IconButton(
                            icon: Icon(
                              _t.paid
                                  ? Icons.check_circle
                                  : Icons.check_box_outline_blank,
                              color: _t.paid ? Colors.green : Colors.amber,
                            ),
                            onPressed: () => {
                              showDialog(
                                context: context,
                                builder: (ctx) => CupertinoAlertDialog(
                                  title: Text("Change entrance state?"),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text("Yes"),
                                      onPressed: () {
                                        setState(() {
                                          _t.paid = !_t.paid;
                                        });
                                        TransferData()
                                            .changeEntranceState(
                                              date: widget._date,
                                              userNumber: widget._userNumber,
                                              eventName: widget._eventName,
                                              typeModel: _t,
                                            )
                                            .then(
                                              (_) => Fluttertoast.showToast(
                                                  msg: "Paid: ${_t.paid}"),
                                            );
                                        Navigator.of(ctx).pop();
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text("No"),
                                      onPressed: () {
                                        print("Didn't change");
                                        Navigator.of(ctx).pop();
                                      },
                                    ),
                                  ],
                                ),
                              )
                            },
                          ),
                          dense: true,
                        ),
                      )
                      .toList(),
                ),
              )
            : SizedBox(height: 0.0)
      ],
    );
  }
}
