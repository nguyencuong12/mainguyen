// ignore: file_names

// ignore_for_file: prefer_const_constructors

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/models/product/product.dart';
import 'package:mainguyen/models/secret/secret.dart';
import 'package:mainguyen/pages/allProduct.dart';
import 'package:mainguyen/pages/createGuest.dart';
import 'package:mainguyen/pages/delivery.dart';
import 'package:mainguyen/pages/guests.dart';
import 'package:mainguyen/pages/inputProduct.dart';
import 'package:mainguyen/pages/menu.dart';
import 'package:mainguyen/pages/newProduct.dart';
import 'package:mainguyen/pages/orderDrink.dart';
import 'package:mainguyen/pages/ourOfStock.dart';
import 'package:mainguyen/pages/secretPage.dart';
import 'package:mainguyen/pages/sell.dart';
import 'package:mainguyen/pages/soldOrdered.dart';
import 'package:mainguyen/pages/test.dart';
import 'package:mainguyen/pages/webviewPage.dart';
import 'package:mainguyen/utils/colorApps.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/productDetails/productDetails.dart';

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

  renderBottomNavItem(String title, IconData icon, Function callback) {
    return MaterialButton(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.green),
            const SizedBox(height: 5),
            RenderRichText(content: title, maxLine: 1)
          ],
        ),
        onPressed: () => {
              callback()
              // Navigator.of(context).popUntil((route) => route.isFirst)
            });
  }

  InkWell renderProductBoxWithNoti(
      String title, String image, Function callback) {
    return InkWell(
      onTap: () {
        callback();
      },
      child: DottedBorder(
        color: Color.fromARGB(255, 3, 3, 3),
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: SizedBox(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "${_options.length}",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(image),
                            fit: BoxFit.contain,
                          )),
                          // color: Colors.teal[100],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: RenderRichText(
                            content: title,
                            maxLine: 2,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 10, color: Colors.black)),
                      )
                    ],
                  )
                  // Flex(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   direction: Axis.vertical,
                  //   children: [
                  //     Container(
                  //       height: 40,
                  //       padding: const EdgeInsets.all(8),
                  //       decoration: BoxDecoration(
                  //           image: DecorationImage(
                  //         image: AssetImage(image),
                  //         fit: BoxFit.contain,
                  //       )),
                  //       // color: Colors.teal[100],
                  //     ),
                  //     SizedBox(height: 5),
                  //     RenderRichText(
                  //         content: title,
                  //         maxLine: 2,
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(fontSize: 10, color: Colors.black)),
                  //     // Text(title,
                  //     //     textAlign: TextAlign.center,
                  //     //     style: TextStyle(fontSize: TextSize().getNormalTextSize()))
                  //   ],
                  // ),
                  )),
        ),
      ),
    );
  }

  InkWell renderProductBox(String title, String image, Function callback) {
    return InkWell(
      onTap: () {
        callback();
      },
      child: DottedBorder(
        color: Color.fromARGB(255, 3, 3, 3),
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
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.contain,
                  )),
                  // color: Colors.teal[100],
                ),
                SizedBox(height: 5),
                RenderRichText(
                    content: title,
                    maxLine: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: Colors.black)),
                // Text(title,
                //     textAlign: TextAlign.center,
                //     style: TextStyle(fontSize: TextSize().getNormalTextSize()))
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
            // Flex(
            //   direction: Axis.horizontal,
            //   children: [

            // ],),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.fromLTRB(5, 20, 5, 10),
                child: AutocompleteFieldProduct(
                  label: "Tìm sản phẩm trong kho",
                  options: _options,
                  callback: (Product product) async {
                    await UtilsWidgetClass().navigateScreen(
                        context, ProductDetails(product: product));
                  },
                )),

            SizedBox(
              height: 550,
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: (1 / 1.3),
                ),
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
                      "Khách hàng ",
                      "assets/appIcons/user.png",
                      () async => {
                            await UtilsWidgetClass()
                                .navigateScreen(context, const CreateGuest()),
                          }),
                  renderProductBoxWithNoti(
                      "Hàng trong kho",
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
                  renderProductBox(
                      "Nhóm bán vải ",
                      "assets/appIcons/cotton.png",
                      () async => {
                            await UtilsWidgetClass()
                                .navigateScreen(context, const WebviewPage()),
                            await _openBox(),
                          }),
                  renderProductBox(
                      "Hàng sắp hết ",
                      "assets/appIcons/out-of-stock.png",
                      () async => {
                            await UtilsWidgetClass()
                                .navigateScreen(context, const OurOfStock()),
                            await _openBox(),
                          }),
                  renderProductBox(
                      "Hàng đã bán ",
                      "assets/appIcons/saled.png",
                      () async => {
                            await UtilsWidgetClass()
                                .navigateScreen(context, const SoldOrders()),
                            await _openBox(),
                          }),
                  renderProductBox("Secrets ", "assets/appIcons/lock.png",
                      () async {
                    Box secretBox = await Hive.openBox('secret');
                    if (secretBox.length <= 0) {
                      TextEditingController _textEditingController =
                          TextEditingController();
                      // ignore: use_build_context_synchronously
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text("Tạo mật khẩu"),
                              actions: [
                                UtilsWidgetClass().renderGroupActionsButton(
                                    context, () async {
                                  if (_textEditingController.text != "") {
                                    secretBox.add(SecretModel(
                                      facebooks: [],
                                      zalos: [],
                                      emails: [],
                                      password: _textEditingController.text,
                                    ));
                                    UtilsWidgetClass().callToast(
                                        "Tạo mật khẩu thành công",
                                        ToastGravity.CENTER);
                                    Navigator.pop(context);
                                  } else {
                                    UtilsWidgetClass().callToast(
                                        "Vui lòng nhập mật khẩu",
                                        ToastGravity.CENTER);
                                  }
                                }),
                              ],
                              content: SizedBox(
                                  height: 80,
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text("Mật khẩu"),
                                    ),
                                    child: TextFormField(
                                      controller: _textEditingController,
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                  )),
                            );
                          });
                    } else {
                      TextEditingController _textEditingController =
                          TextEditingController();
                      SecretModel _model = secretBox.getAt(0);

                      // ignore: use_build_context_synchronously
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              actions: [
                                UtilsWidgetClass().renderGroupActionsButton(
                                    context, () async {
                                  SecretModel _model = secretBox.getAt(0);
                                  print("LENGTH ${_model.password}");
                                  if (_model.password ==
                                      _textEditingController.text) {
                                    Navigator.pop(context);
                                    UtilsWidgetClass().navigateScreen(
                                        context,
                                        SecretPage(
                                          secretModel: _model,
                                        ));
                                  } else {
                                    UtilsWidgetClass().callToast(
                                        "Sai mật khẩu", ToastGravity.CENTER);
                                  }
                                }),
                              ],
                              content: SizedBox(
                                  height: 80,
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text("Mật khẩu"),
                                    ),
                                    child: TextFormField(
                                      controller: _textEditingController,
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      // controller: _textEditingController,
                                      // onChanged: (value) => {onSubmit(value)},
                                      // keyboardType:
                                      //     numberType ? TextInputType.phone : TextInputType.text,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                  )),
                            );
                          });
                    }
                    // await UtilsWidgetClass()
                    //     .navigateScreen(context, SecretPage());
                    // await _openBox();
                  }),
                  renderProductBox(
                      "Sổ nợ ",
                      "assets/appIcons/money-bag.png",
                      () async => {
                            await UtilsWidgetClass()
                                .navigateScreen(context, const Test()),
                            // await UtilsWidgetClass()
                            //     .navigateScreen(context, const NewProduct()),
                            // await _openBox(),
                          }),
                  renderProductBox(
                      "Phiếu mua nước ngọt",
                      "assets/appIcons/bill.png",
                      () async => {
                            await UtilsWidgetClass()
                                .navigateScreen(context, const OrderDrink()),
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
      bottomNavigationBar: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    renderBottomNavItem(
                        "Bán hàng",
                        Icons.point_of_sale_outlined,
                        () async => {
                              await UtilsWidgetClass().navigateScreen(
                                  context, const SaleProducts()),
                              await _openBox(),
                            }),
                    renderBottomNavItem(
                        "Kho hàng",
                        Icons.inventory,
                        () async => {
                              await UtilsWidgetClass()
                                  .navigateScreen(context, const AllProducts()),
                              await _openBox(),
                            }),
                    renderBottomNavItem(
                        "Khách hàng",
                        Icons.people_alt_outlined,
                        () => {
                              UtilsWidgetClass()
                                  .navigateScreen(context, const GuestPage())
                            }),
                    renderBottomNavItem(
                        "Vận chuyển",
                        Icons.delivery_dining_outlined,
                        () => {
                              UtilsWidgetClass().navigateScreen(
                                  context, const DeliveryWidget())
                            }),
                  ],
                ))),
      ),
    );
  }
}
