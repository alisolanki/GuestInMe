import 'dart:io';
import 'package:GuestInMe/Profile/view_ticket_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class TicketsPage extends StatefulWidget {
  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  String _dirPath;
  List<FileSystemEntity> _files = [];

  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  // Make New Function
  void _listofFiles() async {
    _dirPath = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      _files = Directory("$_dirPath/tickets/").listSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Tickets"),
      ),
      body: ListView.builder(
        itemCount: _files.length,
        itemBuilder: (ctx, _i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: Colors.deepPurpleAccent,
              ),
              child: ListTile(
                leading: Icon(Icons.book_online),
                title: Text(_files[_i].path.split('/').last),
                trailing: IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.shareFiles([_files[_i].path],
                        subject:
                            "GuestInMe Ticket. Download our app for getting into Guestlists, Booking tables and having your Nightlife sorted. Book concert tickets at extremely cheap prices.");
                  },
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewTicketPage("${_files[_i].path}"),
                    ),
                  );
                  print("path: ${_files[_i].path}");
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
