import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/dialogs/dialogs.dart';
import 'package:mainguyen/models/guest/guestModel.dart';
import 'package:mainguyen/pages/createGuest.dart';
import 'package:mainguyen/pages/guestSold.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
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
    _guestList = [];
    for (var i = 0; i < _guestBox.length; i++) {
      _guestList.add(_guestBox.getAt(i));
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
          bodyWidget: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: _guestList.isNotEmpty
                ? Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          child: AutocompleteFieldGuest(
                            callbackSelect: (GuestModel guest) async {
                              await UtilsWidgetClass().navigateScreen(
                                  context, GuestSoldWidget(guestInfo: guest));
                              await _openBox();
                            },
                            callbackSubmit: (String value) {
                              // setState(() {});
                              // _guestOrder.guestName = value;
                            },
                            label: 'Tìm khách hàng',
                          )),
                      const SizedBox(height: 10),
                      for (var i = _guestList.length - 1; i >= 0; i--) ...[
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          child: ListTile(
                            onTap: () async => {
                              await UtilsWidgetClass().navigateScreen(
                                  context,
                                  GuestSoldWidget(
                                    guestInfo: _guestList[i],
                                  )),
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
                                : CircleAvatar(
                                    radius: 30,
                                    onBackgroundImageError:
                                        (exception, stackTrace) {},
                                    backgroundImage: const AssetImage(
                                        "assets/appIcons/user.png")),
                            title: RenderRichText(
                                content: "Tên: ${_guestList[i].guestName}",
                                maxLine: 1),
                            subtitle:
                                Text("SĐT: ${_guestList[i].guestPhoneNumber}"),
                            trailing: Container(
                                padding: const EdgeInsets.only(
                                    top: 6, bottom: 6, left: 10, right: 10),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                    UtilsWidgetClass().renderTypeForGuest(
                                        _guestList[i].guestType),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12))),
                          ),
                        ))
                      ],
                    ],
                  )
                : Column(
                    children: [
                      ImageEmpty(title: "Hiện chưa có khách hàng nào"),
                      FloatingActionButton(
                        backgroundColor: Colors.green,
                        child: const Icon(
                          Icons.add,
                        ),
                        onPressed: () async => {
                          await UtilsWidgetClass()
                              .navigateScreen(context, CreateGuest()),
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
          widgetActions: [
            IconButton(
                onPressed: () async {
                  await UtilsWidgetClass()
                      .navigateScreen(context, const CreateGuest());

                  await _openBox();
                },
                icon: const Icon(Icons.add, color: Colors.green))
          ],
        ));
  }
}
