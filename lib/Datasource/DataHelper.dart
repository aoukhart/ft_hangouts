import 'dart:io';
import 'dart:typed_data';

import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ft_hangouts/l10n/app_localizations.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ft_hangouts/model%20/Contact.dart';

class DataHelper {
  static Database? _db;
  static Telephony _telephony = Telephony.instance;

  static Telephony get telephony {
    if (_telephony.toString() != 'null') return _telephony;
    _telephony = Telephony.instance;
    return _telephony;
  }

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    print("<<<<<<< iniiit Db DONE >>>>>>>");
    return _db!;
  }

  static Future<Database> initDb() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, 'contacts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        print("Creating user table");
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT NOT NULL,
            bio TEXT NOT NULL,
            time INTEGER NOT NULL,
            image BLOB
          )
        ''');
      },
    );
  }

  // static listenIncomingMsg() {
  // _telephony.listenIncomingSms(
  //   onNewMessage: (message) {
  //     print("message received : " + message.body!);
  //     Chatpage().
  //   },
  //   listenInBackground: false,
  // );
  // }

  static Future initTelephony() async {
    final bool? res = await _telephony.requestSmsPermissions;
    return res;
  }

  static Future<List?> getUsers() async {
    final res = await _db!.query(
      'users',
      columns: ['id', 'name', 'phone', 'bio', 'time', 'image'],
      orderBy: 'time DESC',
    );
    return res;
  }

  static Future<int> addUser(name, phone, bio) async {
    int res = await _db!.insert('users', {
      'name': name.text,
      'phone': phone.text,
      'bio': bio.text,
      'time': DateTime.now().millisecondsSinceEpoch,
    });
    return res;
  }

  static Future changeName(int id, String name) async {
    final res = await _db!.update(
      'users',
      {'name': name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future editImage(int id, Uint8List image) async {
    final res = await _db!.update(
      'users',
      {'image': image},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future changePhone(int id, String phone) async {
    final res = await _db!.update(
      'users',
      {'phone': phone},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future changeBio(int id, String bio) async {
    final res = await _db!.update(
      'users',
      {'bio': bio},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future delete(int userId) async {
    final res = await _db!.delete(
      "users",
      where: "id = ?",
      whereArgs: [userId],
    );
    return res;
  }

  static Future deleteAll() async {
    final res = await _db!.delete("users");
    return res;
  }

  static Future<int> setTime(User user) async {
    DateTime now = DateTime.now();
    await _db!.update(
      'users',
      {"time": now.millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return now.millisecondsSinceEpoch;
  }

  static Future<List<SmsMessage>> getMessages(User user) async {
    final inbox = await _telephony.getInboxSms(
      columns: [SmsColumn.DATE, SmsColumn.ADDRESS, SmsColumn.BODY],
      filter: SmsFilter.where(SmsColumn.ADDRESS).equals(user.phone),
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.ASC)],
    );

    final sent = await _telephony.getSentSms(
      columns: [SmsColumn.DATE, SmsColumn.SUBJECT, SmsColumn.BODY],
      filter: SmsFilter.where(SmsColumn.ADDRESS).equals(user.phone),
    );

    final List<SmsMessage> messages = [...inbox, ...sent];
    messages.sort((a, b) => b.date!.compareTo(a.date!));
    return messages;
  }

  static Future<int> sendMsg(User receiver, String body) async {
    await _telephony.sendSms(to: receiver.phone, message: body);
    return await setTime(receiver);
  }
}
