import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/models/product/product.dart';
import 'package:mainguyen/pages/inputProduct.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/emptyWidget.dart';
import 'package:mainguyen/widgets/photoView.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';

class OurOfStock extends StatefulWidget {
  const OurOfStock({Key? key}) : super(key: key);

  @override
  _OurOfStockState createState() => _OurOfStockState();
}

class _OurOfStockState extends State<OurOfStock> {
  late Box _productBox;

  late List<Product> _products = [];
  late List<Product> _ourOfStock = [];

  Divider getDivider() {
    return const Divider(
      height: 80,
      thickness: 1,
      indent: 10,
      endIndent: 0,
      color: Colors.black,
    );
  }

  Future _openBox() async {
    _productBox = await Hive.openBox('product');
    // _soldOrderedBox.clear();
    for (var i = 0; i < _productBox.length; i++) {
      _products.add(_productBox.getAt(i));
    }

    setState(() {});
    return;
  }

  List<Product> getOurOfStock() {
    List<Product> temp = [];
    _products.forEach((element) {
      if (element.amount < 100) {
        temp.add(element);
      }
    });
    return temp;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _openBox();
  }

  rowDescription(String title, String value) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 12)),
              SizedBox(width: 10),
              Text(value,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12))
            ],
          )),
    );
  }

  renderType(ProductEnumHive type) {
    switch (type) {
      case ProductEnumHive.kg:
        return "Kg";

      case ProductEnumHive.tree:
        return "Cây";

      case ProductEnumHive.bag:
        return "Bao";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyWidget(
          bodyWidget: Container(
              height: screenSizeWithoutContext.height / 2,
              width: screenSizeWithoutContext.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: getOurOfStock().isNotEmpty
                    ? Column(
                        children: [
                          for (var i = 0; i < getOurOfStock().length; i++) ...[
                            InkWell(
                                onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PhotoViewWidget(
                                                    image: getOurOfStock()[i]
                                                        .imageProduct)),
                                      )
                                    },
                                child: Container(
                                  height: 140,
                                  width: 140,
                                  padding: const EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    onError: (exception, stackTrace) => {},
                                    image: MemoryImage(
                                        getOurOfStock()[i].imageProduct),
                                    fit: BoxFit.contain,
                                  )),
                                )),
                            SizedBox(height: 10),
                            Text(
                                "Tên sản phẩm: ${getOurOfStock()[i].productName} ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: TextSize().getLabelTextSize())),
                            SizedBox(height: 10),
                            rowDescription("Giá:",
                                "${UtilsFunction().formatCurrency(getOurOfStock()[i].price)}/${renderType(getOurOfStock()[i].type)}"),
                            SizedBox(height: 10),
                            rowDescription("Số lượng còn lại:",
                                " ${getOurOfStock()[i].amount} ${renderType(getOurOfStock()[i].type)}"),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Trạng thái:"),
                                SizedBox(width: 10),
                                getOurOfStock()[i].amount <= 0
                                    ? Container(
                                        width: 100,
                                        height: 15,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Text(
                                          "Hết hàng",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ))
                                    : Container(
                                        width: 100,
                                        height: 15,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Text(
                                          "Sắp hết hàng",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ))
                              ],
                            ),
                            SizedBox(height: 10),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InputProduct(
                                              initOrder: getOurOfStock()[i],
                                            )),
                                  );
                                },
                                icon: Icon(Icons.next_plan),
                                label: Text("Nhập hàng")),
                            getDivider(),

                            /////
                            ///
                          ],
                        ],
                      )
                    : ImageEmpty(title: "Không có hàng sắp hết"),
              ))),
      appBar: CustomAppBar(
          backButton: true,
          title: const TitleAppbarWidget(content: "Hàng sắp hết"),
          widgetActions: []),
    );
  }
}
