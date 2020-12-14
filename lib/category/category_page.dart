import 'package:GuestInMe/Home/widgets/place_card.dart';
import 'package:GuestInMe/models/place_model.dart';
import 'package:GuestInMe/providers/place_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  final String _category;
  CategoryPage(this._category);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<PlaceModel> _placeModels;

  @override
  void didChangeDependencies() {
    _placeModels = Provider.of<PlaceProvider>(context)
        .places
        .where((_place) =>
            _place.category.toLowerCase() == widget._category.toLowerCase())
        .toList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161D),
      appBar: AppBar(
        title: Text("${widget._category}"),
        backgroundColor: const Color(0xFF52057b),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: PlaceCard(
              placeModel: _placeModels[i],
            ),
          ),
          itemCount: _placeModels.length,
        ),
      ),
    );
  }
}
