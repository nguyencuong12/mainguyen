import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/models/product/product.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/productDetails/productDetails.dart';

class InputProduct extends StatefulWidget {
  const InputProduct({Key? key}) : super(key: key);

  @override
  _InputProductState createState() => _InputProductState();
}

class Order {
  final String id;
  final double amount;
  Order({required this.id, required this.amount});
  @override
  String toString() {
    // TODO: implement toString
    return "ID:$id";
  }
}

class _InputProductState extends State<InputProduct> {
  @override
  late List<Product> _options = [];
  late Box _productBox;
  late List<Product> _productOrder = [];

  late List<Order> _productOrderWithAmount = [];

  void initState() {
    // TODO: implement initState
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

  Divider getDivider() {
    return const Divider(
      height: 30,
      thickness: 1,
      indent: 10,
      endIndent: 0,
      color: Color.fromARGB(255, 175, 170, 170),
    );
  }

  rowDescription(String title, String value) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              SizedBox(width: 10),
              Text(value, style: TextStyle(color: Colors.green))
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
              child: Column(
                children: [
                  AutocompleteField(
                    options: _options,
                    label: "Tìm hàng để nhập",
                    callback: (Product productAdd) {
                      if (!_productOrder.contains(productAdd)) {
                        setState(() {
                          _productOrder.add(productAdd);
                        });
                      }
                    },
                  ),

                  // Text(_productOrder.map((e) => e.id));

                  for (var i = 0; i < _productOrder.length; i++) ...[
                    SizedBox(height: 30),
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                _productOrder.removeAt(i);
                              });
                            },
                            icon: Icon(Icons.close))),
                    Container(
                      height: 140,
                      width: 140,
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        onError: (exception, stackTrace) => {},
                        image: MemoryImage(_productOrder[i].imageProduct),
                        fit: BoxFit.contain,
                      )),
                    ),
                    SizedBox(height: 30),
                    Text("Tên sản phẩm: ${_productOrder[i].productName} ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: TextSize().getLabelTextSize())),
                    getDivider(),
                    rowDescription(
                        "Nhập hàng từ anh/chị:", _productOrder[i].distributor),
                    SizedBox(height: 10),
                    rowDescription("Giá:",
                        "${UtilsFunction().formatCurrency(_productOrder[i].price)} / 1${renderType(_productOrder[i].type)}"),
                    SizedBox(height: 10),
                    rowDescription("Hiện đang có:",
                        "${_productOrder[i].amount} ${renderType(_productOrder[i].type)} (Trong kho)"),
                    SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onSubmitted: (amount) {
                          _productOrderWithAmount.add(Order(
                              id: _productOrder[i].id,
                              amount: double.parse(amount)));
                        },
                        decoration: const InputDecoration(
                          label: Text("Số lượng cần nhập thêm"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    // Text(_productOrder[i].productName)
                  ],
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        // onPressed: () async {
                        //   handleSubmit();
                        // },
                        onPressed: () {
                          for (var i = 0; i < _productBox.length; i++) {
                            Product temp = _productBox.getAt(i);
                            _productOrderWithAmount.forEach((element) {
                              if (element.id == temp.id) {
                                temp.amount += element.amount;
                              }
                            });

                            // _options.add(_productBox.getAt(i));
                          }
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.done,
                          size: 24.0,
                        ),
                        label: Text('Hoàn thành'), // <-- Text
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 24.0,
                        ),

                        label: Text('Hủy'), // <-- Text
                      ),
                    ],
                  )
                  // _productOrder.isNotEmpty
                  //     ? _productOrder.map((e) => Text(e.id))
                  //     : Text("")
                ],
              ))),
      appBar: CustomAppBar(
          backButton: true,
          title: Text("Nhập hàng",
              style: TextStyle(fontSize: TextSize().getLabelTextSize())),
          widgetActions: []),
    );
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
