import 'dart:convert';

import 'package:GuestInMe/Event/ticket_generator.dart';
import 'package:GuestInMe/models/event_model.dart';
import 'package:GuestInMe/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../auth/auth.dart' as auth;

class RegistrationHttp {
  // Future _launchURL({
  //   TypeModel typeModel,
  //   int peopleNumber,
  //   EventModel eventModel,
  // }) async {
  //   final url =
  //       'http://wa.me/+918850283085?text=Hey! I would like to book for $peopleNumber ${typeModel.typeName} at ${eventModel.placeName} on ${eventModel.date}';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> sendRegistration({
    @required BuildContext ctx,
    @required EventModel eventModel,
    @required UserModel userModel,
    @required TypeModel typeModel,
    @required int code,
    @required bool paid,
    @required int peopleNumber,
    String referral,
  }) async {
    User _user = FirebaseAuth.instance.currentUser;
    String _date = convertDatetoISO(eventModel.date);
    typeModel.id =
        DateTime.now().toIso8601String().replaceAll(RegExp(r'\.'), ',');
    referral = referral ?? 'null';

    var _bookingsUrl =
        "${auth.url}registrations/$_date/${eventModel.placeName}/${eventModel.id}/${eventModel.eventName}/${_user.phoneNumber}/${typeModel.id}.json?auth=${auth.token}";
    print("_bookingsUrl: $_bookingsUrl");
    var _finalPrice = double.parse(typeModel.price) * peopleNumber;
    var _bookingsBody = json.encode({
      'typeName': '${typeModel.typeName}',
      'code': '$code',
      'price': '$_finalPrice',
      'paid': '$paid',
      'referral': '$referral',
      'name': '${userModel.name}',
    });

    try {
      await http.patch(_bookingsUrl,
          body: _bookingsBody,
          headers: {"Accept": "application/json"}).then((result) {
        print(result.statusCode);
      });
      // Fluttertoast.showToast(
      //   msg: "Message us on +918850283085!",
      //   backgroundColor: Colors.red,
      // );
      // await _launchURL(
      //   eventModel: eventModel,
      //   peopleNumber: peopleNumber,
      //   typeModel: typeModel,
      // );
      Navigator.push(
        ctx,
        MaterialPageRoute(
          builder: (_) => TicketGenerator(
            eventModel: eventModel,
            paid: paid,
            typeModel: typeModel,
            dateISO: _date,
            code: code,
            count: peopleNumber,
            referral: '$referral',
            name: '${userModel.name}',
          ),
        ),
      );
    } catch (e) {
      throw (e);
    }

    //referral
    if (referral != 'null') {
      var _id = int.parse(_user.phoneNumber.substring(1)) * 373;
      var _referralUrl =
          "${auth.url}referrals/$referral/$_date/${eventModel.placeName}/$_id.json?auth=${auth.token}";

      var _referralBody = json.encode({
        'typeName': '${typeModel.typeName}',
        'code': '$code',
        'price': '${typeModel.price}',
        'paid': '$paid'
      });

      try {
        await http.post(_referralUrl,
            body: _referralBody,
            headers: {"Accept": "application/json"}).then((result) {
          print(result.statusCode);
        });
      } catch (e) {
        throw (e);
      }
    }
  }

  String convertDatetoISO(String value) {
    String _month = value.split(" ")[2],
        _day = value.split(" ")[1].split(",")[0],
        _year = value.split(" ")[3];
    String _monthISO;
    switch (_month) {
      case "Jan":
        _monthISO = "01";
        break;
      case "Feb":
        _monthISO = "02";
        break;
      case "Mar":
        _monthISO = "03";
        break;
      case "Apr":
        _monthISO = "04";
        break;
      case "May":
        _monthISO = "05";
        break;
      case "Jun":
        _monthISO = "06";
        break;
      case "Jul":
        _monthISO = "07";
        break;
      case "Aug":
        _monthISO = "08";
        break;
      case "Sep":
        _monthISO = "09";
        break;
      case "Oct":
        _monthISO = "10";
        break;
      case "Nov":
        _monthISO = "11";
        break;
      case "Dec":
        _monthISO = "12";
        break;
      default:
        break;
    }
    if (int.parse(_day) < 10) {
      _day = "0$_day";
    }
    print("Date: $_year$_monthISO$_day");
    return "$_year$_monthISO$_day";
  }
}

class PaymentProvider with ChangeNotifier {
  Razorpay _razorpay = Razorpay();
  User _user = FirebaseAuth.instance.currentUser;
  BuildContext _ctx;
  TypeModel _typeModel;
  EventModel _eventModel;
  UserModel _userModel;
  int _code, _peopleNumber;
  String _referral;

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<void> openCheckout({
    @required BuildContext ctx,
    @required TypeModel type,
    @required EventModel eventModel,
    @required UserModel userModel,
    @required int code,
    @required int peopleNumber,
    String referral,
  }) async {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    var options = {
      'key': auth.razorpaykey,
      'amount': peopleNumber * double.parse(type.price) * 100,
      'name': 'GuestInMe: ${type.typeName}',
      'description':
          'By paying, you have read and accepted all our Terms and Conditions',
      'prefill': {'contact': _user.phoneNumber, 'email': userModel.email},
    };

    try {
      _typeModel = type;
      _eventModel = eventModel;
      _userModel = userModel;
      _code = code;
      _ctx = ctx;
      _referral = referral;
      _peopleNumber = peopleNumber;
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    RegistrationHttp().sendRegistration(
      ctx: _ctx,
      eventModel: _eventModel,
      userModel: _userModel,
      typeModel: _typeModel,
      code: _code,
      paid: true,
      referral: _referral,
      peopleNumber: _peopleNumber,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "ERROR: " + response.code.toString() + " - " + response.message,
      timeInSecForIosWeb: 4,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "EXTERNAL_WALLET: " + response.walletName,
      timeInSecForIosWeb: 4,
    );
  }
}
