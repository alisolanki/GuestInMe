import 'dart:io';
import 'dart:math';

import 'package:GuestInMe/models/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class TicketGenerator extends StatefulWidget {
  final EventModel eventModel;
  final bool paid;
  final TypeModel typeModel;
  TicketGenerator({
    @required this.eventModel,
    @required this.paid,
    @required this.typeModel,
  });

  @override
  _TicketGeneratorState createState() => _TicketGeneratorState();
}

class _TicketGeneratorState extends State<TicketGenerator> {
  var _loading = true;
  String _docPath;
  final _code = Random().nextInt(9000) + 1000;

  final pdf = pw.Document(
    author: "GuestInMe",
    creator: "${FirebaseAuth.instance.currentUser.phoneNumber}",
  );

  @override
  void initState() {
    super.initState();
    writeOnPdf();
    savePdf().then(
      (_) => setState(() {
        _loading = false;
      }),
    );
  }

  writeOnPdf() {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32.0),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Text(
                "GuestInMe Ticket for ${widget.eventModel.eventName} - ${widget.eventModel.placeName}",
              ),
            ),
            pw.Paragraph(text: "Type: ${widget.typeModel.typeName}"),
            pw.Paragraph(
                text: "Additional Info: ${widget.typeModel.description}"),
            pw.Paragraph(text: "Place: ${widget.eventModel.placeName}"),
            pw.Paragraph(
              text:
                  "Date and Time: ${widget.eventModel.date} at ${widget.eventModel.time}",
            ),
            pw.Paragraph(text: "Age Limit: ${widget.eventModel.ageLimit}"),
            pw.Paragraph(text: "Dress code: ${widget.eventModel.dressCode}"),
            pw.Paragraph(text: "Price: Rs.${widget.typeModel.price}"),
            pw.Paragraph(text: "Paid: ${widget.paid}"),
            pw.Paragraph(
              text:
                  "Code: $_code. Show this code at the entrance of the venue.",
            ),
          ];
        },
      ),
    );
  }

  Future savePdf() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();

    _docPath = docDirectory.path;

    File _file = File(
      "$_docPath/GuestInMe ticket ${widget.eventModel.eventName}.pdf",
    );

    _file.writeAsBytesSync(pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Scaffold(
            appBar: AppBar(
              title: Text("Your ticket"),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : PDFViewerScaffold(
            path:
                "$_docPath/GuestInMe ticket ${widget.eventModel.eventName}.pdf",
          );
  }
}
