import 'dart:ffi';

import 'package:flutter/services.dart';

class User {
  final int? id;
  late String name;
  late String phone;
  late String bio;
  late int time;
  Uint8List? image;
  bool newMsg = false;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.bio,
    required this.time,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'bio': bio,
      'time': time,
      'image': image,
      'newMsg': newMsg,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      bio: map['bio'],
      time: map['time'],
      image: map['image'],
    );
  }
}
