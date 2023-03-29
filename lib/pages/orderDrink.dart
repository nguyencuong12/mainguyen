import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/pages/orderDrinkResult.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class OrderDrink extends StatefulWidget {
  const OrderDrink({super.key});

  @override
  State<OrderDrink> createState() => _OrderDrinkState();
}

class OrderBill {
  String order;
  String amount;
  OrderBill({required this.order, required this.amount});
}

class _OrderDrinkState extends State<OrderDrink> {
  @override
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  List<OrderBill> _listOrder = [];
  WidgetsToImageController controller = WidgetsToImageController();
  DataRow renderDataRow(OrderBill order) {
    return DataRow(cells: [
      DataCell(Text(order.order)),
      DataCell(Text(order.amount)),
    ]);
  }

  renderTextField(String label, bool typeNumber, Function onSubmit,
      TextEditingController controller) {
    return Column(
      children: [
        SizedBox(
            height: 80,
            child: InputDecorator(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(label),
              ),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập thông tin vào';
                  }
                  return null;
                },
                controller: controller,
                onChanged: (value) => {onSubmit(value)},
                keyboardType:
                    typeNumber ? TextInputType.phone : TextInputType.text,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ))
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            backButton: true,
            title: TitleAppbarWidget(content: "Tạo phiếu mua hàng"),
            widgetActions: []),
        body: BodyWidget(
            bodyWidget: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: renderTextField(
                    "Hàng cần mua", false, (submitValue) => {}, _productName),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: renderTextField(
                    "Số lượng", false, (submitValue) => {}, _amount),
              ),
              UtilsWidgetClass().renderGroupActionsButton(context, () {
                if (_formKey.currentState!.validate()) {
                  _listOrder.add(OrderBill(
                      order: _productName.text, amount: _amount.text));
                  _productName.text = "";
                  _amount.text = "";
                  UtilsFunction().closeKeyboard();
                  setState(() {});
                }
              }),
              WidgetsToImage(
                controller: controller,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      horizontalMargin: 10,
                      columns: const [
                        DataColumn(
                            label: Text("Tên sản phẩm",
                                style: TextStyle(fontSize: 9))),
                        DataColumn(
                            label: Text("Số lượng",
                                style: TextStyle(fontSize: 9))),
                      ],
                      rows: [
                        for (var i = 0; i < _listOrder.length; i++) ...[
                          renderDataRow(_listOrder[i])
                        ]
                      ],
                    )),
              ),
              if (_listOrder.length > 0)
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () async {
                      Uint8List? _imageBytes = await controller.capture();

                      UtilsWidgetClass().navigateScreen(
                          context, OrderDrinkResult(image: _imageBytes!));
                      // Navigator.pop(context);
                    },
                    icon: Icon(Icons.done),
                    label: Text("Xuất phiếu mua hàng")),
            ],
          ),
        )));
  }
}
