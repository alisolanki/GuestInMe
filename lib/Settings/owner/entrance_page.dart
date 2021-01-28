import 'package:GuestInMe/Settings/owner/http_requests.dart';
import 'package:GuestInMe/models/registration_model.dart';
import 'package:flutter/material.dart';

import 'widgets/date_tile.dart';

class EntrancePage extends StatefulWidget {
  @override
  _EntrancePageState createState() => _EntrancePageState();
}

class _EntrancePageState extends State<EntrancePage> {
  RegistrationModel _registrationModel;

  void refresh() {
    TransferData().getEntranceState().then((_data) {
      setState(() {
        _registrationModel = _data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrance Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, _i) => Container(
                child: _registrationModel == null
                    ? SizedBox(height: 0.0)
                    : DateTile(
                        _registrationModel.dateModels[
                            _registrationModel.dateModels.length - _i - 1],
                      ),
              ),
              itemCount: _registrationModel == null
                  ? 0
                  : _registrationModel.dateModels.length,
            ),
          )
        ],
      ),
    );
  }
}
