import 'dart:convert';

import 'package:GuestInMe/Settings/owner/http_requests.dart';
import 'package:GuestInMe/models/event_model.dart';
import 'package:GuestInMe/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../auth/auth.dart' as auth;

class PaymentProvider with ChangeNotifier {
  Razorpay _razorpay = Razorpay();
  User _user = FirebaseAuth.instance.currentUser;
  TypeModel _typeModel;
  EventModel _eventModel;
  UserModel _userModel;

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout({
    @required TypeModel type,
    @required EventModel eventModel,
    @required UserModel userModel,
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
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    String _date = convertDatetoISO(_eventModel.date);
    var _registrationsUrl =
        "${auth.url}registrations/$_date/${_eventModel.eventName}/${_user.phoneNumber}.json?auth=${auth.token}";
    var _encodedBody = json.encode(
      {
        'name': "${_userModel.name}",
        'bookings': {
          '${_typeModel.typeName}': {
            'price': '${_typeModel.price}',
            'entered': 'false',
          },
        }
      },
    );
    try {
      http.put(_registrationsUrl,
          body: _encodedBody,
          headers: {"Accept": "application/json"}).then((result) {
        print(result.statusCode);
        print(result.body);
      }).then(
        (_) => Fluttertoast.showToast(
          msg: "SUCCESS id: " + response.paymentId,
          timeInSecForIosWeb: 4,
        ),
      );
    } catch (e) {
      throw (e);
    }
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
