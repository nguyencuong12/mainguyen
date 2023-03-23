import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mainguyen/models/guest/guestModel.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/widgets/productDetails/productDetails.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/product/product.dart';

class UtilsWidgetClass {
  navigateScreen(BuildContext context, dynamic page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  renderTypeForGuest(GuestTypeEnum type) {
    switch (type) {
      case GuestTypeEnum.dearCustomer:
        return "Thân thiết";

      case GuestTypeEnum.guestNormal:
        return "Vãng lai";

      case GuestTypeEnum.vip:
        return "VIP";
    }
  }

  copyImage(Uint8List image) async {
    if (image.isNotEmpty) {
      List<XFile> _files = [];
      final directory = await getApplicationDocumentsDirectory();
      String fullPath = "${directory.path}/don-hang.png";
      final pathOfImage = await File(fullPath).create();
      await pathOfImage.writeAsBytes(image);
      XFile fileImage = XFile(fullPath);
      _files.add(fileImage);
      await Share.shareXFiles(_files);
    }
  }

  Future chooseImage(ImageSource media) async {
    final ImagePicker picker = ImagePicker();
    var img = await picker.pickImage(source: media);

    return await img?.readAsBytes();
  }

  renderImageWithChooseFunc(Uint8List bytes, Function callback, double size) {
    return InkWell(
        onTap: () {
          callback();
        },
        child: CircleAvatar(
            radius: size,
            onBackgroundImageError: (exception, stackTrace) {},
            backgroundImage: MemoryImage(bytes)));
  }

  renderGroupActionsButton(BuildContext context, Function onSubmit) {
    return Row(
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
          onPressed: () async {
            onSubmit();
            // Navigator.pop(context);
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
    );
  }

  callToast(String message, ToastGravity position) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: position,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // renderRichText(
  //   String content,
  //   int maxLine,
  // ) {
  //   return RichText(
  //     maxLines: maxLine,
  //     overflow: TextOverflow.ellipsis,
  //     strutStyle: StrutStyle(fontSize: 12.0),
  //     text: TextSpan(style: TextStyle(color: Colors.black), text: content),
  //   );
  // }
}

class RenderRichText extends StatelessWidget {
  const RenderRichText(
      {super.key,
      required this.content,
      required this.maxLine,
      this.style,
      this.textAlign});
  final String content;
  final int maxLine;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return RichText(
      // textAlign: center,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      strutStyle: StrutStyle(fontSize: 12.0),
      text: TextSpan(
          style: style ?? const TextStyle(color: Colors.black), text: content),
    );
  }
}

class RenderTextFormField extends StatelessWidget {
  RenderTextFormField(
      {super.key,
      required this.label,
      required this.numberType,
      required this.onSubmit,
      this.initValue});
  final String label;
  final bool numberType;
  Function onSubmit;
  final String? initValue;

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (initValue != "") {
      _textEditingController.text = initValue!;
    }
    return Column(
      children: [
        const SizedBox(height: 10),
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
                    numberType ? TextInputType.phone : TextInputType.text,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            )),
        const SizedBox(height: 20),
      ],
    );
  }
}

class AutocompleteFieldGuest extends StatefulWidget {
  AutocompleteFieldGuest(
      {super.key,
      required this.callbackSelect,
      required this.callbackSubmit,
      required this.label});
  final void Function(GuestModel) callbackSelect;
  final void Function(String) callbackSubmit;
  final String label;

  @override
  _AutocompleteFieldGuestState createState() => _AutocompleteFieldGuestState();
}

class _AutocompleteFieldGuestState extends State<AutocompleteFieldGuest> {
  List<GuestModel> options = [];
  late Box _guestBox;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _openGuestModel();
  }

  Future _openGuestModel() async {
    _guestBox = await Hive.openBox('guest');
    for (var i = 0; i < _guestBox.length; i++) {
      options.add(_guestBox.getAt(i));
    }
    setState(() {});
    return;
  }

  renderType(GuestTypeEnum type) {
    switch (type) {
      case GuestTypeEnum.dearCustomer:
        return "Thân thiết";

      case GuestTypeEnum.guestNormal:
        return "Vãng lai";

      case GuestTypeEnum.vip:
        return "VIP";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80,
        child: InputDecorator(
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(widget.label),
                filled: true,
                fillColor: Colors.white,
                prefix: const Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            child: RawAutocomplete<GuestModel>(
              focusNode: _focusNode,
              textEditingController: _textEditingController,
              optionsBuilder: (TextEditingValue textEditingValue) {
                return options.where((GuestModel guest) {
                  return guest.guestName
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextFormField(
                  // initialValue: valueAdd,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên người mua hàng';
                    }
                    return null;
                  },
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(border: InputBorder.none),

                  onChanged: (String value) {
                    widget.callbackSubmit(value);
                  },
                );
              },
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<GuestModel> onSelected,
                  Iterable<GuestModel> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: Container(
                      height: 240.0,
                      width: screenSizeWithoutContext.width / 3.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final GuestModel guest = options.elementAt(index);
                          return GestureDetector(
                              onTap: () {
                                // onSelected(option);
                                _textEditingController.text = guest.guestName;
                                widget.callbackSelect(guest);
                                UtilsFunction().closeKeyboard();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  child: ListTile(
                                    trailing: Container(
                                        clipBehavior: Clip.none,
                                        padding: const EdgeInsets.only(
                                            top: 4,
                                            bottom: 4,
                                            left: 10,
                                            right: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Text(renderType(guest.guestType),
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white))),
                                    // subtitle: Text("Vị trí: ",
                                    //     style: const TextStyle(fontSize: 12)),
                                    leading: guest.avatar != null
                                        ? CircleAvatar(
                                            radius: 18,
                                            onBackgroundImageError:
                                                (exception, stackTrace) {},
                                            backgroundImage:
                                                MemoryImage(guest.avatar!))
                                        : CircleAvatar(
                                            radius: 18,
                                            onBackgroundImageError:
                                                (exception, stackTrace) {},
                                            backgroundImage: AssetImage(
                                                "assets/appIcons/user.png")),
                                    title: RenderRichText(
                                        content: guest.guestName, maxLine: 1),
                                    // Text(
                                    //   "${guest.guestName}",
                                    //   style: const TextStyle(fontSize: 12),
                                    // ),
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

/// PRODUCT
///
///

class AutocompleteFieldProduct extends StatefulWidget {
  AutocompleteFieldProduct(
      {super.key,
      required this.label,
      required this.callback,
      required this.options});
  final List<Product> options;
  final String label;
  final void Function(Product) callback;
  @override
  State<AutocompleteFieldProduct> createState() =>
      _AutocompleteFieldProductState();
}

class _AutocompleteFieldProductState extends State<AutocompleteFieldProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: InputDecorator(
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(widget.label),
                filled: true,
                fillColor: Colors.white,
                prefix: const Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            child: RawAutocomplete<Product>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return widget.options.where((Product product) {
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
                                widget.callback(product);

                                UtilsFunction().closeKeyboard();
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
