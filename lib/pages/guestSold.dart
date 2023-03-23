import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/classes/soldOrdered/soldImage.dart';
import 'package:mainguyen/models/guest/guestModel.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/photoView.dart';
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
  final List<SoldOrderedModel> _soldOrdered = [];
  final List<SoldOrderImage> _listSoldImage = [];
  final GuestOrderModelClass _guestEdit =
      GuestOrderModelClass(guestID: "", type: GuestTypeEnum.guestNormal);

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
    for (var i = 0; i < box.length; i++) {
      _soldOrdered.add(box.getAt(i));
    }
    for (var i = 0; i < _soldOrdered.length; i++) {
      if (_soldOrdered[i].idGuestOrder == widget.guestInfo.guestID) {
        // _soldImage.image = _soldOrdered[i].image;
        _listSoldImage.add(SoldOrderImage(image: _soldOrdered[i].image));
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyWidget(
            bodyWidget: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.end,
                  direction: Axis.horizontal,
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: const Text(
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
                                          child: SizedBox(
                                              // height: height - 200,
                                              width: width - 10,
                                              child: Column(
                                                children: [
                                                  _guestEdit.avatar != null
                                                      ? UtilsWidgetClass()
                                                          .renderImageWithChooseFunc(
                                                              _guestEdit
                                                                  .avatar!,
                                                              () async => {
                                                                    await UtilsWidgetClass()
                                                                        .chooseImage(
                                                                            ImageSource.gallery),
                                                                    setState(
                                                                        () {})
                                                                  },
                                                              90)
                                                      : InkWell(
                                                          onTap: () async {
                                                            _guestEdit.avatar =
                                                                await UtilsWidgetClass()
                                                                    .chooseImage(
                                                                        ImageSource
                                                                            .gallery);
                                                            setState(() {});
                                                          },
                                                          child: CircleAvatar(
                                                              radius: 100,
                                                              onBackgroundImageError:
                                                                  (exception,
                                                                      stackTrace) {},
                                                              backgroundImage:
                                                                  const AssetImage(
                                                                      "assets/appIcons/user.png")),
                                                        ),
                                                  SizedBox(height: 10),
                                                  RenderTextFormField(
                                                      label: "Tên khách hàng",
                                                      numberType: true,
                                                      onSubmit: (value) => {
                                                            _guestEdit
                                                                    .guestName =
                                                                value,
                                                          },
                                                      initValue: _guestEdit
                                                              .guestName ??
                                                          ""),
                                                  RenderTextFormField(
                                                      label: "Số Điện Thoại",
                                                      numberType: true,
                                                      onSubmit: (value) => {
                                                            _guestEdit
                                                                    .phoneNumber =
                                                                value,
                                                          },
                                                      initValue: _guestEdit
                                                              .phoneNumber ??
                                                          ""),
                                                  RenderTextFormField(
                                                      label: "Địa chỉ",
                                                      numberType: true,
                                                      onSubmit: (value) => {
                                                            _guestEdit.address =
                                                                value,
                                                          },
                                                      initValue:
                                                          _guestEdit.address ??
                                                              ""),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child:
                                                        SelectionMenu<String>(
                                                      itemsList: const <String>[
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

                                                              break;
                                                            }
                                                          case "Thân thiết":
                                                            {
                                                              _guestEdit.type =
                                                                  GuestTypeEnum
                                                                      .dearCustomer;

                                                              break;
                                                            }
                                                          case "VIP":
                                                            {
                                                              _guestEdit.type =
                                                                  GuestTypeEnum
                                                                      .vip;
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
                                                  const SizedBox(height: 20),
                                                  UtilsWidgetClass()
                                                      .renderGroupActionsButton(
                                                          context, () async {
                                                    Box box =
                                                        await Hive.openBox(
                                                            'guest');
                                                    for (var i = 0;
                                                        i < box.length;
                                                        i++) {
                                                      GuestModel guest =
                                                          box.getAt(i);
                                                      if (_guestEdit.guestID ==
                                                          guest.guestID) {
                                                        guest.guestName =
                                                            _guestEdit
                                                                .guestName!;
                                                        guest.guestAddress =
                                                            _guestEdit.address!;
                                                        guest.guestPhoneNumber =
                                                            _guestEdit
                                                                .phoneNumber!;
                                                        guest.guestType =
                                                            _guestEdit.type;
                                                        guest.avatar =
                                                            _guestEdit.avatar;
                                                        setState(() {
                                                          widget.guestInfo =
                                                              guest;
                                                        });
                                                      }
                                                    }
                                                    Navigator.pop(context);
                                                    UtilsWidgetClass()
                                                        .callToast(
                                                            "Đã chỉnh sửa",
                                                            ToastGravity
                                                                .BOTTOM);
                                                  }),
                                                ],
                                              )),
                                        );
                                      },
                                    ),
                                  ));
                        },
                        icon: const Icon(Icons.edit, color: Colors.blue))
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _guestEdit.avatar != null
                  ? UtilsWidgetClass().renderImageWithChooseFunc(
                      _guestEdit.avatar!,
                      () async => {
                            await UtilsWidgetClass().navigateScreen(context,
                                PhotoViewWidget(image: _guestEdit.avatar!))
                          },
                      100)
                  : CircleAvatar(
                      radius: 100,
                      onBackgroundImageError: (exception, stackTrace) {},
                      backgroundImage:
                          const AssetImage("assets/appIcons/user.png")),
              const SizedBox(height: 20),
              Container(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 15, right: 15),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                      UtilsWidgetClass()
                          .renderTypeForGuest(widget.guestInfo.guestType),
                      style: TextStyle(color: Colors.white))),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text("${title}:", style: Theme.of(context).textTheme.bodyMedium!),
          SizedBox(width: 10),
          RenderRichText(content: content, maxLine: 2),
          SizedBox(width: 10),
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
