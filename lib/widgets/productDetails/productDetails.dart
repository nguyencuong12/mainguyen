import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/models/product/product.dart';
import 'package:mainguyen/utils/colorApps.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.product});
  final Product product;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
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
    // print("AA ${eurosInUSFormat.format(1000000.0)}");
    super.initState();
  }

  rowDescription(String title, String value) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              SizedBox(width: 10),
              Text(value, style: TextStyle(color: Colors.green))
            ],
          )),
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
                    print("AA");
                  },
                  icon: Icon(Icons.edit))
            ]),
        body: BodyWidget(
            bodyWidget: Column(
          children: [
            Container(
              height: 140,
              width: 140,
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                onError: (exception, stackTrace) => {},
                image: MemoryImage(widget.product.imageProduct),
                fit: BoxFit.contain,
              )),
            ),

            // Container(
            //     height: 80,
            //     width: 80,
            //     child: Image.asset("assets/appIcons/package.png")),
            SizedBox(height: 10),
            Container(
                height: 400,
                width: screenSizeWithoutContext.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: ColorsInApp().getAccentColor1()),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tên sản phẩm: ${widget.product.productName} ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: TextSize().getLabelTextSize())),
                        getDivider(),
                        rowDescription(
                            "Ngày nhập hàng:",
                            UtilsFunction()
                                .formatDateTime(widget.product.date)),
                        getDivider(),
                        rowDescription("Mã hàng:", widget.product.id),
                        getDivider(),
                        rowDescription("Nhập hàng từ anh/chị:",
                            widget.product.distributor),
                        getDivider(),
                        rowDescription(
                            "Giá:",
                            UtilsFunction()
                                .formatCurrency(widget.product.price)),
                        getDivider(),
                        rowDescription("Tổng số hàng nhập:",
                            "${widget.product.amount.toString()} ${renderType(widget.product.type)}"),
                        getDivider(),
                        rowDescription(
                            "Vị trí hàng trong kho:", widget.product.location),
                        getDivider(),
                        rowDescription("Tổng tiền chi:",
                            "${UtilsFunction().formatCurrency((widget.product.price * widget.product.amount))}"),
                        getDivider(),
                      ],
                    ))),
          ],
        )));
  }
}
