import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:share/share.dart';

class ViewTicketPage extends StatelessWidget {
  final String _path;
  ViewTicketPage(this._path);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      path: _path,
      appBar: AppBar(
        title: Text("Your Ticket"),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.shareFiles([_path],
                  subject:
                      "GuestInMe Ticket. Download our app for getting into Guestlists, Booking tables and having your Nightlife sorted. Book concert tickets at extremely cheap prices.");
            },
          )
        ],
      ),
    );
  }
}
