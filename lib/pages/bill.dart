import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';

class BillPage extends StatefulWidget {
  const BillPage({super.key});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          backButton: true,
          title: Text("Hóa đơn",
              style: TextStyle(fontSize: TextSize().getLabelTextSize())),
          widgetActions: []),
      body: BodyWidget(
          bodyWidget: Container(
              width: screenSizeWithoutContext.width,
              child: Column(
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        Text("HÓA ĐƠN BÁN HÀNG ",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 5),
                        const Text("(MAI NGUYỄN) ",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 5),
                        getDivider(),
                        const Text("Số điện thoại khách hàng : 0978531164",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12)),
                        const SizedBox(height: 5),
                        const Text(
                            "Địa chỉ của khách hàng: 73 đường ĐHT 31 , phường Tân Hưng Thuận , Q12, TPHCM",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12)),
                        getDivider(),
                        const SizedBox(height: 5),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              horizontalMargin: 10,
                              columns: const [
                                DataColumn(
                                    label: Text("Ảnh",
                                        style: TextStyle(fontSize: 9))),
                                DataColumn(
                                    label: Text("Mục",
                                        style: TextStyle(fontSize: 9))),
                                DataColumn(
                                    label: Text("Số lượng",
                                        style: TextStyle(fontSize: 9))),
                                DataColumn(
                                    label: Text("Giá",
                                        style: TextStyle(fontSize: 9))),
                                DataColumn(
                                    label: Text("Thành tiền",
                                        style: TextStyle(fontSize: 9))),
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Text("1",
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text('1',
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text('1',
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text('1000'.toVND(),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.blue))),
                                  DataCell(Text('1000'.toVND(),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.blue))),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('1',
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text('1',
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text('1',
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text('1000'.toVND(),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.blue))),
                                  DataCell(Text('1000'.toVND(),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.blue))),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('1',
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text('1',
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text('1',
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text('1000'.toVND(),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.blue))),
                                  DataCell(Text('1000'.toVND(),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.blue))),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('1',
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text('1',
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text('1',
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text('1000'.toVND(),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.blue))),
                                  DataCell(Text('1000'.toVND(),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.blue))),
                                ])
                              ],
                            )),
                        SizedBox(height: 30),
                        Flex(
                          mainAxisAlignment: MainAxisAlignment.end,
                          direction: Axis.horizontal,
                          children: [
                            Text("Tổng tiền đơn hàng: ",
                                style: TextStyle(fontSize: 12)),
                            Text("800000".toVND(),
                                style: TextStyle(fontSize: 12))
                          ],
                        ),
                        SizedBox(height: 20),
                        Flex(
                          mainAxisAlignment: MainAxisAlignment.end,
                          direction: Axis.horizontal,
                          children: [
                            Text("Tổng tiền thanh toán: ",
                                style: TextStyle(fontSize: 13)),
                            Text("800000".toVND(),
                                style: TextStyle(fontSize: 13))
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () {},
                          icon: Icon(Icons.done),
                          label: Text("Tạo đơn hàng")),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () {},
                          icon: Icon(Icons.close),
                          label: Text("Hủy"))
                    ],
                  )
                ],
              ))),
    );
  }
}
