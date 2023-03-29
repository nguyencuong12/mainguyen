// ignore: file_names

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/models/product/product.dart';
import 'package:mainguyen/pages/allProduct.dart';
import 'package:mainguyen/pages/createGuest.dart';
import 'package:mainguyen/pages/delivery.dart';
import 'package:mainguyen/pages/inputProduct.dart';
import 'package:mainguyen/pages/menu.dart';
import 'package:mainguyen/pages/newProduct.dart';
import 'package:mainguyen/pages/sell.dart';
import 'package:mainguyen/utils/colorApps.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/productDetails/productDetails.dart';
import '../utils/screenSize.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Product> _options = [];
  late Box _productBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future _openBox() async {
    _productBox = await Hive.openBox('product');
    _options = [];
    for (var i = 0; i < _productBox.length; i++) {
      _options.add(_productBox.getAt(i));
    }

    setState(() {});
    return;
  }

  InkWell renderProductBox(String title, String image, Function callback) {
    return InkWell(
      onTap: () {
        callback();
      },
      child: DottedBorder(
        color: const Color.fromARGB(255, 117, 116, 116),
        dashPattern: [4, 3],
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: SizedBox(
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BodyWidget(
        bodyWidget: Column(
          children: [
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.all(18.0),
                child: AutocompleteFieldProduct(
                  label: "Tìm sản phẩm trong kho",
                  options: _options,
                  callback: (Product product) async {
                    await UtilsWidgetClass().navigateScreen(
                        context, ProductDetails(product: product));
                  },
                )),
            SizedBox(
              height: 500,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(40),
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                crossAxisCount: 2,
                children: <Widget>[
                  renderProductBox(
                      "Thêm hàng mới ",
                      "assets/appIcons/cart.png",
                      () async => {
                            await UtilsWidgetClass()
                                .navigateScreen(context, const NewProduct()),
                            await _openBox(),
                          }),
                  renderProductBox(
                      "Tạo đơn bán hàng",
                      "assets/appIcons/sell.png",
                      () async => {
                            await UtilsWidgetClass()
                                .navigateScreen(context, const SaleProducts()),
                            await _openBox(),
                          }),
                  renderProductBox(
                      "Nhập hàng",
                      "assets/appIcons/import.png",
                      () async => {
                            await UtilsWidgetClass()
                                .navigateScreen(context, InputProduct()),
                            await _openBox()
                          }),
                  renderProductBox(
                      "Vận chuyển",
                      "assets/appIcons/delivery.png",
                      () async => {
                            await UtilsWidgetClass().navigateScreen(
                                context, const DeliveryWidget()),
                          }),
                  renderProductBox(
                      "Thêm khách hàng ",
                      "assets/appIcons/user.png",
                      () async => {
                            await UtilsWidgetClass()
                                .navigateScreen(context, const CreateGuest()),
                          }),
                  renderProductBox(
                      "Tất cả hàng trong kho",
                      "assets/appIcons/package.png",
                      () async => {
                            await UtilsWidgetClass()
                                .navigateScreen(context, const AllProducts()),
                            await _openBox()
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const AllProducts()),
                            // )
                          }),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsInApp().getPrimaryColor(),
        child: Icon(
          Icons.add,
        ),
        onPressed: () => {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NewProduct()))
              .then((value) async => await _openBox())
        },
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
                              Icon(Icons.house),
                              Text("Trang chính")
                            ],
                          ),
                          onPressed: () => {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst)
                              }),
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
