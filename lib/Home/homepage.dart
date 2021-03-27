import 'package:guestinme/Home/navigation_page.dart';
import 'package:guestinme/LoginOTP/stores/login_store.dart';
import 'package:guestinme/providers/locations_provider.dart';
import 'package:guestinme/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final bool askDetails;
  HomePage({this.askDetails = false});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // _handleDynamicLink();
    if (widget.askDetails) {
      // _getContactsPermission();
    }
  }

  // Future _getContactsPermission() async {
  //   final _permission = await ContactsUtils.getContactsPermission();

  //   switch (_permission) {
  //     case PermissionStatus.granted:
  //       _uploadContacts();
  //       break;
  //     case PermissionStatus.permanentlyDenied:
  //       break;
  //     default:
  //       Fluttertoast.showToast(
  //         msg: "Please give Contacts permission",
  //         backgroundColor: Colors.red,
  //       );
  //       break;
  //   }
  // }

  // Future _uploadContacts() async {
  //   final _contacts =
  //       (await ContactsService.getContacts(withThumbnails: false)).toList();

  //   await ContactsUtils.uploadContacts(
  //       _contacts, FirebaseAuth.instance.currentUser.phoneNumber);
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => PlaceProvider()),
        // ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LocationsProvider()),
        Provider.value(value: LoginStore()),
      ],
      builder: (ctx, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF16161D),
            backgroundColor: const Color(0xFF16161D),
            // textTheme: ThemeData.dark().textTheme.apply(
            //       fontFamily: 'Noto Sans',
            //     ),
            // // primaryTextTheme: ThemeData.dark().textTheme.apply(
            // //       fontFamily: 'Noto Sans',
            // //     ),
            // // accentTextTheme: ThemeData.dark().textTheme.apply(
            // //       fontFamily: 'Noto Sans',
            // //     ),
          ),
          home: NavigationPage(askDetails: widget.askDetails),
        );
      },
    );
  }
}
