// ignore: file_names

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/pages/createGuest.dart';
import 'package:mainguyen/pages/menu.dart';
import 'package:mainguyen/pages/newProduct.dart';
import 'package:mainguyen/pages/productBought.dart';
import 'package:mainguyen/pages/sell.dart';
import 'package:mainguyen/utils/colorApps.dart';
import 'package:mainguyen/utils/sizeAppbarButton.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/widgets/autocomplete.dart';
import '../utils/screenSize.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<String> _options = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];
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
              title: AutocompleteField(
                options: _options,
                label: "11",
              ),
              backButton: false,
              widgetActions: [],
            ),
          )),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
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
              "Tạo đơn bán hàng",
              "assets/appIcons/sell.png",
              () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SaleProducts()),
                    )
                  }),
          renderProductBox(
              "Nhập hàng", "assets/appIcons/import.png", () => {}),
          renderProductBox(
              "Vận chuyển",
              "assets/appIcons/delivery.png",
              () async =>
                  {await FlutterPhoneDirectCaller.callNumber("0978531164")}),
          renderProductBox(
              "Thêm khách hàng ",
              "assets/appIcons/user.png",
              () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateGuest()),
                    )
                  }),
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
                              Icon(Icons.subject),
                              Text("Danh mục")
                            ],
                          ),
                          onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MenuPage()),
                                )
                              }),
                    ],
                  ),
                ],
              ))),
    );
  }
}

class AutocompleteField extends StatelessWidget {
  AutocompleteField(
      {super.key, required List<String> options, required this.label})
      : _options = options;

  final List<String> _options;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: InputDecorator(
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(label),
                filled: true,
                fillColor: Colors.white,
                prefix: Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            child: RawAutocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return _options.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(border: InputBorder.none),
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                );
              },
              onSelected: (option) => {},
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: SizedBox(
                      height: 200.0,
                      width: 350,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                              UtilsFunction().closeKeyboard();
                            },
                            child: ListTile(
                              title: Text(option),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            )));
  }
}
