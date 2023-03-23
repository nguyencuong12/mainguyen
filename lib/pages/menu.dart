// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/models/secret/secret.dart';
import 'package:mainguyen/pages/guests.dart';
import 'package:mainguyen/pages/ourOfStock.dart';
import 'package:mainguyen/pages/secretPage.dart';
import 'package:mainguyen/pages/soldOrdered.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  renderItem(String imageAsset, String title, Function onSubmit) {
    return Card(
        child: ListTile(
      onTap: () {
        onSubmit();
      },
      leading: Image(
        image: AssetImage(
          imageAsset,
        ),
        height: screenSizeWithoutContext.height / 60,
      ),
      subtitle: const Text("Quản lý:", style: TextStyle(fontSize: 12)),
      title: Text(title, style: TextStyle(fontSize: 12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            backButton: true,
            title: Text("Danh mục",
                style: TextStyle(fontSize: TextSize().getLabelTextSize())),
            widgetActions: []),
        body: BodyWidget(
            bodyWidget: SizedBox(
                height: screenSizeWithoutContext.height,
                width: screenSizeWithoutContext.width,
                child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (1 / .4),
                    ),
                    children: [
                      renderItem(
                          "assets/appIcons/package.png",
                          "Hàng hóa đã bán ",
                          () => {
                                UtilsWidgetClass()
                                    .navigateScreen(context, const SoldOrders())
                              }),
                      renderItem(
                          "assets/appIcons/user.png",
                          "Khách hàng ",
                          () => {
                                UtilsWidgetClass()
                                    .navigateScreen(context, const GuestPage())
                              }),
                      renderItem(
                          "assets/appIcons/out-of-stock.png",
                          "Hàng sắp hết ",
                          () => {
                                UtilsWidgetClass()
                                    .navigateScreen(context, const OurOfStock())
                              }),
                      renderItem("assets/appIcons/lock.png", "Secrets",
                          () async {
                        Box secretBox = await Hive.openBox('secret');
                        if (secretBox.length <= 0) {
                          TextEditingController _textEditingController =
                              TextEditingController();
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text("Tạo mật khẩu"),
                                  actions: [
                                    UtilsWidgetClass().renderGroupActionsButton(
                                        context, () async {
                                      if (_textEditingController.text != "") {
                                        secretBox.add(SecretModel(
                                            password:
                                                _textEditingController.text,
                                            emails: [],
                                            facebooks: [],
                                            zalos: []));
                                        UtilsWidgetClass().callToast(
                                            "Tạo mật khẩu thành công",
                                            ToastGravity.CENTER);
                                        Navigator.pop(context);
                                      } else {
                                        UtilsWidgetClass().callToast(
                                            "Vui lòng nhập mật khẩu",
                                            ToastGravity.CENTER);
                                      }
                                    }),
                                  ],
                                  content: SizedBox(
                                      height: 80,
                                      child: InputDecorator(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Mật khẩu"),
                                        ),
                                        child: TextFormField(
                                          controller: _textEditingController,
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none),
                                        ),
                                      )),
                                );
                              });
                        } else {
                          TextEditingController _textEditingController =
                              TextEditingController();

                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  actions: [
                                    UtilsWidgetClass().renderGroupActionsButton(
                                        context, () async {
                                      SecretModel _model = secretBox.getAt(0);
                                      if (_model.password ==
                                          _textEditingController.text) {
                                        Navigator.pop(context);
                                        UtilsWidgetClass().navigateScreen(
                                            context,
                                            SecretPage(
                                              secretModel: _model,
                                            ));
                                      } else {
                                        UtilsWidgetClass().callToast(
                                            "Sai mật khẩu",
                                            ToastGravity.CENTER);
                                      }
                                    }),
                                  ],
                                  content: SizedBox(
                                      height: 80,
                                      child: InputDecorator(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Mật khẩu"),
                                        ),
                                        child: TextFormField(
                                          controller: _textEditingController,
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          // controller: _textEditingController,
                                          // onChanged: (value) => {onSubmit(value)},
                                          // keyboardType:
                                          //     numberType ? TextInputType.phone : TextInputType.text,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none),
                                        ),
                                      )),
                                );
                              });
                          // UtilsWidgetClass()
                          //     .navigateScreen(context, const OurOfStock());
                        }
                      }),
                    ]))

            // Generate 100 widgets that display their index in the List.

            ));
  }
}
