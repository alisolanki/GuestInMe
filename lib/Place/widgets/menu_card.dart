import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MenuCard extends StatelessWidget {
  final String _menu;
  MenuCard(this._menu);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.chevron_left,
            size: 40.0,
            color: Colors.white,
          ),
          backgroundColor: Colors.deepPurpleAccent,
          onPressed: () => Navigator.pop(context),
        ),
        body: PhotoView(
          imageProvider: NetworkImage(_menu),
          maxScale: PhotoViewComputedScale.covered,
          minScale: PhotoViewComputedScale.contained,
        ),
      ),
    );
  }
}
