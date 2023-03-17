import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/classes/guest/guestOrder.dart';
import 'package:mainguyen/classes/sell/sellProductClass.dart';
import 'package:mainguyen/enum/product/productEnum.dart';
import 'package:mainguyen/models/product/product.dart';
import 'package:mainguyen/pages/bill.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/sizeAppbarButton.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/photoView.dart';

class SaleProducts extends StatefulWidget {
  const SaleProducts({super.key});

  @override
  State<SaleProducts> createState() => _SaleProductsState();
}

class _SaleProductsState extends State<SaleProducts> {
  @override
  late List<Product> _options = [];
  late Box _productBox;
  late List<SellProduct> _productSellOriginal = [];
  GuestOrder _guestOrder = GuestOrder();

  List<SellProduct> _productOrders = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _openBox();
  }

  Future _openBox() async {
    _productBox = await Hive.openBox('product');
    _productBox.length;
    _options = [];
    for (var i = 0; i < _productBox.length; i++) {
      _options.add(_productBox.getAt(i));
    }
    print("OPTION $_options");
    setState(() {});
    return;
  }

  SizedBox renderTextField(String label, bool typeNumber, Function onSubmit) {
    return SizedBox(
        height: 80,
        child: InputDecorator(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(label),
          ),
          child: TextField(
            onChanged: (value) => {onSubmit(value)},
            keyboardType: typeNumber ? TextInputType.phone : TextInputType.text,
            decoration: InputDecoration(border: InputBorder.none),
          ),
        ));
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

  DataRow renderDataRow(SellProduct product) {
    var amountConst = product.amount;
    return DataRow(cells: [
      // DataCell(
      //   Container(
      //     height: 40,
      //     width: 40,
      //     padding: const EdgeInsets.all(0),
      //     decoration: BoxDecoration(
      //         image: DecorationImage(
      //       onError: (exception, stackTrace) => {},
      //       image: MemoryImage(product.image),
      //       fit: BoxFit.contain,
      //     )),
      //   ),
      // ),
      DataCell(InkWell(
          onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PhotoViewWidget(image: product.image)),
                )
              },
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  onError: (exception, stackTrace) => {},
                  image: MemoryImage(product.image),
                  fit: BoxFit.contain,
                )),
              ),
              SizedBox(width: 5),
              Text(product.productName, style: TextStyle(fontSize: 10))
            ],
          ))),
      DataCell(TextFormField(
          initialValue: "1",
          onChanged: (String value) {
            try {
              if (double.parse(value) > product.amount) {
                Fluttertoast.showToast(
                    msg: "Số hàng trong kho không đủ ",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 10,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                _productOrders.forEach((element) {
                  if (product.id == element.id) {
                    element.amount = double.parse(value);
                  }
                });
              }
            } catch (err) {}
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              suffix: Text("(${renderType(product.type)})",
                  style: TextStyle(color: Colors.blue))),
          keyboardType: TextInputType.number,
          maxLines: null,
          style: TextStyle(fontSize: 12, color: Colors.blue))),
      DataCell(Text(UtilsFunction().formatCurrency(product.price),
          style: const TextStyle(fontSize: 10, color: Colors.blue))),
      DataCell(Text(
          "${product.amount.toString()} (${renderType(product.type)})",
          style: const TextStyle(fontSize: 10, color: Colors.blue))),
    ]);
  }

  bool checkAddElementOrder(List<SellProduct> products, Product productAdd) {
    bool result = false;
    products.forEach((element) {
      if (element.id == productAdd.id) {
        result = true;
      }
    });

    return result;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            backButton: true,
            title: Text("Tạo hóa đơn bán hàng",
                style: TextStyle(fontSize: TextSize().getLabelTextSize())),
            widgetActions: []),
        body: BodyWidget(
            bodyWidget: Container(
                width: screenSizeWithoutContext.width,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: AutocompleteField(
                          options: _options,
                          label: "Nhập hàng cần bán",
                          callback: (Product product) {
                            if (_productSellOriginal.isNotEmpty) {
                              bool check = checkAddElementOrder(
                                  _productSellOriginal, product);
                              if (!check) {
                                setState(() {
                                  _productOrders.add(SellProduct(
                                      id: product.id,
                                      amount: 1,
                                      type: product.type,
                                      price: product.price,
                                      image: product.imageProduct,
                                      productName: product.productName));
                                  _productSellOriginal.add(SellProduct(
                                      productName: product.productName,
                                      id: product.id,
                                      amount: product.amount,
                                      type: product.type,
                                      price: product.price,
                                      image: product.imageProduct));
                                });
                              }
                              // _productSellOriginal.forEach((element) {
                              //   if (element.id != product.id) {
                              //     return "1";
                              //   }
                              // });
                            } else {
                              setState(() {
                                _productOrders.add(SellProduct(
                                    id: product.id,
                                    amount: 1,
                                    type: product.type,
                                    price: product.price,
                                    image: product.imageProduct,
                                    productName: product.productName));
                                _productSellOriginal.add(SellProduct(
                                    productName: product.productName,
                                    id: product.id,
                                    amount: product.amount,
                                    type: product.type,
                                    price: product.price,
                                    image: product.imageProduct));
                              });
                            }
                          },
                        )),
                    Form(
                      key: _formKey,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          child: SizedBox(
                              height: 80,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Tên người mua"),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng tên người mua';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) =>
                                      {_guestOrder.guestName = value},
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                ),
                              ))),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: renderTextField(
                            "SDT người mua",
                            true,
                            (submitValue) =>
                                {_guestOrder.phoneNumber = submitValue})),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: renderTextField(
                            "Địa chỉ giao hàng",
                            false,
                            (submitValue) =>
                                {_guestOrder.address = submitValue})),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          horizontalMargin: 10,
                          columns: const [
                            // DataColumn(
                            //     label:
                            //         Text("Ảnh", style: TextStyle(fontSize: 9))),
                            DataColumn(
                                label:
                                    Text("Mục", style: TextStyle(fontSize: 9))),
                            DataColumn(
                                label: Text("Số lượng",
                                    style: TextStyle(fontSize: 9))),
                            DataColumn(
                                label:
                                    Text("Giá", style: TextStyle(fontSize: 9))),
                            DataColumn(
                                label: Text("Số lượng trong kho",
                                    style: TextStyle(fontSize: 9))),
                          ],
                          rows: [
                            for (var i = 0;
                                i < _productSellOriginal.length;
                                i++) ...[
                              renderDataRow(_productSellOriginal[i]),
                            ]
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BillPage(
                                                guestOrder: _guestOrder,
                                                listProductOrder:
                                                    _productOrders,
                                              )),
                                    );
                                  }
                                },
                                icon: Icon(Icons.next_plan),
                                label: Text("Tiếp tục")),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.close),
                                label: Text("Hủy")),
                          ],
                        )),
                  ],
                ))));
  }
}

class AutocompleteField extends StatelessWidget {
  AutocompleteField(
      {super.key,
      required List<Product> options,
      required this.label,
      required this.callback})
      : _options = options;

  final List<Product> _options;
  final String label;
  final void Function(Product) callback;

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
                                callback(product);
                                UtilsFunction().closeKeyboard();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           ProductDetails(product: product)),
                                // );
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
