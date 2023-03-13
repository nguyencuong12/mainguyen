import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/utils/colorApps.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({Key? key}) : super(key: key);

  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  XFile? image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
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
                              child: Image.file(
                                //to show image, you type like this.
                                File(image!.path),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                              ),
                            ),
                          )
                        : Text(""),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          label: Text("Tên người cung cấp hàng"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          label: Text("Tên sản phẩm"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: Text("Giá nhập"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: Text("Số lượng"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          label: Text("Vị trí đặt trong kho"),
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
                          onPressed: () {},
                          icon: const Icon(
                            Icons.done,
                            size: 24.0,
                          ),
                          label: Text('Hoàn thành'), // <-- Text
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.done,
                            size: 24.0,
                          ),

                          label: Text('Hủy'), // <-- Text
                        ),
                      ],
                    )
                  ],
                ))));
  }
}
