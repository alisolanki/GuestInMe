// import 'package:contacts_service/contacts_service.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ContactsUtils {
//   static Future<PermissionStatus> getContactsPermission() async {
//     final permission = await Permission.contacts.status;

//     if (permission != PermissionStatus.granted &&
//         permission != PermissionStatus.permanentlyDenied) {
//       final newPermission = await Permission.contacts.request();

//       return newPermission ?? PermissionStatus.undetermined;
//     } else {
//       return permission;
//     }
//   }

//   static Future uploadContacts(List<Contact> contacts, String number) async {
//     final contactsJson = (contacts.map((c) => c.toMap())).toList();

//     final refUser = FirebaseFirestore.instance.collection('users');

//     await refUser.add({
//       'number': '$number',
//       'contacts': contactsJson,
//     });
//   }
// }
