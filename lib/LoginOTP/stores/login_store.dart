import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Home/homepage.dart';
import '../pages/login_page.dart';
import '../pages/otp_page.dart';

import '../../auth/auth.dart' as auth;
import 'package:http/http.dart' as http;

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String actualCode;

  @observable
  bool isLoginLoading = false;
  @observable
  bool isOtpLoading = false;

  @observable
  GlobalKey<ScaffoldState> loginScaffoldKey = GlobalKey<ScaffoldState>();
  @observable
  GlobalKey<ScaffoldState> otpScaffoldKey = GlobalKey<ScaffoldState>();

  @observable
  User firebaseUser;

  @action
  Future<bool> isAlreadyAuthenticated() async {
    firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      return true;
    } else {
      return false;
    }
  }

  @action
  Future<void> getCodeWithPhoneNumber(
    BuildContext context,
    String phoneNumber,
  ) async {
    isLoginLoading = true;
    if (phoneNumber.length == 10) {
      phoneNumber = '+91' + phoneNumber;
    }
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber.trim(),
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential auth) async {
          await _auth.signInWithCredential(auth).then((UserCredential value) {
            if (value != null && value.user != null) {
              print('Authentication successful');
              onAuthenticationSuccessful(context, value);
            } else {
              loginScaffoldKey.currentState.showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  content: Text(
                    'Invalid code/invalid authentication',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          }).catchError((_) {
            loginScaffoldKey.currentState.showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                content: Text(
                  'Something has gone wrong, please try later',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          print('Error message: ' + authException.message);
          loginScaffoldKey.currentState.showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Text(
                'The phone number format is incorrect. Please enter your number in this format. [+][country code][number] eg.+919876543210',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
          isLoginLoading = false;
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          actualCode = verificationId;
          isLoginLoading = false;
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const OtpPage()));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          actualCode = verificationId;
        });
  }

  @action
  Future<void> validateOtpAndLogin(BuildContext context, String smsCode) async {
    isOtpLoading = true;
    final AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: actualCode, smsCode: smsCode);

    await _auth.signInWithCredential(_authCredential).catchError((error) {
      isOtpLoading = false;
      otpScaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text(
            'Wrong code ! Please enter the last code received.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }).then((UserCredential authResult) {
      if (authResult != null && authResult.user != null) {
        print('Authentication successful');
        onAuthenticationSuccessful(context, authResult);
      }
    });
  }

  Future<void> onAuthenticationSuccessful(
      BuildContext context, UserCredential result) async {
    isLoginLoading = true;
    isOtpLoading = true;
    firebaseUser = result.user;
    Provider.of<LoginStore>(context, listen: false)
        .isAlreadyAuthenticated()
        .then((result) {
      if (result) {
        // auth.geturls().then(
        //   (_) {
        //     AdvertisementFetcher().fetchAdvertisements().then((fetchedData) {
        // SharedPreferences.getInstance().then(
        //   (prefs) {
        //     String affiliateName = prefs.getString('affiliateName');
        //     if (affiliateName != "none") {
        //       print("affiliate: $affiliateName");
        //       http
        //           .patch(
        //         '${auth.url}/affiliate/$affiliateName/${int.parse(firebaseUser.phoneNumber.substring(1)) * 373}.json?auth=${auth.token}',
        //         headers: {"Accept": "application/json"},
        //         body: jsonEncode(
        //           {'added': '${DateTime.now().toIso8601String()}'},
        //         ),
        //       )
        //           .then((_response) {
        //         print('${_response.body}');
        //         Navigator.of(context).pushAndRemoveUntil(
        //             MaterialPageRoute(
        //                 builder: (_) => HomePage()),
        //             (Route<dynamic> route) => false);
        //       });
        //     } else {
        //       print("affiliate: $affiliateName");
        //       Navigator.of(context).pushAndRemoveUntil(
        //           MaterialPageRoute(
        //               builder: (_) => HomePage()),
        //           (Route<dynamic> route) => false);
        //     }
        //   },
        // );
        //     });
        //   },
        // );
        auth.getTk();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => HomePage()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (Route<dynamic> route) => false);
      }
    });

    isLoginLoading = false;
    isOtpLoading = false;
  }

  @action
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (Route<dynamic> route) => false);
    firebaseUser = null;
  }
}
