import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/classes/guest/guestOrderModelClass.dart';
import 'package:mainguyen/models/guest/guestModel.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:uuid/uuid.dart';

class CreateGuest extends StatefulWidget {
  const CreateGuest({super.key});

  @override
  State<CreateGuest> createState() => _CreateGuestState();
}

class _CreateGuestState extends State<CreateGuest> {
  XFile? image;
  final ImagePicker picker = ImagePicker();

  final GuestOrderModelClass _guestOrder = GuestOrderModelClass(
      orderedId: Uuid().v4(), type: GuestTypeEnum.guestNormal);
  final _formKey = GlobalKey<FormState>();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    _guestOrder.avatar = await img!.readAsBytes();
    setState(() {
      image = img;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  SizedBox renderTextField(String label, bool typeNumber, Function callback) {
    return SizedBox(
        height: 80,
        child: InputDecorator(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(label),
          ),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập $label';
              }
              return null;
            },
            onChanged: (value) => {callback(value)},
            keyboardType: typeNumber ? TextInputType.phone : TextInputType.text,
            decoration: InputDecoration(border: InputBorder.none),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          backButton: true,
          title: Text("Thêm khách hàng",
              style: TextStyle(fontSize: TextSize().getLabelTextSize())),
          widgetActions: []),
      body: BodyWidget(
          bodyWidget: Container(
              width: screenSizeWithoutContext.width,
              child: Column(
                children: [
                  image != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage:
                                      MemoryImage(_guestOrder.avatar!))),
                        )
                      : InkWell(
                          onTap: () => {getImage(ImageSource.gallery)},
                          child: const CircleAvatar(
                            radius: 80,
                            backgroundImage:
                                AssetImage('assets/appIcons/user.png'),
                          ),
                        ),
                  const SizedBox(height: 15),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          renderTextField("Tên khách hàng", false,
                              (value) => {_guestOrder.guestName = value}),
                          const SizedBox(height: 15),
                          renderTextField("SDT", true,
                              (value) => {_guestOrder.phoneNumber = value}),
                          const SizedBox(height: 15),
                          renderTextField("Địa chỉ", false,
                              (value) => {_guestOrder.address = value}),
                          const SizedBox(height: 30),
                        ],
                      )),
                  SelectionMenu<String>(
                    itemsList: <String>['Vãng lai', 'Thân thiết', 'VIP'],
                    onItemSelected: (String selectedItem) {
                      switch (selectedItem) {
                        case "Vãng lai":
                          {
                            _guestOrder.type = GuestTypeEnum.guestNormal;

                            // product.type = ProductEnum.kg;
                            break;
                          }
                        case "Thân thiết":
                          {
                            _guestOrder.type = GuestTypeEnum.dearCustomer;

                            // product.type = ProductEnum.tree;
                            break;
                          }
                        case "VIP":
                          {
                            _guestOrder.type = GuestTypeEnum.vip;

                            // product.type = ProductEnum.bag;
                            break;
                          }
                      }
                      setState(() {});
                    },
                    itemBuilder: itemBuildSelection,
                    showSelectedItemAsTrigger: true,
                    initiallySelectedItemIndex: 0,
                    closeMenuInsteadOfPop: true,
                    closeMenuOnEmptyMenuSpaceTap: false,
                    closeMenuWhenTappedOutside: true,
                    closeMenuOnItemSelected: true,
                    allowMenuToCloseBeforeOpenCompletes: true,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var box = await Hive.openBox('guest');

                              box.add(GuestModel(
                                  guestName: _guestOrder.guestName!,
                                  guestPhoneNumber: _guestOrder.phoneNumber!,
                                  guestType: _guestOrder.type,
                                  orderedID: _guestOrder.orderedId,
                                  avatar: _guestOrder.avatar,
                                  guestAddress: _guestOrder.address));
                            }
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.next_plan),
                          label: Text("Hoàn thành")),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                          label: Text("Hủy"))
                    ],
                  )
                ],
              ))),
    );
  }
}

Widget itemBuildSelection(
    BuildContext context, String item, OnItemTapped onItemTapped) {
  Divider getDivider() {
    return const Divider(
      height: 30,
      thickness: 1,
      indent: 10,
      endIndent: 0,
      color: Color.fromARGB(255, 175, 170, 170),
    );
  }

  return Material(
    color: Colors.white,
    child: InkWell(
      onTap: onItemTapped,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ClipOval(
              child: Container(
                color: Color(0xff4db151),
                height: 30,
                width: 30,
              ),
            ),
            getDivider(),
            const Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "Phân loại khách hàng",
                  // style: textStyle,
                ),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0), color: Colors.red),
              child: Text("$item",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white)
                  // style: textStyle,
                  ),
            )
          ],
        ),
      ),
    ),
  );
}
