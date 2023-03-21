import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/dialogs/dialogs.dart';
import 'package:mainguyen/models/guest/guestModel.dart';
import 'package:mainguyen/pages/createGuest.dart';
import 'package:mainguyen/pages/guestSold.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/emptyWidget.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({super.key});

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  late Box _guestBox;
  List<GuestModel> _guestList = [];

  Future _openBox() async {
    _guestBox = await Hive.openBox('guest');
    // _soldOrderedBox.clear();
    _guestList = [];
    for (var i = 0; i < _guestBox.length; i++) {
      _guestList.add(_guestBox.getAt(i));
    }
    setState(() {});
    return;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _openBox();
  }

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
    return Scaffold(
        body: BodyWidget(
          bodyWidget: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: _guestList.isNotEmpty
                ? Column(
                    children: [
                      for (var i = _guestList.length - 1; i >= 0; i--) ...[
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          child: ListTile(
                            onTap: () async => {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GuestSoldWidget(
                                          guestInfo: _guestList[i],
                                        )),
                              ),
                              await _openBox(),
                            },
                            onLongPress: () => {
                              getDeleteDialog(context,
                                  () => {_guestBox.deleteAt(i), _openBox()})
                            },
                            leading: _guestList[i].avatar != null
                                ? CircleAvatar(
                                    radius: 30,
                                    onBackgroundImageError:
                                        (exception, stackTrace) {},
                                    backgroundImage:
                                        MemoryImage(_guestList[i].avatar!))
                                : null,
                            title: Text("Tên: ${_guestList[i].guestName}"),
                            subtitle:
                                Text("SĐT: ${_guestList[i].guestPhoneNumber}"),
                            trailing: Container(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 15, right: 15),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(renderType(_guestList[i].guestType),
                                    style: TextStyle(color: Colors.white))),
                          ),
                        ))
                      ],
                      SizedBox(height: 20),
                      FloatingActionButton(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.add,
                        ),
                        onPressed: () async => {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CreateGuest()),
                          ),
                          await _openBox(),
                        },
                      ),
                    ],
                  )
                : Column(
                    children: [
                      ImageEmpty(title: "Hiện chưa có khách hàng nào"),
                      FloatingActionButton(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.add,
                        ),
                        onPressed: () async => {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CreateGuest()),
                          ),
                          await _openBox(),
                        },
                      ),
                    ],
                  ),
          ),
        ),
        appBar: CustomAppBar(
          backButton: true,
          title: TitleAppbarWidget(content: "Khách hàng"),
          // Text(
          //   "Khách hàng",
          //   style: TextStyle(
          //     fontSize: TextSize().getLabelTextSize(),
          //   ),
          // ),
          widgetActions: [],
        ));
  }
}
