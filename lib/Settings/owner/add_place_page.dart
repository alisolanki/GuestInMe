import 'package:guestinme/models/place_model.dart';
import 'package:guestinme/providers/locations_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import './http_requests.dart';

class AddPlacePage extends StatefulWidget {
  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _formKey = GlobalKey<FormState>();
  PlaceModel _placeModel;
  LocationsProvider _locationsProvider;

  String _placeName, _category, _description, _address, _location, _logo;
  List<String> _menu = [], _images = [];
  double _stars;

  int _imageNum = 0;
  int _menuNum = 0;

  @override
  void didChangeDependencies() {
    _locationsProvider = Provider.of<LocationsProvider>(context);
    super.didChangeDependencies();
  }

  void formSave() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _placeModel = PlaceModel(
        category: _category,
        description: _description,
        images: _images,
        address: _location,
        logo: _logo,
        menu: _menu,
        stars: _stars,
        placeName: _placeName,
      );
      Fluttertoast.showToast(
        msg: 'Sending data...',
        backgroundColor: Colors.amber,
      );
      await TransferData(location: _location).addPlace(
        placeModel: _placeModel,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var _locationsList = _locationsProvider.locations;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Place"),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    value: _locationsList.length != 0 ? _location : null,
                    items: _locationsList.map((_l) {
                      return DropdownMenuItem(
                        child: Text("${_l.toString()}"),
                        value: _l,
                      );
                    }).toList(),
                    isExpanded: true,
                    disabledHint: Text("Location"),
                    onChanged: (value) {
                      setState(() {
                        _location = value;
                      });
                    },
                  ),
                ),
                _textField("Place Name"),
                _textField("Description"),
                _textField("Category"),
                // Images
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Place images",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (_images.length != 0) {
                                _images.removeLast();
                              }
                              if (_imageNum > 0) {
                                setState(() {
                                  _imageNum = _imageNum - 1;
                                });
                              }
                            }),
                        Text(
                          "$_imageNum",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => setState(() {
                            _imageNum = _imageNum + 1;
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                //Images list
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _imageNum,
                  itemBuilder: (context, _i) {
                    return _imageField(_i);
                  },
                ),
                _textField("Address"),
                _textField("Logo"),
                _textField("Stars"),
                // Menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Menu images",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (_menu.length != 0) {
                                _menu.removeLast();
                              }
                              if (_menuNum > 0) {
                                setState(() {
                                  _menuNum = _menuNum - 1;
                                });
                              }
                            }),
                        Text(
                          "$_menuNum",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => setState(() {
                            _menuNum = _menuNum + 1;
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                //Menu list
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _menuNum,
                  itemBuilder: (context, _i) {
                    return _menuField(_i);
                  },
                ),
                //submit
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RaisedButton.icon(
                      icon: Icon(
                        Icons.check,
                        size: 20.0,
                      ),
                      label: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      color: Colors.purple[700],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        formSave();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageField(int _i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        initialValue: "https://i.imgur.com/NhOXuQY.jpg",
        decoration: InputDecoration(labelText: "Image Link"),
        validator: (v) => v.isEmpty ? "Enter an image link" : null,
        onSaved: (_i) => setState(() {
          _images.add(_i);
        }),
      ),
    );
  }

  Widget _menuField(int _i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        initialValue: "https://i.imgur.com/NhOXuQY.jpg",
        decoration: InputDecoration(labelText: "Menu Link"),
        validator: (v) => v.isEmpty ? "Enter an image link" : null,
        onSaved: (_i) => setState(() {
          _menu.add(_i);
        }),
      ),
    );
  }

  Widget _textField(String hint) {
    return TextFormField(
      key: ValueKey("$hint"),
      initialValue: "$hint",
      decoration: InputDecoration(
        labelText: "$hint",
        labelStyle: TextStyle(
          color: Colors.white70,
        ),
        fillColor: const Color(0x00C97CFF),
        filled: true,
        disabledBorder: InputBorder.none,
      ),
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
      ),
      keyboardType: TextInputType.name,
      validator: (value) => value.isEmpty
          ? "Enter $hint"
          : hint == "Stars" && double.tryParse(value) == null
              ? "Enter a decimal number"
              : null,
      onSaved: (_input) {
        hint == "Place Name"
            ? setState(() {
                _placeName = _input;
              })
            : hint == "Description"
                ? setState(() {
                    _description = _input;
                  })
                : hint == "Category"
                    ? setState(() {
                        _category = _input;
                      })
                    : hint == "Address"
                        ? setState(() {
                            _address = _input;
                          })
                        : hint == "Logo"
                            ? setState(() {
                                _logo = _input;
                              })
                            : setState(() {
                                _stars = double.parse(_input);
                              });
      },
    );
  }
}
