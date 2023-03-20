import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/classes/soldOrdered/soldImage.dart';
import 'package:mainguyen/models/guest/guestModel.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _openBox();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyWidget(
            bodyWidget: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              renderRow(
                  title: "Tên khách hàng",
                  content: widget.guestInfo.guestName,
                  type: widget.guestInfo.guestType),
              renderRow(
                  title: "Số điện thoại",
                  content: widget.guestInfo.guestPhoneNumber),
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
    this.type,
    this.color,
    super.key,
  });
  String content;
  String title;
  GuestTypeEnum? type;
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
              : (Text(""))
        ],
      ),
    );
  }
}
