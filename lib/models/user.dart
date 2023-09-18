// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String firstName;
  @HiveField(2)
  String lastName;
  @HiveField(3)
  String email;
  @HiveField(4)
  String address;
  @HiveField(5)
  String password;
  @HiveField(6)
  String phone;
  @HiveField(7)
  String gender;
  @HiveField(8)
  DateTime dob;
  @HiveField(9)
  String? image;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.password,
    required this.phone,
    required this.gender,
    required this.dob,
    this.image,
  });

  get name {
    return ("$firstName $lastName");
  }

  get age {
    final now = DateTime.now();
    final ageInMilliseconds = now.difference(dob).inMilliseconds;
    final millisecondsInYear = (365.25 * 24 * 60 * 60 * 1000).round();
    return (ageInMilliseconds / millisecondsInYear).floor();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'address': address,
      'password': password,
      'phone': phone,
      'gender': gender,
      'dob': dob.toIso8601String(),
      'image': image,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as int : null,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      password: map['password'] as String,
      phone: map['phone'] as String,
      gender: map['gender'] as String,
      dob: DateTime.parse(map['dob']),
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
