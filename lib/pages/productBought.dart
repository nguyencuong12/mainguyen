import 'package:flutter/material.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';

class ProductBoughtScreen extends StatefulWidget {
  const ProductBoughtScreen({super.key});

  @override
  State<ProductBoughtScreen> createState() => _ProductBoughtScreenState();
}

class _ProductBoughtScreenState extends State<ProductBoughtScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          backButton: true,
          title: Text("Đơn hàng đã xuất",
              style: TextStyle(fontSize: TextSize().getLabelTextSize())),
          widgetActions: []),
      body: BodyWidget(bodyWidget: Text("THISI S BODY")),
    );
  }
}
