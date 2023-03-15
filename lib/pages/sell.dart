import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/models/product/product.dart';
import 'package:mainguyen/pages/bill.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/sizeAppbarButton.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';

class SaleProducts extends StatefulWidget {
  const SaleProducts({super.key});

  @override
  State<SaleProducts> createState() => _SaleProductsState();
}

class SellProduct {
  final String id;
  final double amount;
  SellProduct({required this.id, required this.amount});
  @override
  String toString() {
    // TODO: implement toString
    return "ID:$id";
  }
}

class _SaleProductsState extends State<SaleProducts> {
  @override
  late List<Product> _options = [];
  late Box _productBox;
  late List<Product> _productSellOriginal = [];

  late List<SellProduct> _productSell = [];

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

  SizedBox renderTextField(String label, bool typeNumber) {
    return SizedBox(
        height: 80,
        child: InputDecorator(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(label),
          ),
          child: TextField(
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

  DataRow renderDataRow(Product product) {
    var num = 0;
    return DataRow(cells: [
      DataCell(
        Container(
          height: 40,
          width: 40,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
              image: DecorationImage(
            onError: (exception, stackTrace) => {},
            image: MemoryImage(product.imageProduct),
            fit: BoxFit.contain,
          )),
        ),
      ),
      DataCell(Text(product.productName, style: TextStyle(fontSize: 10))),
      DataCell(TextFormField(
              initialValue: num.toString(),
              onChanged: (value) => {},
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffix: Text("(${renderType(product.type)})",
                      style: TextStyle(color: Colors.blue))),
              keyboardType: TextInputType.number,
              maxLines: null,
              style: TextStyle(fontSize: 12, color: Colors.blue))
          //   Flex(
          //   direction: Axis.horizontal,
          //   children: [
          //     CircleAvatar(
          //       backgroundColor: Colors.blue,
          //       radius: 8,
          //       child: IconButton(
          //         padding: EdgeInsets.zero,
          //         icon: const Icon(
          //           Icons.remove,
          //           size: 10,
          //         ),
          //         color: Colors.white,
          //         onPressed: () {},
          //       ),
          //     ),
          //     const SizedBox(width: 3),
          //     CircleAvatar(
          //         backgroundColor: Colors.white,
          //         radius: 14,
          //         child: Text("$num ${renderType(product.type)}",
          //             style: TextStyle(fontSize: 10))),
          //     const SizedBox(width: 3),
          //     CircleAvatar(
          //       backgroundColor: Colors.blue,
          //       radius: 8,
          //       child: IconButton(
          //         padding: EdgeInsets.zero,
          //         icon: const Icon(
          //           Icons.add,
          //           size: 10,
          //         ),
          //         color: Colors.white,
          //         onPressed: () {
          //           num += 1;
          //           setState(() {});
          //         },
          //       ),
          //     ),
          //   ],
          // )
          ),
      DataCell(Text(UtilsFunction().formatCurrency(product.price),
          style: const TextStyle(fontSize: 10, color: Colors.blue))),
      DataCell(IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          setState(() {
            _productSellOriginal
                .removeAt(_productSellOriginal.indexOf(product));
          });
        },
      )),
    ]);
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
                            setState(() {
                              _productSellOriginal.add(product);
                            });
                          },
                        )),
                    // Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 8, vertical: 10),
                    //     child: AutocompleteField(
                    //         options: _options2, label: "Nhập người mua")),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: renderTextField("SDT người mua", true)),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: renderTextField("Địa chỉ giao hàng", false)),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          horizontalMargin: 10,
                          columns: const [
                            DataColumn(
                                label:
                                    Text("Ảnh", style: TextStyle(fontSize: 9))),
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
                                label: Text("Hành động",
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const BillPage()),
                                  );
                                },
                                icon: Icon(Icons.next_plan),
                                label: Text("Tiếp tục")),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {},
                                icon: Icon(Icons.close),
                                label: Text("Hủy"))
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
                      width: 350,
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
