import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/classes/soldOrdered/soldImage.dart';
import 'package:mainguyen/models/guest/guestModel.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';
import 'package:selection_menu/selection_menu.dart';

import '../classes/guest/guestOrderModelClass.dart';
import '../models/soldOrdered/soldOrdered.dart';

class GuestSoldWidget extends StatefulWidget {
  GuestSoldWidget({super.key, required this.guestInfo});
  GuestModel guestInfo;

  @override
  State<GuestSoldWidget> createState() => _GuestSoldWidgetState();
}

class _GuestSoldWidgetState extends State<GuestSoldWidget> {
  List<SoldOrderedModel> _soldOrdered = [];
  List<SoldOrderImage> _listSoldImage = [];
  GuestOrderModelClass _guestEdit =
      GuestOrderModelClass(guestID: "", type: GuestTypeEnum.guestNormal);
  final ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    _guestEdit.guestID = widget.guestInfo.guestID;
    _guestEdit.avatar = widget.guestInfo.avatar;
    _guestEdit.guestName = widget.guestInfo.guestName;
    _guestEdit.phoneNumber = widget.guestInfo.guestPhoneNumber;
    _guestEdit.address = widget.guestInfo.guestAddress;
    _guestEdit.type = widget.guestInfo.guestType;

    super.initState();
    _openBox();
  }

  int getSelect() {
    int result = 0;
    List<String> _listString = ['Vãng lai', 'Thân thiết', 'VIP'];
    switch (_guestEdit.type) {
      case GuestTypeEnum.dearCustomer:
        result = 1;
        break;

      case GuestTypeEnum.guestNormal:
        result = 0;
        break;

      case GuestTypeEnum.vip:
        result = 2;
        break;
    }

    return result;
  }

  Future _openBox() async {
    Box box = await Hive.openBox('soldOrdered');
    // _soldOrderedBox.clear();
    for (var i = 0; i < box.length; i++) {
      _soldOrdered.add(box.getAt(i));
    }
    for (var i = 0; i < _soldOrdered.length; i++) {
      if (_soldOrdered[i].idGuestOrder == widget.guestInfo.guestID) {
        // _soldImage.image = _soldOrdered[i].image;
        _listSoldImage.add(SoldOrderImage(image: _soldOrdered[i].image));
      }
      // _soldOrdered.add(box.getAt(i));
    }

    setState(() {});
    return;
  }

  Divider getDivider() {
    return const Divider(
      height: 30,
      thickness: 1,
      indent: 10,
      endIndent: 0,
      color: Color.fromARGB(255, 175, 170, 170),
    );
  }

  renderTextField(
      String label, bool typeNumber, Function onSubmit, String value) {
    final TextEditingController _textEditingController =
        TextEditingController();
    if (value != "") {
      _textEditingController.text = value;
    }
    return Column(
      children: [
        SizedBox(
            height: 80,
            child: InputDecorator(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(label),
              ),
              child: TextField(
                controller: _textEditingController,
                onChanged: (value) => {onSubmit(value)},
                keyboardType:
                    typeNumber ? TextInputType.phone : TextInputType.text,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ))
      ],
    );
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    image = img;

    return (await image?.readAsBytes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyWidget(
            bodyWidget: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.end,
                  direction: Axis.horizontal,
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text(
                                      "Chỉnh sửa",
                                      textAlign: TextAlign.center,
                                    ),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    content: Builder(
                                      builder: (context) {
                                        // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                        var height =
                                            MediaQuery.of(context).size.height;
                                        var width =
                                            MediaQuery.of(context).size.width;
                                        return SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Container(
                                              // height: height - 200,
                                              width: width - 10,
                                              child: Column(
                                                children: [
                                                  _guestEdit.avatar != null
                                                      ? InkWell(
                                                          onTap: () async {
                                                            _guestEdit.avatar =
                                                                await getImage(
                                                                    ImageSource
                                                                        .gallery);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            height: 150,
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: MemoryImage(
                                                                        _guestEdit
                                                                            .avatar!))),
                                                          ))
                                                      : InkWell(
                                                          onTap: () async {
                                                            _guestEdit.avatar =
                                                                await getImage(
                                                                    ImageSource
                                                                        .gallery);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            height: 150,
                                                            decoration: const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        'assets/appIcons/user.png'))),
                                                          ),
                                                        ),
                                                  SizedBox(height: 20),
                                                  renderTextField(
                                                      "Tên khách hàng",
                                                      true,
                                                      (value) => {
                                                            _guestEdit
                                                                    .guestName =
                                                                value
                                                            // productEdit.price =
                                                            //     int.parse(
                                                            //         value),
                                                          },
                                                      _guestEdit.guestName ??
                                                          ""),
                                                  SizedBox(height: 20),
                                                  renderTextField(
                                                      "Số Điện Thoại",
                                                      true,
                                                      (value) => {
                                                            _guestEdit
                                                                    .phoneNumber =
                                                                value
                                                            // productEdit.amount =
                                                            //     double.parse(
                                                            //         value)
                                                          },
                                                      _guestEdit.phoneNumber ??
                                                          ""),
                                                  SizedBox(height: 20),
                                                  renderTextField(
                                                      "Địa chỉ",
                                                      false,
                                                      (value) => {
                                                            _guestEdit.address =
                                                                value
                                                            // productEdit
                                                            //         .location =
                                                          },
                                                      _guestEdit.address ?? ""),
                                                  SizedBox(height: 20),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child:
                                                        SelectionMenu<String>(
                                                      itemsList: <String>[
                                                        'Vãng lai',
                                                        'Thân thiết',
                                                        'VIP'
                                                      ],
                                                      onItemSelected: (String
                                                          selectedItem) {
                                                        switch (selectedItem) {
                                                          case "Vãng lai":
                                                            {
                                                              _guestEdit.type =
                                                                  GuestTypeEnum
                                                                      .guestNormal;
                                                              // _guestOrder.type =
                                                              //     GuestTypeEnum
                                                              //         .guestNormal;

                                                              // product.type = ProductEnum.kg;
                                                              break;
                                                            }
                                                          case "Thân thiết":
                                                            {
                                                              _guestEdit.type =
                                                                  GuestTypeEnum
                                                                      .dearCustomer;
                                                              // _guestOrder.type =
                                                              //     GuestTypeEnum
                                                              //         .dearCustomer;

                                                              // product.type = ProductEnum.tree;
                                                              break;
                                                            }
                                                          case "VIP":
                                                            {
                                                              _guestEdit.type =
                                                                  GuestTypeEnum
                                                                      .vip;
                                                              // _guestOrder.type =
                                                              //     GuestTypeEnum
                                                              //         .vip;

                                                              // product.type = ProductEnum.bag;
                                                              break;
                                                            }
                                                        }
                                                        setState(() {});
                                                      },
                                                      itemBuilder:
                                                          itemBuildSelection,
                                                      showSelectedItemAsTrigger:
                                                          true,
                                                      initiallySelectedItemIndex:
                                                          getSelect(),
                                                      closeMenuInsteadOfPop:
                                                          true,
                                                      closeMenuOnEmptyMenuSpaceTap:
                                                          false,
                                                      closeMenuWhenTappedOutside:
                                                          true,
                                                      closeMenuOnItemSelected:
                                                          true,
                                                      allowMenuToCloseBeforeOpenCompletes:
                                                          true,
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton.icon(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors
                                                              .green, // background
                                                          onPrimary: Colors
                                                              .white, // foreground
                                                        ),
                                                        // onPressed: () async {
                                                        //   handleSubmit();
                                                        // },
                                                        onPressed: () async {
                                                          Box box = await Hive
                                                              .openBox('guest');
                                                          for (var i = 0;
                                                              i < box.length;
                                                              i++) {
                                                            GuestModel guest =
                                                                box.getAt(i);
                                                            if (_guestEdit
                                                                    .guestID ==
                                                                guest.guestID) {
                                                              guest.guestName =
                                                                  _guestEdit
                                                                      .guestName!;
                                                              guest.guestAddress =
                                                                  _guestEdit
                                                                      .address!;
                                                              guest.guestPhoneNumber =
                                                                  _guestEdit
                                                                      .phoneNumber!;
                                                              guest.guestType =
                                                                  _guestEdit
                                                                      .type;
                                                              guest.avatar =
                                                                  _guestEdit
                                                                      .avatar;

                                                              setState(() {
                                                                widget.guestInfo =
                                                                    guest;
                                                              });
                                                            }
                                                          }

                                                          // product.amount =
                                                          //     productEdit
                                                          //         .amount!,
                                                          // product.price =
                                                          //     productEdit
                                                          //         .price!,
                                                          // product.location =
                                                          //     productEdit
                                                          //         .location!,
                                                          // await _openBox(),
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Đã chỉnh sửa ",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                              timeInSecForIosWeb:
                                                                  10,
                                                              backgroundColor:
                                                                  Colors.red,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                          Icons.done,
                                                          size: 24.0,
                                                        ),
                                                        label: Text(
                                                            'Hoàn thành'), // <-- Text
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      ElevatedButton.icon(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors
                                                              .red, // background
                                                          onPrimary: Colors
                                                              .white, // foreground
                                                        ),
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                          Icons.close,
                                                          size: 24.0,
                                                        ),

                                                        label: Text(
                                                            'Hủy'), // <-- Text
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )),
                                        );
                                      },
                                    ),
                                  ));
                        },
                        icon: Icon(Icons.edit, color: Colors.blue))
                  ],
                ),
              ),
              _guestEdit.avatar != null
                  ? Container(
                      height: 150,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(_guestEdit.avatar!))),
                    )
                  : Text(""),
              renderRow(
                  title: "Tên khách hàng",
                  content: widget.guestInfo.guestName,
                  type: widget.guestInfo.guestType),
              renderRow(
                  title: "Số điện thoại",
                  content: widget.guestInfo.guestPhoneNumber,
                  action: true),
              renderRow(
                  title: "Địa chỉ",
                  content: widget.guestInfo.guestAddress ?? ""),
              renderRow(
                  title: "Số lần mua hàng",
                  content: "(${_listSoldImage.length.toString()})"),
              getDivider(),
              ..._listSoldImage
                  .map((e) => Column(
                        children: [
                          SizedBox(height: 20),
                          Image(image: MemoryImage(e.image!)),
                          SizedBox(height: 20),
                        ],
                      ))
                  .toList()
                  .reversed,
            ],
          ),
        )),
        appBar: CustomAppBar(
            backButton: true,
            title: TitleAppbarWidget(content: "Thông tin khách hàng"),
            widgetActions: []));
  }
}

class renderRow extends StatelessWidget {
  renderRow({
    required this.title,
    required this.content,
    this.action,
    this.type,
    this.color,
    super.key,
  });
  String content;
  String title;
  GuestTypeEnum? type;
  bool? action;
  Color? color;
  renderType(GuestTypeEnum type) {
    switch (type) {
      case GuestTypeEnum.dearCustomer:
        return "Thân thiết";

      case GuestTypeEnum.guestNormal:
        return "Vãng lai";

      case GuestTypeEnum.vip:
        return "VIP";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${title}:", style: Theme.of(context).textTheme.bodyMedium!),
          SizedBox(width: 10),
          Text(" ${content}",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: color)),
          SizedBox(width: 10),
          type != null
              ? Container(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 15, right: 15),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(renderType(type!),
                      style: TextStyle(color: Colors.white)))
              : (Text("")),
          action != null
              ? IconButton(
                  onPressed: () async {
                    await FlutterPhoneDirectCaller.callNumber(content);
                  },
                  icon: Icon(Icons.phone, color: Colors.blue))
              : Text("")
        ],
      ),
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
