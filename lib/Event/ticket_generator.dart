import 'dart:io';
import 'dart:math';

import 'package:GuestInMe/Profile/tickets_page.dart';
import 'package:GuestInMe/Profile/view_ticket_page.dart';
import 'package:GuestInMe/models/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class TicketGenerator extends StatefulWidget {
  final EventModel eventModel;
  final bool paid;
  final TypeModel typeModel;
  final int code;
  TicketGenerator({
    @required this.eventModel,
    @required this.paid,
    @required this.typeModel,
    @required this.code,
  });

  @override
  _TicketGeneratorState createState() => _TicketGeneratorState();
}

class _TicketGeneratorState extends State<TicketGenerator> {
  PdfImage _logoImage;
  Directory _docApp;

  final pw.Document pdf = pw.Document(
    author: "GuestInMe",
    creator: "${FirebaseAuth.instance.currentUser.phoneNumber}",
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getFiles().then(
      (_) {
        writeOnPdf();
        savePdf().then(
          (_) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TicketsPage(),
              ),
            );
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ViewTicketPage(
                  "${_docApp.path}/tickets/${widget.eventModel.date} ${widget.typeModel.typeName} ${widget.code}.pdf",
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> getFiles() async {
    _logoImage = PdfImage.file(
      pdf.document,
      bytes:
          (await rootBundle.load('assets/logofilled.png')).buffer.asUint8List(),
    );
  }

  void writeOnPdf() {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32.0),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Row(
                children: <pw.Widget>[
                  pw.Container(
                    height: 60.0,
                    padding: pw.EdgeInsets.all(2.0),
                    child: pw.Image(_logoImage),
                  ),
                  pw.Text(
                    "GuestInMe",
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#CB6CE6"),
                      fontSize: 40.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Spacer(),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 80.0),
                    child: pw.Text(
                      "#${widget.code}",
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Container(
              width: double.maxFinite,
              padding: pw.EdgeInsets.all(8.0),
              alignment: pw.Alignment.topLeft,
              decoration: pw.BoxDecoration(
                border: pw.BoxBorder(
                  color: PdfColors.black,
                ),
                borderRadius: 3.0,
              ),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Paragraph(
                    text: "1 Ticket for ${widget.typeModel.typeName}",
                    style: pw.TextStyle(
                      fontSize: 25.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Paragraph(
                    text:
                        "${widget.eventModel.eventName} at ${widget.eventModel.placeName}",
                    style: pw.TextStyle(
                      fontSize: 23.0,
                    ),
                  ),
                  //price
                  widget.typeModel.price == "0"
                      ? pw.Paragraph(
                          text: "Free Entry",
                          style: pw.TextStyle(
                            fontSize: 20.0,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        )
                      : pw.Paragraph(
                          text: widget.paid
                              ? "Price: Rs.${widget.typeModel.price} paid."
                              : "Price: Rs.${widget.typeModel.price} to be paid at entrance.",
                          style: pw.TextStyle(
                            fontSize: 20.0,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                  //details
                  pw.Paragraph(
                    text: "Event Details: ${widget.eventModel.description}",
                    style: pw.TextStyle(
                      fontSize: 18.0,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                  //ageLimit and dressCode
                  pw.Row(
                    children: [
                      pw.Paragraph(
                        text: "Age Limit: ${widget.eventModel.ageLimit}",
                        style: pw.TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(left: 10.0),
                        child: pw.Paragraph(
                          text: "Dress Code: ${widget.eventModel.dressCode}",
                          style: pw.TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //date and time
                  pw.Paragraph(
                    text:
                        "Date and Time: ${widget.eventModel.time} on ${widget.eventModel.date}",
                    style: pw.TextStyle(
                      fontSize: 18.0,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                  //Terms and Conditions
                  pw.Paragraph(
                    text:
                        "The venue owner recides the final right for entry. Refund of the ticket will only be made if the event is cancelled. By issuing this ticket you have agreed with the terms and conditions of both the venue and GuestInMe.",
                    style: pw.TextStyle(
                      fontSize: 12.0,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }

  Future<void> savePdf() async {
    _docApp = await getApplicationDocumentsDirectory();

    Directory _docTickets = Directory('${_docApp.path}/tickets');

    if (!await _docTickets.exists()) {
      _docTickets = await _docTickets.create(recursive: true);
      File _file = File(
        "${_docTickets.path}/${widget.eventModel.date} ${widget.typeModel.typeName} ${widget.code}.pdf",
      );
      _file.writeAsBytesSync(pdf.save());
    } else {
      File _file = File(
        "${_docTickets.path}/${widget.eventModel.date} ${widget.typeModel.typeName} ${widget.code}.pdf",
      );
      _file.writeAsBytesSync(pdf.save());
      print(
          "${_docApp.path}/tickets/${widget.eventModel.date} ${widget.typeModel.typeName} ${widget.code}.pdf");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your ticket"),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
