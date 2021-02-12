import 'dart:io';
import 'package:GuestInMe/Profile/view_ticket_page.dart';
import 'package:flutter/cupertino.dart';
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

  Future<bool> confirmDelete() async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text("Delete ticket forever?"),
        content: Text("This action cannot be undone."),
        actions: [
          CupertinoDialogAction(
            child: Text("Delete"),
            isDestructiveAction: true,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
          CupertinoDialogAction(
            child: Text("Cancel"),
            isDefaultAction: true,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161D),
      appBar: AppBar(
        title: Text("My Tickets"),
      ),
      body: ListView.builder(
        itemCount: _files.length,
        itemBuilder: (ctx, _i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Dismissible(
              key: UniqueKey(),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          Share.shareFiles([_files[_i].path],
                              subject:
                                  "GuestInMe Ticket. Download our app for getting into Guestlists, Booking tables and having your Nightlife sorted. Book concert tickets at extremely cheap prices.");
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          if(await confirmDelete()){
                            print("Deleting");
                setState(() {
                  _files[_i].delete();
                  _files.removeAt(_i);
                });
                          }else{
                            print("Not deleting");
                          }
                        },
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) =>
                            ViewTicketPage("${_files[_i].path}"),
                      ),
                    );
                    print("path: ${_files[_i].path}");
                  },
                ),
              ),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.red,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete_forever,
                  size: 30.0,
                ),
              ),
              confirmDismiss: (_) async => await confirmDelete(),
              onDismissed: (_) {
                print("Deleting");
                setState(() {
                  _files[_i].delete();
                  _files.removeAt(_i);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
