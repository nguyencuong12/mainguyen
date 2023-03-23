import 'package:flutter/material.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/dialogs/dialogs.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/models/soldOrdered/soldOrdered.dart';
import 'package:mainguyen/widgets/emptyWidget.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';

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
    _soldOrdered = [];
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
            bodyWidget: _soldOrdered.isNotEmpty
                ? Column(
                    children: [
                      for (var i = _soldOrdered.length - 1; i >= 0; i--) ...[
                        InkWell(
                          onTap: () => {},
                          child: Container(
                              child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        await UtilsWidgetClass()
                                            .copyImage(_soldOrdered[i].image);

                                        // getDeleteDialog(
                                        //     context,
                                        //     () => {
                                        //           _soldOrderedBox.deleteAt(i),
                                        //           setState(() {
                                        //             _openBox();
                                        //           })
                                        //         });
                                      },
                                      icon: const Icon(Icons.copy,
                                          color: Colors.blue)),
                                  IconButton(
                                      onPressed: () {
                                        getDeleteDialog(
                                            context,
                                            () => {
                                                  _soldOrderedBox.deleteAt(i),
                                                  setState(() {
                                                    _openBox();
                                                  })
                                                });
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red))
                                ],
                              ),
                              SizedBox(height: 20),
                              Image(image: MemoryImage(_soldOrdered[i].image)),
                              SizedBox(height: 80),
                            ],
                          )),
                        )
                      ]
                    ],
                  )
                : ImageEmpty(title: "Không có đơn hàng nào ")),
        appBar: CustomAppBar(
            widgetActions: [],
            backButton: true,
            title: TitleAppbarWidget(content: "Các đơn hàng đã bán")));
  }
}
