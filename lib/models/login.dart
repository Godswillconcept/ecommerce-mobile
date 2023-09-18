import 'dart:convert';
import 'package:hive/hive.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// part 'login.g.dart';

@HiveType(typeId: 1)
class Login extends HiveObject {
  @HiveField(0)
  String email;
  @HiveField(1)
  String password;
  Login({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }

  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Login.fromJson(String source) =>
      Login.fromMap(json.decode(source) as Map<String, dynamic>);
}
