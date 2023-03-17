import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewWidget extends StatefulWidget {
  PhotoViewWidget({super.key, required this.image});
  Uint8List image;
  @override
  State<PhotoViewWidget> createState() => _PhotoViewWidgetState();
}

class _PhotoViewWidgetState extends State<PhotoViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            backButton: true,
            title: Text("Xem hình ảnh",
                style: TextStyle(fontSize: TextSize().getLabelTextSize())),
            widgetActions: []),
        body: Container(
            height: screenSizeWithoutContext.height / 2,
            width: screenSizeWithoutContext.width,
            child: PhotoView(imageProvider: MemoryImage(widget.image))));
  }
}
