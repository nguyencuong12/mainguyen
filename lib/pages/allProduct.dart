import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/dialogs/dialogs.dart';
import 'package:mainguyen/models/product/product.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/emptyWidget.dart';
import 'package:mainguyen/widgets/productDetails/productDetails.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';

import '../utils/colorApps.dart';
import '../utils/textSize.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({super.key});

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  late Box _productBox;
  List<Product> _products = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _openBox();
  }

  Future _openBox() async {
    _productBox = await Hive.openBox('product');
    _products = [];
    for (var i = 0; i < _productBox.length; i++) {
      _products.add(_productBox.getAt(i));
    }
    setState(() {});
    return;
  }

  InkWell renderProductBox(
      String title, Uint8List imageMemory, Function callback, Function delete) {
    // dynamic imageVarible =

    return InkWell(
      onTap: () {
        callback();
      },
      onLongPress: () {
        getDeleteDialog(context, () => {delete()});
      },
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorsInApp().getPrimaryColor()),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
              child: Flex(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                direction: Axis.vertical,
                children: [
                  Container(
                    height: 120,
                    width: 160,
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      onError: (exception, stackTrace) => {},
                      image: MemoryImage(imageMemory),
                      fit: BoxFit.contain,
                    )),
                  ),
                  SizedBox(height: 10),
                  Text(title,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: TextSize().getNormalTextSize()))
                ],
              ),
            ),
          )),
    );
  }

  renderItem(Product product, Function onSubmit) {
    return Card(
        child: ListTile(
            onTap: () {
              onSubmit();
            },
            leading: Image(
              image: MemoryImage(
                product.imageProduct,
              ),
              height: screenSizeWithoutContext.height / 20,
            ),
            subtitle: Text("Số lượng: ${product.amount.toString()}",
                style: const TextStyle(fontSize: 12, color: Colors.red)),
            title: RenderRichText(content: product.productName, maxLine: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _products.isNotEmpty
            ? GridView(
                primary: false,
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (1 / .5),
                ),
                children: [
                  ..._products.map(
                    (product) => renderItem(product, () async {
                      await UtilsWidgetClass().navigateScreen(
                          context, ProductDetails(product: product));
                      await _openBox();
                      // await _productBox();
                    }),

                    // renderProductBox(
                    //     product.productName,
                    //     product.imageProduct,
                    //     () => {
                    //           UtilsWidgetClass().navigateScreen(
                    //               context, ProductDetails(product: product))
                    //         },
                    //     () async => {
                    //           _productBox.deleteAt(_products.indexOf(product)),
                    //           _openBox()
                    //         })
                  )
                ],
              )
            : ImageEmpty(title: "Hiện chưa có sản phẩm nào"),
        appBar: CustomAppBar(
            backButton: true,
            title:
                const TitleAppbarWidget(content: "Tất cả sản phẩm trong kho"),
            widgetActions: []));
  }
}
