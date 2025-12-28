import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ft_hangouts/Datasource/DataHelper.dart';
import 'package:ft_hangouts/l10n/app_localizations.dart';
import 'package:ft_hangouts/model%20/Contact.dart';

Future UserInfoDialog(User user, ctxt) async {
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

  return showDialog(
    barrierDismissible: false,
    context: ctxt,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.only(
              top: 10,
              left: 20,
              right: 3,
              bottom: 0,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: EdgeInsets.all(0),
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
              // height: MediaQuery.heightOf(context) * 0.36,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      radius: 35,
                      backgroundImage: user.image != null
                          ? Image.memory(user.image!).image
                          : AssetImage('assets/default_avatar.jpg')
                                as ImageProvider,
                    ),
                  ),
                  SizedBox(height: MediaQuery.heightOf(context) * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 55,
                        child: Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.name} :  ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            modify_name
                                ? Expanded(
                                    child: TextField(
                                      controller: name,
                                      maxLength: 18,
                                    ),
                                  )
                                : Expanded(
                                    child: Text(
                                      user.name,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
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
                      ),
                      SizedBox(
                        height: 55,
                        child: Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.phone} :  ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            modify_phone
                                ? Expanded(
                                    child: TextField(
                                      controller: phone,
                                      maxLength: 18,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[+0-9]'),
                                        ),
                                      ],
                                    ),
                                  )
                                : Expanded(
                                    child: Text(
                                      user.phone,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          "Bio :",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        child: Row(
                          children: [
                            modify_bio
                                ? Expanded(
                                    child: TextField(
                                      controller: bio,
                                      buildCounter:
                                          (
                                            context, {
                                            required currentLength,
                                            required isFocused,
                                            required maxLength,
                                          }) => null,
                                      maxLines: 2,
                                      maxLength: 35,
                                      decoration: InputDecoration(filled: true),
                                    ),
                                  )
                                : Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        user.bio,
                                        style: TextStyle(fontSize: 18),
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        // textAlign: TextAlign.center,
                                      ),
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
