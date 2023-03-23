import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/dialogs/dialogs.dart';
import 'package:mainguyen/models/delivery/deliveryModel.dart';
import 'package:mainguyen/models/guest/guestModel.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';

class DeliveryWidget extends StatefulWidget {
  const DeliveryWidget({super.key});

  @override
  State<DeliveryWidget> createState() => _DeliveryWidgetState();
}

class CreateDelivery {
  String? phoneNumber;
  String? name;
  CreateDelivery({this.phoneNumber, this.name});
}

class _DeliveryWidgetState extends State<DeliveryWidget> {
  late Box _deliveryBox;
  late List<DeliveryModel> _deliveries = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future _openBox() async {
    _deliveryBox = await Hive.openBox('delivery');
    _deliveries = [];
    if (_deliveryBox.length <= 0) {
      _deliveryBox
          .add(DeliveryModel(phoneNumber: '0906891565', deliveryName: "Sang"));
      _deliveries
          .add(DeliveryModel(phoneNumber: '0906891565', deliveryName: "Sang"));
    } else {
      for (var i = 0; i < _deliveryBox.length; i++) {
        _deliveries.add(_deliveryBox.getAt(i));
      }
    }

    setState(() {});
    return;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyWidget(
            bodyWidget: SizedBox(
                height: screenSizeWithoutContext.height / 3,
                width: screenSizeWithoutContext.width,
                child: Column(
                  children: [
                    for (var i = 0; i < _deliveries.length; i++) ...[
                      InkWell(
                          onTap: () async => {},
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    const CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/appIcons/user.png'),
                                    ),
                                    SizedBox(width: 10),
                                    Text(_deliveries[i].deliveryName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.blue)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await FlutterPhoneDirectCaller
                                              .callNumber(
                                                  _deliveries[i].phoneNumber);
                                        },
                                        icon: const Icon(Icons.phone,
                                            color: Colors.blue)),
                                    IconButton(
                                        onPressed: () async {
                                          getDeleteDialog(
                                              context,
                                              () => {
                                                    _deliveryBox.deleteAt(i),
                                                    _openBox()
                                                  });
                                        },
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red))
                                  ],
                                )

                                //  IconButton(

                                //   Icons.phone, color: Colors.blue),
                              ],
                            ),
                          ))),
                    ],
                    Divider(height: 30),
                    Column(
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            CreateDelivery _deliveryCreate = CreateDelivery();
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    actions: [
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors
                                                        .green, // background
                                                    onPrimary: Colors
                                                        .white, // foreground
                                                  ),
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      _deliveryBox.add(DeliveryModel(
                                                          phoneNumber:
                                                              _deliveryCreate
                                                                  .phoneNumber!,
                                                          deliveryName:
                                                              _deliveryCreate
                                                                  .name!));
                                                      _deliveries.add(DeliveryModel(
                                                          phoneNumber:
                                                              _deliveryCreate
                                                                  .phoneNumber!,
                                                          deliveryName:
                                                              _deliveryCreate
                                                                  .name!));

                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  icon: Icon(Icons.next_plan),
                                                  label:
                                                      Text("Hoàn thành tạo")),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors
                                                        .red, // background
                                                    onPrimary: Colors
                                                        .white, // foreground
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: Icon(Icons.close),
                                                  label: Text("Hủy")),
                                            ],
                                          )),
                                    ],
                                    content: SizedBox(
                                      height:
                                          screenSizeWithoutContext.height / 7,
                                      width: screenSizeWithoutContext.width,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            Text("Tạo Thêm Người Vận Chuyển:",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6),
                                            SizedBox(height: 20),
                                            Form(
                                              key: _formKey,
                                              child: Column(children: [
                                                SizedBox(
                                                    height: 80,
                                                    child: InputDecorator(
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        label: Text("Tên"),
                                                      ),
                                                      child: TextFormField(
                                                        onChanged: (value) => {
                                                          _deliveryCreate.name =
                                                              value
                                                        },
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Vui lòng nhập tên người vận chuyển';
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none),
                                                      ),
                                                    )),
                                                const SizedBox(height: 30),
                                                SizedBox(
                                                    height: 80,
                                                    child: InputDecorator(
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        label: Text("SDT"),
                                                      ),
                                                      child: TextFormField(
                                                        onChanged: (value) => {
                                                          _deliveryCreate
                                                                  .phoneNumber =
                                                              value
                                                        },
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Vui lòng nhập SDT người vận chuyển';
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none),
                                                      ),
                                                    ))
                                              ]),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          elevation: 4.0,
                          fillColor: Colors.green,
                          padding: EdgeInsets.all(10.0),
                          shape: const CircleBorder(),
                          child: const Icon(
                            color: Colors.white,
                            Icons.add,
                            size: 25.0,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Tạo thêm người vận chuyển",
                            style: Theme.of(context).textTheme.bodyMedium!),
                      ],
                    )
                  ],
                ))),
        appBar: CustomAppBar(
            backButton: true,
            title: const TitleAppbarWidget(content: "Xe vận chuyển"),
            widgetActions: []));
  }
}
