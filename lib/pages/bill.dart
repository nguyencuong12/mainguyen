import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/classes/guest/guestOrder.dart';
import 'package:mainguyen/classes/sell/sellProductClass.dart';
import 'package:mainguyen/models/guest/guestModel.dart';
import 'package:mainguyen/models/product/product.dart';
import 'package:mainguyen/models/soldOrdered/soldOrdered.dart';
import 'package:mainguyen/pages/homePage.dart';
import 'package:mainguyen/pages/soldOrdered.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:uuid/uuid.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../utils/utilsFunction.dart';

class BillPage extends StatefulWidget {
  BillPage(
      {super.key, required this.listProductOrder, required this.guestOrder});
  List<SellProduct> listProductOrder;
  GuestOrder guestOrder;
  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  late Box _productBox;
  late Box _soldOrdered;
  late List<Product> _productsInDB = [];
  WidgetsToImageController controller = WidgetsToImageController();
  Uint8List? _imageBytes;

  Future _openBox() async {
    _productBox = await Hive.openBox('product');
    for (var i = 0; i < _productBox.length; i++) {
      _productsInDB.add(_productBox.getAt(i));
    }
    setState(() {});
    return;
  }

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Divider getDivider() {
    return const Divider(
      height: 25,
      thickness: 1,
      indent: 0,
      endIndent: 0,
      color: Color.fromARGB(255, 175, 170, 170),
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

  double handleRenderTotal() {
    double result = 0.0;
    for (var productDB in _productsInDB) {
      for (var productOrder in widget.listProductOrder) {
        {
          if (productDB.id == productOrder.id) {
            result += productOrder.amount * productOrder.price;
          }
        }
        ;
      }
    }

    return result;
  }

  DataRow renderDataRow(SellProduct product) {
    return DataRow(cells: [
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Container(
              width: 70,
              child: RenderRichText(content: product.productName, maxLine: 1)),

          // Text(, style: TextStyle(fontSize: 10))
        ],
      )),
      DataCell(Text(
          "${product.amount.toString()} (${renderType(product.type)})",
          style: TextStyle(fontSize: 10))),
      DataCell(Text(UtilsFunction().formatCurrency(product.price),
          style: const TextStyle(fontSize: 10, color: Colors.blue))),
      // DataCell(Text(
      //     " ${UtilsFunction().formatCurrency(product.price * product.amount)}    ",
      //     style: const TextStyle(fontSize: 10, color: Colors.blue))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: Text(""),
          backButton: true,
          // title: Text("Hóa đơn",
          //     style: TextStyle(fontSize: TextSize().getLabelTextSize())),
          widgetActions: []),
      body: BodyWidget(
          bodyWidget: Container(
              width: screenSizeWithoutContext.width,
              child: Column(
                children: [
                  Container(
                    child: WidgetsToImage(
                      controller: controller,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 2)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: const [
                                //     Text("(MAI NGUYỄN) ",
                                //         style: TextStyle(
                                //             color: Colors.green,
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.w500)),
                                //     Text("HÓA ĐƠN BÁN HÀNG ",
                                //         style: TextStyle(
                                //             color: Colors.green,
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.w500)),
                                //   ],
                                // ),
                                Flex(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  direction: Axis.horizontal,
                                  children: const [
                                    Text("HÓA ĐƠN BÁN HÀNG",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Flex(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  direction: Axis.horizontal,
                                  children: const [
                                    Text("(MAI NGUYỄN) ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Flex(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  direction: Axis.horizontal,
                                  children: [
                                    Text(
                                        "Ngày bán hàng: ${UtilsFunction().formatDateTime(DateTime.now())}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                                getDivider(),
                                const SizedBox(height: 20),
                                Text(
                                    "Tên khách hàng : ${widget.guestOrder.guestName ?? ""}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12)),
                                const SizedBox(height: 5),
                                Text(
                                    "Số điện thoại khách hàng : ${widget.guestOrder.phoneNumber ?? ""}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12)),
                                const SizedBox(height: 5),
                                Text(
                                    "Địa chỉ của khách hàng: ${widget.guestOrder.address ?? ""}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12)),
                                const SizedBox(height: 10),
                                getDivider(),
                                SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      clipBehavior: Clip.none,
                                      horizontalMargin: 10,
                                      // dataRowHeight: 50,

                                      border:
                                          TableBorder.all(color: Colors.black),
                                      headingRowColor:
                                          MaterialStateProperty.all(
                                              Colors.amber[200]),

                                      // decoration: BoxDecoration(
                                      //   border: Border(
                                      //       right: Divider.createBorderSide(context,
                                      //           width: 5.0),
                                      //       left: Divider.createBorderSide(context,
                                      //           width: 5.0)),
                                      //   color: Colors.red,
                                      // ),
                                      columns: const [
                                        // DataColumn(
                                        //     label: Text("Ảnh",
                                        //         style: TextStyle(fontSize: 9))),
                                        DataColumn(
                                            label: Expanded(
                                                child: Text('Mục',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 9)))),

                                        DataColumn(
                                            label: Expanded(
                                                child: Text('Số lượng',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 9)))),
                                        DataColumn(
                                            label: Expanded(
                                                child: Text('Giá',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 9)))),
                                        // DataColumn(
                                        //     label: Expanded(
                                        //         child: Text('Thành tiền',
                                        //             textAlign: TextAlign.center,
                                        //             style: TextStyle(
                                        //                 fontSize: 9)))),
                                      ],
                                      rows: [
                                        ...widget.listProductOrder
                                            .map((e) => renderDataRow(e))
                                      ],
                                    )),
                                const SizedBox(height: 20),
                                Flex(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  direction: Axis.horizontal,
                                  children: [
                                    const Text("Tổng tiền đơn hàng: ",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.red)),
                                    Text(
                                        UtilsFunction().formatCurrency(
                                            handleRenderTotal()),
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.red)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // _imageBytes != null
                  //     ? Image(
                  //         image: MemoryImage(_imageBytes!),
                  //       )
                  //     : Text(""),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () async {
                            if (widget.guestOrder.guestName != null) {
                              _imageBytes = await controller.capture();
                              for (var element in _productsInDB) {
                                for (var order in widget.listProductOrder) {
                                  if (element.id == order.id) {
                                    element.amount -= order.amount;
                                  }
                                }
                              }

                              _soldOrdered = await Hive.openBox('soldOrdered');
                              Box guestBox = await Hive.openBox('guest');
                              if (widget.guestOrder.id == null) {
                                var idGuestGen = Uuid().v4();
                                guestBox.add(GuestModel(
                                    guestName: widget.guestOrder.guestName!,
                                    guestPhoneNumber:
                                        widget.guestOrder.phoneNumber ?? "",
                                    guestType: GuestTypeEnum.guestNormal,
                                    guestID: idGuestGen,
                                    avatar: null,
                                    guestAddress:
                                        widget.guestOrder.address ?? ""));
                                _soldOrdered.add(SoldOrderedModel(
                                    idGuestOrder: idGuestGen,
                                    id: Uuid().v4(),
                                    image: _imageBytes!,
                                    guestOrder:
                                        widget.guestOrder.guestName ?? "",
                                    guestAddress:
                                        widget.guestOrder.address ?? "",
                                    guestPhoneNumber:
                                        widget.guestOrder.phoneNumber ?? "",
                                    soldOrdered: [
                                      for (var i = 0;
                                          i < widget.listProductOrder.length;
                                          i++) ...[
                                        OrderProductDescription(
                                            id: widget.listProductOrder[i].id,
                                            amount: widget
                                                .listProductOrder[i].amount,
                                            type:
                                                widget.listProductOrder[i].type,
                                            price: widget
                                                .listProductOrder[i].price,
                                            productName: widget
                                                .listProductOrder[i]
                                                .productName)
                                      ]
                                    ]));
                              } else {
                                _soldOrdered.add(SoldOrderedModel(
                                    idGuestOrder: widget.guestOrder.id ?? "",
                                    id: Uuid().v4(),
                                    image: _imageBytes!,
                                    guestOrder: widget.guestOrder.guestName!,
                                    guestAddress: widget.guestOrder.address,
                                    guestPhoneNumber:
                                        widget.guestOrder.phoneNumber,
                                    soldOrdered: [
                                      for (var i = 0;
                                          i < widget.listProductOrder.length;
                                          i++) ...[
                                        OrderProductDescription(
                                            id: widget.listProductOrder[i].id,
                                            amount: widget
                                                .listProductOrder[i].amount,
                                            type:
                                                widget.listProductOrder[i].type,
                                            price: widget
                                                .listProductOrder[i].price,
                                            productName: widget
                                                .listProductOrder[i]
                                                .productName)
                                      ]
                                    ]));
                              }

                              setState(() {
                                Fluttertoast.showToast(
                                    msg: "Đã tạo đơn hàng thành công !! ",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 10,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);

                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Vui lòng nhập tên người mua !! ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 10,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          icon: Icon(Icons.done),
                          label: Text("Tạo đơn hàng")),
                      SizedBox(
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
                          label: Text("Hủy"))
                    ],
                  )
                ],
              ))),
    );
  }
}
