import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/classes/sell/sellProductClass.dart';
import 'package:mainguyen/models/delivery/deliveryModel.dart';
import 'package:mainguyen/models/guest/guestModel.dart';
import 'package:mainguyen/models/product/product.dart';
import 'package:mainguyen/models/secret/secret.dart';
import 'package:mainguyen/models/soldOrdered/soldOrdered.dart';
import 'package:mainguyen/pages/homePage.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // var path = Directory.current.path;
  // ignore: unused_local_variable
  var documentsDirectory = await getApplicationDocumentsDirectory();
  Hive
    ..init(documentsDirectory.path)
    ..registerAdapter(ProductAdapter())
    ..registerAdapter(ProductEnumHiveAdapter())
    ..registerAdapter(SoldOrderedModelAdapter())
    ..registerAdapter(OrderProductDescriptionAdapter())
    ..registerAdapter(DeliveryModelAdapter())
    ..registerAdapter(GuestModelAdapter())
    ..registerAdapter(GuestTypeEnumAdapter())
    ..registerAdapter(SecretModelAdapter())
    ..registerAdapter(FacebookSecretAdapter())
    ..registerAdapter(ZaloSecretAdapter())
    ..registerAdapter(EmailSecretAdapter());

  await Hive.openBox("product");

  // await Hive.openBox("secret");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo Is the Part',
        theme: ThemeData(
          primaryColor: Colors.lightBlue[800],
          fontFamily: 'Roboto-Mono',
        ),
        home: const HomePage());
  }
}
