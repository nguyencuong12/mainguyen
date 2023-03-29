import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';

class OrderDrinkResult extends StatefulWidget {
  OrderDrinkResult({super.key, required this.image});
  Uint8List image;

  @override
  State<OrderDrinkResult> createState() => _OrderDrinkResultState();
}

class _OrderDrinkResultState extends State<OrderDrinkResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            backButton: true,
            title: TitleAppbarWidget(content: "Phiếu"),
            widgetActions: []),
        body: BodyWidget(
            bodyWidget: Column(
          children: [
            Flex(
              mainAxisAlignment: MainAxisAlignment.end,
              direction: Axis.horizontal,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.copy, color: Colors.blue))
              ],
            ),
            Image.memory(widget.image)
          ],
        )));
  }
}
