import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:testing/model%20/Contact.dart';
import 'package:testing/views/Contact/ChatPage.dart';
import 'package:path/path.dart';

Widget delete() {
  return Row(children: [Text("delete")]);
}

ContactTile(context, User user) {
  TapDownDetails _tapPostion;
  return ListTile(
    // onTap: () {
    //   _tapPostion = TapDownDetails();
    // },
    // onLongPress: () => showMenu(
    //   positionBuilder: (context, constraints) =>
    //       RelativeRect.fromLTRB(300, constraints., 400, bottom),
    //   context: context,
    //   items: [PopupMenuItem(child: Text("Delete"), onTap: () {})],
    // ),
    trailing: SizedBox(
      width: 55,
      child: Row(
        mainAxisAlignment: user.newMsg
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.end,
        children: [
          if (user.newMsg)
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade400,
              ),
            ),
          Text(
            DateTime.now().day >
                    DateTime.fromMillisecondsSinceEpoch(user.time).day
                ? DateFormat(
                    "MMM dd",
                  ).format(DateTime.fromMillisecondsSinceEpoch(user.time))
                : DateFormat(
                    "HH:mm",
                  ).format(DateTime.fromMillisecondsSinceEpoch(user.time)),
            style: TextStyle(fontWeight: _getWeight(user)),
          ),
        ],
      ),
    ),
    tileColor: Colors.blueGrey.shade100,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(50),
    ),
    title: Text(user.name, style: TextStyle(fontWeight: _getWeight(user))),
    subtitle: Text(user.phone, style: TextStyle(fontWeight: _getWeight(user))),
    leading: CircleAvatar(
      radius: 28,
      backgroundImage: user.image == null
          ? AssetImage("assets/default_avatar.jpg") as ImageProvider
          : Image.memory(user.image!).image,
    ),
  );
}

FontWeight? _getWeight(User user) {
  return user.newMsg ? FontWeight.w500 : null;
}
