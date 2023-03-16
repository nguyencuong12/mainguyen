import 'package:flutter/material.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/models/soldOrdered/soldOrdered.dart';

class SoldOrders extends StatefulWidget {
  const SoldOrders({super.key});

  @override
  State<SoldOrders> createState() => _SoldOrdersState();
}

class _SoldOrdersState extends State<SoldOrders> {
  late Box _soldOrderedBox;
  late List<SoldOrderedModel> _soldOrdered = [];
  Divider getDivider() {
    return const Divider(
      height: 30,
      thickness: 1,
      indent: 10,
      endIndent: 0,
      color: Colors.red,
    );
  }

  Future _openBox() async {
    _soldOrderedBox = await Hive.openBox('soldOrdered');
    // _soldOrderedBox.clear();
    for (var i = 0; i < _soldOrderedBox.length; i++) {
      _soldOrdered.add(_soldOrderedBox.getAt(i));
    }

    setState(() {});
    return;
  }

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyWidget(
            bodyWidget: Column(
          children: [
            for (var i = 0; i < _soldOrdered.length; i++) ...[
              getDivider(),
              Text("(${i + 1})"),
              SizedBox(height: 20),
              Image(image: MemoryImage(_soldOrdered[i].image)),
              SizedBox(height: 50),
            ]
          ],
        )),
        appBar: CustomAppBar(
            widgetActions: [],
            backButton: true,
            title: Text(
              "Các đơn hàng đã bán",
              style: TextStyle(fontSize: TextSize().getLabelTextSize()),
            )));
  }
}
