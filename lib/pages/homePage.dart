// ignore: file_names

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/models/product/product.dart';
import 'package:mainguyen/pages/allProduct.dart';
import 'package:mainguyen/pages/createGuest.dart';
import 'package:mainguyen/pages/delivery.dart';
import 'package:mainguyen/pages/inputProduct.dart';
import 'package:mainguyen/pages/menu.dart';
import 'package:mainguyen/pages/newProduct.dart';
import 'package:mainguyen/pages/productBought.dart';
import 'package:mainguyen/pages/sell.dart';
import 'package:mainguyen/utils/colorApps.dart';
import 'package:mainguyen/utils/sizeAppbarButton.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/widgets/autocomplete.dart';
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
      body: BodyWidget(
        bodyWidget: Container(
          width: screenSizeWithoutContext.width,
          height: screenSizeWithoutContext.height / 3,
          child: GridView.count(
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
                        ).then((value) async {
                          print("CALL");
                          await _openBox();
                        })
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
                  "Nhập hàng",
                  "assets/appIcons/import.png",
                  () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InputProduct()),
                        )
                      }),
              renderProductBox(
                  "Vận chuyển",
                  "assets/appIcons/delivery.png",
                  () async => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeliveryWidget()),
                        )
                      }),
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
              renderProductBox(
                  "Tất cả hàng trong kho",
                  "assets/appIcons/package.png",
                  () async => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AllProducts()),
                        )
                      }),
            ],
          ),
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

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => const HomePage()),
                                // )
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

class AutocompleteField extends StatelessWidget {
  AutocompleteField({
    super.key,
    required List<Product> options,
    required this.label,
  }) : _options = options;

  final List<Product> _options;
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
                prefix: const Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            child: RawAutocomplete<Product>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return _options.where((Product product) {
                  return product.productName
                      .contains(textEditingValue.text.toLowerCase());
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
                  AutocompleteOnSelected<Product> onSelected,
                  Iterable<Product> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: Container(
                      height: 200.0,
                      width: screenSizeWithoutContext.width / 3.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Product product = options.elementAt(index);
                          return GestureDetector(
                              onTap: () {
                                // onSelected(option);
                                UtilsFunction().closeKeyboard();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetails(product: product)),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  child: ListTile(
                                    subtitle: Text(
                                        "Vị trí: ${product.location}",
                                        style: const TextStyle(fontSize: 12)),
                                    leading: Image(
                                        height: 50,
                                        image:
                                            MemoryImage(product.imageProduct)),
                                    title: Text(
                                      "Sản phẩm: ${product.productName}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              )

                              // ListTile(
                              //   title: Text(option.productName),
                              // ),
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
