import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'secret.g.dart';

@HiveType(typeId: 10)
class SecretModel {
  SecretModel(
      {required this.password,
      required this.facebooks,
      required this.zalos,
      required this.emails});
  @HiveField(0)
  String password;
  @HiveField(1)
  List<FacebookSecret>? facebooks;
  @HiveField(2)
  List<ZaloSecret>? zalos;
  @HiveField(3)
  List<EmailSecret>? emails;

  @override
  String toString() {
    // TODO: implement toString
    return "Password $password";
  }
}

@HiveType(typeId: 11)
class FacebookSecret {
  FacebookSecret({required this.password, required this.username});
  @HiveField(0)
  String? username;
  @HiveField(1)
  String? password;
}

@HiveType(typeId: 12)
class ZaloSecret {
  ZaloSecret({required this.password, required this.username});

  @HiveField(0)
  String username;
  @HiveField(1)
  String password;
}

@HiveType(typeId: 13)
class EmailSecret {
  EmailSecret({required this.password, required this.username});
  @HiveField(0)
  String username;
  @HiveField(1)
  String password;
}
