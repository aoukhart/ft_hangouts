import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:testing/Datasource/DataHelper.dart';
import 'package:testing/l10n/app_localizations.dart';
import 'package:testing/model%20/Contact.dart';

Future UserInfoDialog(User user, context) async {
  late TextEditingController name = TextEditingController(text: user.name);
  late TextEditingController phone = TextEditingController(text: user.phone);
  late TextEditingController bio = TextEditingController(text: user.bio);
  bool modify_name = false;
  bool modify_phone = false;
  bool modify_bio = false;
  late File image;

  Future<Uint8List?> _pickImage() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageByte = await pickedFile.readAsBytes();
      await DataHelper.editImage(user.id!, imageByte);
      return imageByte;
    }
    return null;
  }

  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: EdgeInsets.all(5),
            actions: [
              IconButton(
                onPressed: () {
                  if (!modify_name && !modify_phone && !modify_bio)
                    Navigator.pop(context, user);
                },
                icon: Icon(Icons.close),
              ),
            ],
            content: Container(
              height: MediaQuery.heightOf(context) * 0.35,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final res = await _pickImage();
                        if (res == null) return;
                        setState(() {
                          user.image = res;
                        });
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: user.image != null
                            ? Image.memory(user.image!).image
                            : AssetImage('assets/default_avatar.jpg')
                                  as ImageProvider,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.name} :",
                          style: TextStyle(fontSize: 18),
                        ),
                        modify_name
                            ? Expanded(child: TextField(controller: name))
                            : Text(user.name, style: TextStyle(fontSize: 18)),
                        IconButton(
                          onPressed: () async {
                            modify_name
                                ? {
                                    if (user.name != name.text &&
                                        name.text.isNotEmpty)
                                      {
                                        await DataHelper.changeName(
                                          user.id!,
                                          name.text,
                                        ),

                                        setState(() {
                                          user.name = name.text;
                                        }),
                                      },
                                    setState(() {
                                      modify_name = false;
                                    }),
                                  }
                                : setState(() {
                                    modify_name = true;
                                  });
                          },
                          icon: modify_name
                              ? Icon(Icons.done)
                              : Icon(Icons.border_color_outlined),
                        ),
                      ],
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.phone} :",
                          style: TextStyle(fontSize: 18),
                        ),
                        // SizedBox(width: 25),
                        modify_phone
                            ? Expanded(child: TextField(controller: phone))
                            : Text(user.phone, style: TextStyle(fontSize: 18)),
                        IconButton(
                          onPressed: () async {
                            modify_phone
                                ? {
                                    if (user.phone != phone.text &&
                                        phone.text.isNotEmpty)
                                      {
                                        await DataHelper.changePhone(
                                          user.id!,
                                          phone.text,
                                        ),

                                        setState(() {
                                          user.phone = phone.text;
                                        }),
                                      },
                                    setState(() {
                                      modify_phone = false;
                                    }),
                                  }
                                : setState(() {
                                    modify_phone = true;
                                  });
                          },
                          icon: modify_phone
                              ? Icon(Icons.done)
                              : Icon(Icons.border_color_outlined),
                        ),
                      ],
                    ),
                    Text("Bio :", style: TextStyle(fontSize: 18)),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // SizedBox(width: 25),
                        modify_bio
                            ? SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.5,
                                height: MediaQuery.sizeOf(context).height * 0.1,
                                child: TextField(
                                  controller: bio,
                                  expands: true,
                                  maxLines: null,
                                  decoration: InputDecoration(filled: true),
                                ),
                              )
                            : Expanded(
                                child: Text(
                                  user.bio,
                                  style: TextStyle(fontSize: 18),
                                  softWrap: true,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                        IconButton(
                          onPressed: () async {
                            modify_bio
                                ? {
                                    if (user.bio != bio.text &&
                                        bio.text.isNotEmpty)
                                      {
                                        await DataHelper.changeBio(
                                          user.id!,
                                          bio.text,
                                        ),

                                        setState(() {
                                          user.bio = bio.text;
                                          modify_bio = false;
                                        }),
                                      },
                                    setState(() {
                                      modify_bio = false;
                                    }),
                                  }
                                : setState(() {
                                    modify_bio = true;
                                  });
                          },
                          icon: modify_bio
                              ? Icon(Icons.done)
                              : Icon(Icons.border_color_outlined),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
