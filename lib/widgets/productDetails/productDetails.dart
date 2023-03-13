import 'package:flutter/material.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/utils/colorApps.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

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

  Row rowDescription(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(title),
        Text(
          value,
        )
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
                    print("AA");
                  },
                  icon: Icon(Icons.edit))
            ]),
        body: BodyWidget(
            bodyWidget: Column(
          children: [
            Container(
                height: 80,
                width: 80,
                child: Image.asset("assets/appIcons/package.png")),
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
                        Text("Product Name : ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: TextSize().getLabelTextSize())),
                        getDivider(),
                        rowDescription("Mã hàng", "SP0005"),
                        getDivider(),
                        rowDescription("Mã hàng", "SP0005"),
                        getDivider(),
                        rowDescription("Mã hàng", "SP0005"),
                        getDivider(),
                        rowDescription("Mã hàng", "SP0005"),
                      ],
                    ))),
          ],
        )));
  }
}
