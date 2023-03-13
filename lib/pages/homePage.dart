// ignore: file_names

import 'package:flutter/material.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/pages/newProduct.dart';
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
  InkWell renderProductBox(String title, String image, Function callback) {
    return InkWell(
      onTap: () {
        callback();
      },
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorsInApp().getPrimaryColor()),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Flex(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              direction: Axis.vertical,
              children: [
                Container(
                  height: 75,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.contain,
                  )),
                  // color: Colors.teal[100],
                ),
                Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: TextSize().getNormalTextSize()))
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            child: CustomAppBar(
              title: const AutoCompleteCustom(),
              backButton: false,
              widgetActions: [],
            ),
          )),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          renderProductBox(
              "Thêm hàng mới ",
              "assets/appIcons/cart.png",
              () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewProduct()),
                    )
                  }),
          renderProductBox(
              "Tạo đơn bán hàng", "assets/appIcons/sell.png", () => {}),
          renderProductBox(
              "Nhập hàng", "assets/appIcons/import.png", () => {}),
          renderProductBox(
              "Vận chuyển", "assets/appIcons/delivery.png", () => {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsInApp().getPrimaryColor(),
        child: Icon(
          Icons.add,
        ),
        onPressed: () => {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                          minWidth: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.safety_check_outlined),
                              Text("Setting 1")
                            ],
                          ),
                          onPressed: () => {}),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                          minWidth: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.safety_check_outlined),
                              Text("Setting 1")
                            ],
                          ),
                          onPressed: () => {}),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                          minWidth: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.safety_check_outlined),
                              Text("Setting 1")
                            ],
                          ),
                          onPressed: () => {}),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                          minWidth: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.safety_check_outlined),
                              Text("Setting 1")
                            ],
                          ),
                          onPressed: () => {}),
                    ],
                  ),
                ],
              ))),
    );
  }
}
