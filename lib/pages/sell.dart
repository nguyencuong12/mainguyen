import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/pages/bill.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/sizeAppbarButton.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';

class SaleProducts extends StatefulWidget {
  const SaleProducts({super.key});

  @override
  State<SaleProducts> createState() => _SaleProductsState();
}

class _SaleProductsState extends State<SaleProducts> {
  @override
  static const List<String> _options = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];
  static const List<String> _options2 = <String>[
    'aardvark 123',
    'bobcat 44',
    'chameleon zz',
  ];
  SizedBox renderTextField(String label, bool typeNumber) {
    return SizedBox(
        height: 80,
        child: InputDecorator(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(label),
          ),
          child: TextField(
            keyboardType: typeNumber ? TextInputType.phone : TextInputType.text,
            decoration: InputDecoration(border: InputBorder.none),
          ),
        ));
  }

  DataRow renderDataRow() {
    return DataRow(cells: [
      DataCell(Text("1", style: TextStyle(fontSize: 10))),
      DataCell(Text('1', style: TextStyle(fontSize: 10))),
      DataCell(Flex(
        direction: Axis.horizontal,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 8,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.remove,
                size: 10,
              ),
              color: Colors.white,
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 3),
          const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 14,
              child: Text("0", style: TextStyle(fontSize: 10))),
          const SizedBox(width: 3),
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 8,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.add,
                size: 10,
              ),
              color: Colors.white,
              onPressed: () {},
            ),
          ),
        ],
      )),
      DataCell(Text('1000'.toVND(),
          style: const TextStyle(fontSize: 10, color: Colors.blue))),
      DataCell(Text('1000'.toVND(),
          style: const TextStyle(fontSize: 10, color: Colors.blue))),
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            backButton: true,
            title: Text("Tạo hóa đơn bán hàng",
                style: TextStyle(fontSize: TextSize().getLabelTextSize())),
            widgetActions: []),
        body: BodyWidget(
            bodyWidget: Container(
                width: screenSizeWithoutContext.width,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: AutocompleteField(
                          options: _options,
                          label: "Nhập hàng cần bán",
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: AutocompleteField(
                            options: _options2, label: "Nhập người mua")),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: renderTextField("SDT người mua", true)),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: renderTextField("Địa chỉ giao hàng", false)),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          horizontalMargin: 10,
                          columns: const [
                            DataColumn(
                                label:
                                    Text("Ảnh", style: TextStyle(fontSize: 9))),
                            DataColumn(
                                label:
                                    Text("Mục", style: TextStyle(fontSize: 9))),
                            DataColumn(
                                label: Text("Số lượng",
                                    style: TextStyle(fontSize: 9))),
                            DataColumn(
                                label:
                                    Text("Giá", style: TextStyle(fontSize: 9))),
                            DataColumn(
                                label: Text("Thành tiền",
                                    style: TextStyle(fontSize: 9))),
                          ],
                          rows: [
                            renderDataRow(),
                            renderDataRow(),
                            renderDataRow()
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const BillPage()),
                                  );
                                },
                                icon: Icon(Icons.next_plan),
                                label: Text("Tiếp tục")),
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
                        )),
                  ],
                ))));
  }
}

class AutocompleteField extends StatelessWidget {
  AutocompleteField(
      {super.key, required List<String> options, required this.label})
      : _options = options;

  final List<String> _options;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: InputDecorator(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(label),
            ),
            child: RawAutocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return _options.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(border: InputBorder.none),
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                );
              },
              onSelected: (option) => {},
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: SizedBox(
                      height: 200.0,
                      width: 350,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                              UtilsFunction().closeKeyboard();
                            },
                            child: ListTile(
                              title: Text(option),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            )));
  }
}
