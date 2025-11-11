// import 'package:another_telephony/telephony.dart';
// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:testing/Datasource/DataHelper.dart';
// import 'package:testing/model%20/Contact.dart';
// import 'package:testing/views/Home/Utils/HomePageContactTile.dart';
// import 'Utils/ContactAddDialog.dart';

// class ContactList extends StatefulWidget {
//   const ContactList({super.key, required this.db, required this.users});
//   final Database db;
//   final List<User> users;

//   @override
//   State<ContactList> createState() => _ContactListState();
// }

// class _ContactListState extends State<ContactList> {
//   // List<User> Users = [];
//   // Color headerColor = Colors.yellow;

//   // _getUsers() async {
//   //   List<User> userTmp = [];
//   //   await widget.db
//   //       .query(
//   //         'users',
//   //         columns: ['id', 'name', 'phone', 'bio', 'time', 'image'],
//   //       )
//   //       .then((value) {
//   //         if (value.isEmpty) return;
//   //         value.forEach((element) {
//   //           userTmp.add(User.fromMap(element));
//   //         });
//   //       });
//   //   setState(() {
//   //     print(" >>>>>>>>>>> GETTING USERS <<<<<<<<<<<<");
//   //     if (userTmp.isEmpty) return;
//   //     Users = userTmp;
//   //   });
//   // }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   DataHelper.telephony.listenIncomingSms(
//   //     onNewMessage: (message) {
//   //       if (!mounted) return;

//   //       print("Message received in main page ${message.body}\n");
//   //       setState(() {
//   //         final index = Users.indexOf(
//   //           Users.where((element) => element.phone == message.address).first,
//   //         );
//   //         updateUser(index, message);
//   //       });
//   //       print(">>>>> DONE ${mounted} <<<<<");
//   //     },
//   //     listenInBackground: false,
//   //   );
//   //   _getUsers();
//   // }

//   // Future updateUser(int index, SmsMessage msg) async {
//   //   Users[index].time = msg.date!;
//   //   Users[index].newMsg = true;
//   //   await DataHelper.setTime(Users[index]);
//   // }

//   // @override
//   // void dispose() {
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return;
//     // drawer: Drawer(
//     //   child: ListView(
//     //     children: [
//     //       DrawerHeader(
//     //         margin: EdgeInsets.all(0),
//     //         padding: EdgeInsets.all(0),
//     //         child: Container(),
//     //         decoration: BoxDecoration(
//     //           image: DecorationImage(
//     //             // repeat: ImageRepeat.repeatX,
//     //             image: AssetImage("assets/appLogo.png"),
//     //             fit: BoxFit.fitWidth,
//     //           ),
//     //           color: Colors.black,
//     //         ),
//     //       ),
//     //       ListTile(
//     //         title: Text(AppLocalizations.of(context)!.colorSwitch),
//     //         trailing: Switch(
//     //           value: headerColor == Colors.blue ? true : false,
//     //           onChanged: (value) {
//     //             if (value == true) {
//     //               setState(() {
//     //                 headerColor = Colors.blue;
//     //               });
//     //             } else {
//     //               setState(() {
//     //                 headerColor = Colors.yellow;
//     //               });
//     //             }
//     //           },
//     //         ),
//     //       ),
//     //       ListTile(
//     //         title: Text(AppLocalizations.of(context)!.languageSwitch),
//     //         trailing: DropdownMenu(
//     //           dropdownMenuEntries: [
//     //             DropdownMenuEntry(value: "en", label: "EN🛢️🔫"),
//     //             DropdownMenuEntry(value: "fr", label: "FR🥐🥖"),
//     //           ],
//     //           width: 135,
//     //           initialSelection: AppLocalizations.of(context)!.localeName,
//     //           onSelected: (value) {
//     //             setState(() {
//     //               widget.setLocale(value!);
//     //             });
//     //           },
//     //         ),
//     //       ),
//     //     ],
//     //   ),
//     // ),
//     // appBar: AppBar(
//     //   leading: IconButton(
//     //     onPressed: () async {
//     //       if (Users.isEmpty) return;
//     //       await widget.db.delete("users");
//     //       _getUsers();
//     //     },
//     //     icon: Icon(Icons.delete_forever),
//     //   ),
//     //   actions: [
//     //     IconButton(
//     //       onPressed: () async {
//     //         final res = await ContactAddDialog(context, widget.db);
//     //         if (res == null) return;
//     //         if (res > Users.length) _getUsers();
//     //       },
//     //       icon: Icon(Icons.add),
//     //     ),
//     //   ],
//     // ),
//   }
// }
