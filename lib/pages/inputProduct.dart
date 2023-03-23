import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/models/product/product.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/photoView.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';

class InputProduct extends StatefulWidget {
  InputProduct({Key? key, this.initOrder}) : super(key: key);

  Product? initOrder;

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
  final _formKey = GlobalKey<FormState>();

  handleInitOrder() {
    if (widget.initOrder != null) {
      setState(() {
        _productOrder.add(widget.initOrder!);
      });
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _openBox();
    handleInitOrder();
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
          bodyWidget: SizedBox(
              height: screenSizeWithoutContext.height / 2,
              width: screenSizeWithoutContext.width,
              child: Column(
                children: [
                  AutocompleteFieldProduct(
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
                  for (var i = 0; i < _productOrder.length; i++) ...[
                    const SizedBox(height: 30),
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                _productOrder.removeAt(i);
                              });
                            },
                            icon: Icon(Icons.close))),
                    InkWell(
                        onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PhotoViewWidget(
                                        image: _productOrder[i].imageProduct)),
                              )
                            },
                        child: Container(
                          height: 140,
                          width: 140,
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            onError: (exception, stackTrace) => {},
                            image: MemoryImage(_productOrder[i].imageProduct),
                            fit: BoxFit.contain,
                          )),
                        )),

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
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập số lượng hàng cần nhập thêm';
                            }
                            return null;
                          },
                          onFieldSubmitted: (amount) {
                            try {
                              _productOrderWithAmount.add(Order(
                                  id: _productOrder[i].id,
                                  amount: double.parse(amount)));
                            } catch (errr) {}
                          },
                          decoration: const InputDecoration(
                            label: Text("Số lượng cần nhập thêm"),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    )

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
                          if (_formKey.currentState!.validate()) {
                            for (var i = 0; i < _productBox.length; i++) {
                              Product temp = _productBox.getAt(i);
                              _productOrderWithAmount.forEach((element) {
                                if (element.id == temp.id) {
                                  temp.amount += element.amount;
                                }
                              });
                            }
                            Navigator.pop(context);
                            // _options.add(_productBox.getAt(i));
                          }
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

                        label: const Text('Hủy'), // <-- Text
                      ),
                    ],
                  )
                ],
              ))),
      appBar: CustomAppBar(
          backButton: true,
          title: TitleAppbarWidget(content: "Nhập hàng"),
          widgetActions: []),
    );
  }
}
