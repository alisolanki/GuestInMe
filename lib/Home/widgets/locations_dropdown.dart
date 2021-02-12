import 'package:GuestInMe/providers/locations_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationsDropDown extends StatefulWidget {
  final List<dynamic> locations;
  LocationsDropDown(this.locations);

  @override
  _LocationsDropDownState createState() => _LocationsDropDownState();
}

class _LocationsDropDownState extends State<LocationsDropDown> {
  @override
  Widget build(BuildContext context) {
    var _selectedLocation =
        Provider.of<LocationsProvider>(context).selectedLocation;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
          hint: Text("Select location"),
          value: _selectedLocation,
          items: widget.locations.map((_l) {
            return DropdownMenuItem<String>(
              value: _l,
              child: Text(_l),
            );
          }).toList(),
          dropdownColor: Colors.black,
          onChanged: (_l) {
            Provider.of<LocationsProvider>(context, listen: false)
                .setSelectedLocation(_l);
          }),
    );
  }
}
