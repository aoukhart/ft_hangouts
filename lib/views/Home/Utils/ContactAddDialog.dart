import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testing/Datasource/DataHelper.dart';
import 'package:testing/l10n/app_localizations.dart';

Future ContactAddDialog(context, Database db) {
  TextEditingController NameCtrl = TextEditingController();
  TextEditingController PhoneCtrl = TextEditingController();
  TextEditingController BioCtrl = TextEditingController();

  int res = -1;
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context)!.contactInfo),
          IconButton(
            onPressed: () => Navigator.pop(context, res),
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      content: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: TextField(
                controller: NameCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 13),
                  labelStyle: TextStyle(fontSize: 14),
                  labelText: AppLocalizations.of(context)!.name,
                  hintText: AppLocalizations.of(context)!.nameHint,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[+0-9]')),
                  // FilteringTextInputFormatter.digitsOnly,
                ],
                controller: PhoneCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 13),
                  labelStyle: TextStyle(fontSize: 14),
                  labelText: AppLocalizations.of(context)!.phoneNumber,
                  hintText: AppLocalizations.of(context)!.phoneNumberHint,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: BioCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 13),
                  labelStyle: TextStyle(fontSize: 14),
                  labelText: AppLocalizations.of(context)!.bio,
                  hintText: AppLocalizations.of(context)!.bioHint,
                ),
              ),
            ),
            SizedBox(height: 40),
            TextButton(
              onPressed: () async {
                if (NameCtrl.text.isNotEmpty &&
                    PhoneCtrl.text.isNotEmpty &&
                    BioCtrl.text.isNotEmpty) {
                  res = await DataHelper.addUser(NameCtrl, PhoneCtrl, BioCtrl);
                  res == -1
                      ? Navigator.pop(context, -1)
                      : Navigator.pop(context, res);
                }
              },
              child: Text(AppLocalizations.of(context)!.submit),
            ),
          ],
        ),
      ),
    ),
  );
}
