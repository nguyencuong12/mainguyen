import 'package:flutter/material.dart';
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
                          child: AutocompleteFieldGuestSell(
                              callbackSelect: (GuestModel guest) async {
                            await UtilsWidgetClass().navigateScreen(
                                context, GuestSoldWidget(guestInfo: guest));
                            await _openBox();

                            // setState(() {});
                            // _guestOrder = GuestOrder(
                            //     id: guest.guestID,
                            //     guestName: guest.guestName,
                            //     phoneNumber: guest.guestPhoneNumber,
                            //     address: guest.guestAddress);
                          }, callbackSubmit: (String value) {
                            // setState(() {});
                            // _guestOrder.guestName = value;
                          })),
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
                                : null,
                            title: RenderRichText(
                                content: "Tên: ${_guestList[i].guestName}",
                                maxLine: 1),
                            subtitle:
                                Text("SĐT: ${_guestList[i].guestPhoneNumber}"),
                            trailing: Container(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 15, right: 15),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                    UtilsWidgetClass().renderTypeForGuest(
                                        _guestList[i].guestType),
                                    style: TextStyle(color: Colors.white))),
                          ),
                        ))
                      ],
                      const SizedBox(height: 20),
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
          widgetActions: [],
        ));
  }
}

class AutocompleteFieldGuestSell extends StatefulWidget {
  AutocompleteFieldGuestSell(
      {super.key, required this.callbackSelect, required this.callbackSubmit});
  final void Function(GuestModel) callbackSelect;
  final void Function(String) callbackSubmit;

  @override
  _AutocompleteFieldGuestSellState createState() =>
      _AutocompleteFieldGuestSellState();
}

class _AutocompleteFieldGuestSellState
    extends State<AutocompleteFieldGuestSell> {
  List<GuestModel> options = [];
  late Box _guestBox;

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String label = "Tìm khách hàng ";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _openGuestModel();
  }

  Future _openGuestModel() async {
    _guestBox = await Hive.openBox('guest');
    for (var i = 0; i < _guestBox.length; i++) {
      options.add(_guestBox.getAt(i));
    }
    setState(() {});
    return;
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
    return Container(
        height: 80,
        child: InputDecorator(
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(label),
                filled: true,
                fillColor: Colors.white,
                prefix: const Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            child: RawAutocomplete<GuestModel>(
              focusNode: _focusNode,
              textEditingController: _textEditingController,
              optionsBuilder: (TextEditingValue textEditingValue) {
                return options.where((GuestModel guest) {
                  return guest.guestName
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextFormField(
                  // initialValue: valueAdd,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên người mua hàng';
                    }
                    return null;
                  },
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(border: InputBorder.none),

                  onChanged: (String value) {
                    widget.callbackSubmit(value);
                  },
                );
              },
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<GuestModel> onSelected,
                  Iterable<GuestModel> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: Container(
                      height: 200.0,
                      width: screenSizeWithoutContext.width / 3.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final GuestModel guest = options.elementAt(index);
                          return GestureDetector(
                              onTap: () {
                                // onSelected(option);
                                _textEditingController.text = guest.guestName;
                                widget.callbackSelect(guest);
                                UtilsFunction().closeKeyboard();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  child: ListTile(
                                    trailing: Container(
                                        clipBehavior: Clip.none,
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            left: 15,
                                            right: 15),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Text(renderType(guest.guestType),
                                            style: TextStyle(
                                                color: Colors.white))),
                                    // subtitle: Text("Vị trí: ",
                                    //     style: const TextStyle(fontSize: 12)),
                                    leading: guest.avatar != null
                                        ? Image(
                                            height: 50,
                                            image: MemoryImage(guest.avatar!))
                                        : null,
                                    title: Text(
                                      "Khách hàng: ${guest.guestName}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              )

                              // ListTile(
                              //   title: Text(option.productName),
                              // ),
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
