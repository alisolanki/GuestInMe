import 'dart:convert';
import 'dart:io';

import 'package:guestinme/Profile/tickets_page.dart';
import 'package:guestinme/Profile/view_ticket_page.dart';
import 'package:guestinme/models/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class TicketGenerator extends StatefulWidget {
  final EventModel eventModel;
  final bool paid;
  final TypeModel typeModel;
  final int code, count;
  final String name, referral, dateISO;
  TicketGenerator({
    @required this.eventModel,
    @required this.paid,
    @required this.typeModel,
    @required this.code,
    @required this.name,
    @required this.dateISO,
    @required this.referral,
    this.count = 1,
  });

  @override
  _TicketGeneratorState createState() => _TicketGeneratorState();
}

class _TicketGeneratorState extends State<TicketGenerator> {
  pw.MemoryImage _logoImage;
  Directory _docApp;
  String _ticketData;

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
              CupertinoPageRoute(
                builder: (context) => TicketsPage(),
              ),
            );
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => ViewTicketPage(
                  "${_docApp.path}/tickets/${widget.eventModel.date} ${widget.typeModel.typeName}x${widget.count} ${widget.code}.pdf",
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> getFiles() async {
    // _logoImage = PdfImage.file(
    //   pdf.document,
    //   bytes:
    //       (await rootBundle.load('assets/logofilled.png')).buffer.asUint8List(),
    // );
    _logoImage = pw.MemoryImage((await rootBundle.load('assets/logofilled.png')).buffer.asUint8List());
    var _phoneNumber = FirebaseAuth.instance.currentUser.phoneNumber;
    _ticketData =
        "${widget.dateISO}::${widget.eventModel.placeName}::${widget.eventModel.id}::${widget.eventModel.eventName}::$_phoneNumber::${widget.typeModel.id}::${widget.code}::${widget.name}::${widget.paid}::${double.parse(widget.typeModel.price) * widget.count}::${widget.referral}::${widget.typeModel.typeName}";
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
                border: pw.Border.all(color: PdfColors.black),
                borderRadius: pw.BorderRadius.all(
                  pw.Radius.circular(3.0),
                ),
              ),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Paragraph(
                    text:
                        "${widget.count} Ticket/s for ${widget.typeModel.typeName}",
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
                              ? "Price: Rs.${widget.typeModel.price} x ${widget.count} paid."
                              : "Price: Rs.${widget.typeModel.price} x ${widget.count} to be paid at entrance.",
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
            pw.Center(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: <pw.Widget>[
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(16.0),
                    child: pw.Text(
                      "Get the QR code scanned at the entrance.",
                      style: pw.TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  pw.BarcodeWidget(
                    color: PdfColor.fromHex("#000000"),
                    height: 200.0,
                    width: 200.0,
                    barcode: pw.Barcode.qrCode(),
                    data: "ila${utf8.fuse(base64).encode('$_ticketData')}",
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
        "${_docTickets.path}/${widget.eventModel.date} ${widget.typeModel.typeName}x${widget.count} ${widget.code}.pdf",
      );
      _file.writeAsBytesSync(await pdf.save());
    } else {
      File _file = File(
        "${_docTickets.path}/${widget.eventModel.date} ${widget.typeModel.typeName}x${widget.count} ${widget.code}.pdf",
      );
      _file.writeAsBytesSync(await pdf.save());
      print(
          "${_docApp.path}/tickets/${widget.eventModel.date} ${widget.typeModel.typeName}x${widget.count} ${widget.code}.pdf");
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
