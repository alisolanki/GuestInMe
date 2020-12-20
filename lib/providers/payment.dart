import 'dart:convert';

import 'package:GuestInMe/Event/ticket_generator.dart';
import 'package:GuestInMe/models/event_model.dart';
import 'package:GuestInMe/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../auth/auth.dart' as auth;

class RegistrationHttp {
  Future<void> sendRegistration({
    @required BuildContext ctx,
    @required EventModel eventModel,
    @required UserModel userModel,
    @required TypeModel typeModel,
    @required int code,
    @required bool paid,
  }) async {
    User _user = FirebaseAuth.instance.currentUser;
    String _date = convertDatetoISO(eventModel.date);

    var _bookingsUrl =
        "${auth.url}registrations/$_date/${eventModel.eventName}/${_user.phoneNumber}/bookings/${typeModel.typeName} :: $code.json?auth=${auth.token}";

    var _bookingsBody = json.encode({
      'code': '$code',
      'price': '${typeModel.price}',
      'paid': '$paid',
      'name': '${userModel.name}'
    });

    try {
      await http.patch(_bookingsUrl,
          body: _bookingsBody,
          headers: {"Accept": "application/json"}).then((result) {
        print(result.statusCode);
      });
      Fluttertoast.showToast(
        msg: "Ticket will be available in Profile -> My Tickets",
        backgroundColor: Colors.amber,
      );
      Navigator.push(
        ctx,
        MaterialPageRoute(
          builder: (_) => TicketGenerator(
            eventModel: eventModel,
            paid: paid,
            typeModel: typeModel,
            code: code,
          ),
        ),
      );
    } catch (e) {
      throw (e);
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
  int _code;

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
  }) async {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    var options = {
      'key': auth.razorpaykey,
      'amount': double.parse(type.price),
      'name': 'GuestInMe: ${type.typeName}',
      'description': 'By paying you accept all the Terms and Conditions',
      'prefill': {'contact': _user.phoneNumber, 'email': userModel.email},
    };

    try {
      _typeModel = type;
      _eventModel = eventModel;
      _userModel = userModel;
      _code = code;
      _ctx = ctx;
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
