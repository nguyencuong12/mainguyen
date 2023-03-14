import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';

class CreateGuest extends StatefulWidget {
  const CreateGuest({super.key});

  @override
  State<CreateGuest> createState() => _CreateGuestState();
}

class _CreateGuestState extends State<CreateGuest> {
  XFile? image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          backButton: true,
          title: Text("Thêm khách hàng",
              style: TextStyle(fontSize: TextSize().getLabelTextSize())),
          widgetActions: []),
      body: BodyWidget(
          bodyWidget: Container(
              width: screenSizeWithoutContext.width,
              child: Column(
                children: [
                  image != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                height: 150,
                                width: 150,
                                child: Image.file(
                                  //to show image, you type like this.
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                ),
                              )),
                        )
                      : InkWell(
                          onTap: () => {getImage(ImageSource.gallery)},
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                    image:
                                        AssetImage("assets/appIcons/user.png"),
                                    fit: BoxFit.contain)),
                          ),
                        ),
                  const SizedBox(height: 15),
                  renderTextField("Tên khách hàng", false),
                  const SizedBox(height: 15),
                  renderTextField("SDT", true),
                  const SizedBox(height: 15),
                  renderTextField("Địa chỉ", false),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.next_plan),
                          label: Text("Hoàn thành")),
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
