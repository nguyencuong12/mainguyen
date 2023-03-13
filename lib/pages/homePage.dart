// ignore: file_names

import 'package:flutter/material.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/pages/productBought.dart';
import 'package:mainguyen/utils/colorApps.dart';
import 'package:mainguyen/utils/sizeAppbarButton.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/widgets/autocomplete.dart';
import '../utils/screenSize.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InkWell renderProductBox() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProductBoughtScreen()),
        );
      },
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorsInApp().getPrimaryColor()),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: SingleChildScrollView(
                child: Flex(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              direction: Axis.vertical,
              children: [
                Container(
                  height: 75,
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/appIcons/package.png"),
                    fit: BoxFit.contain,
                  )),
                  // color: Colors.teal[100],
                ),
                Text("Các đơn đã mua hàng ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: TextSize().getNormalTextSize()))
              ],
            )),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: CustomAppBar(
            title: const AutoCompleteCustom(),
            backButton: false,
            widgetActions: [],
          ),
        ),
        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: <Widget>[renderProductBox(), renderProductBox()],
        ));
  }
}
