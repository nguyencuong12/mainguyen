import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/classes/product/product.dart';
import 'package:mainguyen/models/product/product.dart';
import 'package:mainguyen/utils/colorApps.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:uuid/uuid.dart';

import '../enum/product/productEnum.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({Key? key}) : super(key: key);

  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  XFile? image;
  final ImagePicker picker = ImagePicker();
  ProductClass product = ProductClass()..type = ProductEnum.kg;
  late Uint8List _imageMemory = Uint8List(0);

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    image = img;
    _imageMemory = (await image?.readAsBytes())!;
    setState(() {});
  }

  @override
  Divider getDivider() {
    return const Divider(
      height: 30,
      thickness: 1,
      indent: 10,
      endIndent: 0,
      color: Color.fromARGB(255, 175, 170, 170),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void handleSubmit() async {
    var box = await Hive.openBox('product');
    var productCreate = Product(
        date: DateTime.now(),
        id: const Uuid().v4(),
        distributor: product.distributor!,
        productName: product.productName!,
        price: product.price!,
        amount: product.amount!,
        location: product.location!,
        type: getType(product.type!),
        imageProduct: _imageMemory);
    box.add(productCreate);
    Navigator.pop(context);
  }

  ProductEnumHive getType(ProductEnum type) {
    switch (type) {
      case ProductEnum.kg:
        return ProductEnumHive.kg;
      case ProductEnum.tree:
        return ProductEnumHive.tree;
      case ProductEnum.bag:
        return ProductEnumHive.bag;
    }
  }

  handleEnableSubmit() {
    if (product.type != null &&
        product.productName != null &&
        product.distributor != null &&
        product.amount != null &&
        product.price != null &&
        product.location != null) {
      return handleSubmit;
    } else {
      return null;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            backButton: true,
            title: Text("Tạo sản phẩm mới ",
                style: TextStyle(fontSize: TextSize().getLabelTextSize())),
            widgetActions: []),
        body: BodyWidget(
            bodyWidget: Container(
                width: screenSizeWithoutContext.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      //if user click this button, user can upload image from gallery
                      onPressed: () {
                        // Navigator.pop(context);
                        // getImage(ImageSource.gallery);

                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                insetPadding:
                                    EdgeInsets.symmetric(vertical: 220),
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
                            });
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.image),
                          SizedBox(width: 10),
                          Text('Chọn ảnh cho sản phẩm'),
                        ],
                      ),
                    ),
                    image != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(_imageMemory,
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 200,
                                  fit: BoxFit.cover),
                            ),
                          )
                        : Text(""),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: TextField(
                        onSubmitted: (distributor) {
                          setState(() {
                            product.distributor = distributor;
                          });
                        },
                        decoration: const InputDecoration(
                          label: Text("Tên người cung cấp hàng"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: TextField(
                        onSubmitted: (productName) {
                          setState(() {
                            product.productName = productName;
                          });
                        },
                        decoration: const InputDecoration(
                          label: Text("Tên sản phẩm"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SelectionMenu<String>(
                      itemsList: <String>['KG', 'CÂY', 'BAO'],
                      onItemSelected: (String selectedItem) {
                        switch (selectedItem) {
                          case "KG":
                            {
                              product.type = ProductEnum.kg;
                              break;
                            }
                          case "CÂY":
                            {
                              product.type = ProductEnum.tree;
                              break;
                            }
                          case "BAO":
                            {
                              product.type = ProductEnum.bag;
                              break;
                            }
                        }
                        setState(() {});
                      },
                      itemBuilder: itemBuildSelection,
                      showSelectedItemAsTrigger: true,
                      initiallySelectedItemIndex: 0,
                      closeMenuInsteadOfPop: true,
                      closeMenuOnEmptyMenuSpaceTap: false,
                      closeMenuWhenTappedOutside: true,
                      closeMenuOnItemSelected: true,
                      allowMenuToCloseBeforeOpenCompletes: true,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onSubmitted: (price) {
                          setState(() {
                            product.price = int.parse(price);
                          });
                        },
                        decoration: const InputDecoration(
                          label: Text("Giá sản phẩm"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onSubmitted: (amount) {
                          setState(() {
                            product.amount = double.parse(amount);
                          });
                        },
                        decoration: const InputDecoration(
                          label: Text("Số lượng"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: TextField(
                        onSubmitted: (location) {
                          setState(() {
                            product.location = location;
                          });
                        },
                        decoration: const InputDecoration(
                          label: Text("Vị trí đặt trong kho"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
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
                          onPressed: handleEnableSubmit(),
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
                            // box.length;
                            // Product b = box.getAt(0);
                            // print("IMAGE ${b.imageProduct}");
                            // a.clear();
                            // print("LENGTH ${a.length}");
                            // Product b = a.getAt(0);
                            // print("B ${b.location}");
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 24.0,
                          ),

                          label: Text('Hủy'), // <-- Text
                        ),
                      ],
                    )
                  ],
                ))));
  }

  Widget itemBuildSelection(
      BuildContext context, String item, OnItemTapped onItemTapped) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onItemTapped,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ClipOval(
                child: Container(
                  color: Color(0xff4db151),
                  height: 30,
                  width: 30,
                ),
              ),
              getDivider(),
              const Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Loại",
                    // style: textStyle,
                  ),
                ),
              ),
              Text(
                "$item",
                // style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
