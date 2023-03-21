import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/classes/product/product.dart';
import 'package:mainguyen/models/product/product.dart';
import 'package:mainguyen/utils/colorApps.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/photoView.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.product});
  final Product product;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ProductClass productEdit = ProductClass();
  late Product product = widget.product;

  Divider getDivider() {
    return const Divider(
      height: 30,
      thickness: 1,
      indent: 10,
      endIndent: 0,
      color: Color.fromARGB(255, 175, 170, 170),
    );
  }

  XFile? image;
  final ImagePicker picker = ImagePicker();
  // late Uint8List _imageMemory = Uint8List(0);

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    image = img;
    product.imageProduct = (await image?.readAsBytes())!;
    await _openBox();
  }

  @override
  void initState() {
    // print("AA ${eurosInUSFormat.format(1000000.0)}");
    productEdit.price = widget.product.price;
    productEdit.amount = widget.product.amount;
    productEdit.location = widget.product.location;

    super.initState();
  }

  Future _openBox() async {
    Box productBox = await Hive.openBox('product');
    for (var i = 0; i < productBox.length; i++) {
      Product temp = productBox.getAt(i);
      if (temp.id == product.id) {
        product = temp;
      }
    }
    setState(() {});
    return;
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

  scroll(Product product) {
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return Container(
              padding: EdgeInsets.all(10.0),
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 4,
                                width: 40,
                                decoration:
                                    BoxDecoration(color: Colors.black12))
                          ],
                        )),
                    Text("Tên sản phẩm: ${product.productName}",
                        style: Theme.of(context).textTheme.headline6),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Divider(height: 4),
                    ),
                    renderRowVer1(
                      title: "Nhập hàng từ (anh/chị):",
                      content: product.distributor,
                    ),

                    renderRowVer1(
                        title: "Giá sản phẩm:",
                        content: UtilsFunction().formatCurrency(product.price),
                        color: Colors.red),

                    renderRowVer1(
                        title: "Số lượng còn trong kho:",
                        content:
                            "${product.amount.toString()} ${renderType(product.type)}"),

                    renderRowVer1(
                        title: "Vị trí hàng trong kho:",
                        content: product.location,
                        color: Colors.blue),

                    renderRowVer1(
                      title: "Ngày nhập sản phẩm:",
                      content: UtilsFunction().formatDateTime(product.date),
                    ),

                    SizedBox(height: 15),
                    product.amount <= 0
                        ? Align(
                            alignment: Alignment.center,
                            child: Container(
                                width: 100,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  "Hết hàng",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                )))
                        : Text(""),

                    // Padding(
                    //     child: Divider(height: 4),
                    //     padding: EdgeInsets.symmetric(vertical: 15)),
                  ],
                ),
              ));
        });
  }

  renderTextField(
      String label, bool typeNumber, Function onSubmit, String value) {
    final TextEditingController _textEditingController =
        TextEditingController();
    if (value != "") {
      _textEditingController.text = value;
    }
    return Column(
      children: [
        SizedBox(
            height: 80,
            child: InputDecorator(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(label),
              ),
              child: TextField(
                controller: _textEditingController,
                onChanged: (value) => {onSubmit(value)},
                keyboardType:
                    typeNumber ? TextInputType.phone : TextInputType.text,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            backButton: true,
            title: Text("Chi tiết sản phẩm",
                style: TextStyle(fontSize: TextSize().getLabelTextSize())),
            widgetActions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text(
                                "Chỉnh sửa",
                                textAlign: TextAlign.center,
                              ),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              content: Builder(
                                builder: (context) {
                                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                  var height =
                                      MediaQuery.of(context).size.height;
                                  var width = MediaQuery.of(context).size.width;
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Container(
                                        height: height - 200,
                                        width: width - 10,
                                        child: Column(
                                          children: [
                                            renderTextField(
                                                "Giá sản phẩm",
                                                true,
                                                (value) => {
                                                      productEdit.price =
                                                          int.parse(value),
                                                    },
                                                productEdit.price.toString()),
                                            SizedBox(height: 20),
                                            renderTextField(
                                                "Số lượng trong kho",
                                                true,
                                                (value) => {
                                                      productEdit.amount =
                                                          double.parse(value)
                                                    },
                                                productEdit.amount.toString()),
                                            SizedBox(height: 20),
                                            renderTextField(
                                                "Vị trí trong kho",
                                                false,
                                                (value) => {
                                                      productEdit.location =
                                                          value
                                                    },
                                                productEdit.location
                                                    .toString()),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors
                                                        .green, // background
                                                    onPrimary: Colors
                                                        .white, // foreground
                                                  ),
                                                  // onPressed: () async {
                                                  //   handleSubmit();
                                                  // },
                                                  onPressed: () async => {
                                                    product.amount =
                                                        productEdit.amount!,
                                                    product.price =
                                                        productEdit.price!,
                                                    product.location =
                                                        productEdit.location!,
                                                    await _openBox(),
                                                    Fluttertoast.showToast(
                                                        msg: "Đã chỉnh sửa ",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 10,
                                                        backgroundColor:
                                                            Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0),
                                                    Navigator.pop(context)
                                                  },
                                                  icon: const Icon(
                                                    Icons.done,
                                                    size: 24.0,
                                                  ),
                                                  label: Text(
                                                      'Hoàn thành'), // <-- Text
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors
                                                        .red, // background
                                                    onPrimary: Colors
                                                        .white, // foreground
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(
                                                    Icons.close,
                                                    size: 24.0,
                                                  ),

                                                  label:
                                                      Text('Hủy'), // <-- Text
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                  );
                                },
                              ),
                            ));
                    // showDialog(
                    //     context: context,
                    //     builder: (_) {
                    //       return AlertDialog(
                    //           title: Text("Chỉnh sửa"),
                    //           insetPadding: EdgeInsets.zero,
                    //           content: Column(
                    //             children: [
                    //               renderTextField(
                    //                   "Giá sản phẩm", false, () => {}, "")
                    //             ],
                    //           ));
                    //     });
                  },
                  icon: Icon(Icons.edit))
            ]),
        body: Stack(
          children: [
            InkWell(
              onTap: () => {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        insetPadding: EdgeInsets.symmetric(vertical: 220),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              //if user click this button, user can upload image from gallery
                              onPressed: () {
                                Navigator.pop(context);
                                getImage(ImageSource.gallery);
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.image),
                                  SizedBox(width: 10),
                                  Text('Chọn ảnh từ điện thoại'),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              //if user click this button, user can upload image from gallery
                              onPressed: () {
                                Navigator.pop(context);
                                getImage(ImageSource.camera);
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.image),
                                  SizedBox(width: 10),
                                  Text('Chụp ảnh'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    })
              },
              child: SizedBox(
                  width: double.infinity,
                  child: Image.memory(product.imageProduct)),
            ),
            scroll(widget.product)
          ],
        )

        // BodyWidget(
        //     bodyWidget: Column(
        //   children: [
        //     InkWell(
        //         onTap: () => {
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => PhotoViewWidget(
        //                         image: widget.product.imageProduct)),
        //               )
        //             },
        //         child: Container(
        //           height: 140,
        //           width: 140,
        //           padding: const EdgeInsets.all(0),
        //           decoration: BoxDecoration(
        //               image: DecorationImage(
        //             onError: (exception, stackTrace) => {},
        //             image: MemoryImage(widget.product.imageProduct),
        //             fit: BoxFit.contain,
        //           )),
        //         )),
        //     SizedBox(height: 10),
        //     Container(
        //         height: 400,
        //         width: screenSizeWithoutContext.width,
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(20.0),
        //             color: ColorsInApp().getAccentColor1()),
        //         child: Padding(
        //             padding: EdgeInsets.all(10.0),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text("Tên sản phẩm: ${widget.product.productName} ",
        //                     style: TextStyle(
        //                         fontWeight: FontWeight.w600,
        //                         fontSize: TextSize().getLabelTextSize())),
        //                 getDivider(),
        //                 rowDescription(
        //                     "Ngày nhập hàng:",
        //                     UtilsFunction()
        //                         .formatDateTime(widget.product.date)),
        //                 getDivider(),
        //                 rowDescription("Mã hàng:", widget.product.id),
        //                 getDivider(),
        //                 rowDescription("Nhập hàng từ anh/chị:",
        //                     widget.product.distributor),
        //                 getDivider(),
        //                 rowDescription(
        //                     "Giá:",
        //                     UtilsFunction()
        //                         .formatCurrency(widget.product.price)),
        //                 getDivider(),
        //                 rowDescription("Tổng số hàng nhập:",
        //                     "${widget.product.amount.toString()} ${renderType(widget.product.type)}"),
        //                 getDivider(),
        //                 rowDescription(
        //                     "Vị trí hàng trong kho:", widget.product.location),
        //                 getDivider(),
        //                 rowDescription("Tổng tiền chi:",
        //                     "${UtilsFunction().formatCurrency((widget.product.price * widget.product.amount))}"),
        //                 getDivider(),
        //               ],
        //             ))),
        //   ],
        // ))
        );
  }
}

class renderRowVer1 extends StatelessWidget {
  renderRowVer1({
    required this.title,
    required this.content,
    this.color,
    super.key,
  });
  String content;
  String title;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium!),
          Text(" ${content}",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: color)),
        ],
      ),
    );
  }
}
