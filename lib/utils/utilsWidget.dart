import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mainguyen/models/guest/guestModel.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  renderImageWithChooseFunc(Uint8List bytes, Function callback) {
    return InkWell(
        onTap: () {
          callback();
        },
        child: Container(
          height: 150,
          decoration:
              BoxDecoration(image: DecorationImage(image: MemoryImage(bytes))),
        ));
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
