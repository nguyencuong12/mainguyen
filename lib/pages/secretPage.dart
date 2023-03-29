import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/models/secret/secret.dart';
import 'package:mainguyen/pages/emails.dart';
import 'package:mainguyen/pages/facebooks.dart';
import 'package:mainguyen/pages/zalo.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';

import '../utils/screenSize.dart';

class SecretPage extends StatefulWidget {
  SecretPage({
    required this.secretModel,
    super.key,
  });

  SecretModel secretModel;

  @override
  State<SecretPage> createState() => _SecretPageState();
}

class _SecretPageState extends State<SecretPage> {
  late SecretModel secret = widget.secretModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> openBox() async {
    Box box = await Hive.openBox('secret');
    secret = await box.getAt(0);
    setState(() {});
    return;
  }

  Future<void> reAddBox() async {
    Box test = await Hive.openBox('secret');
    await test.deleteAt(0);
    await test.add(secret);
    await openBox();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyWidget(
          bodyWidget: SizedBox(
              height: screenSizeWithoutContext.height,
              width: screenSizeWithoutContext.width,
              child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: (1 / .4),
                  ),
                  children: [
                    Card(
                        child: ListTile(
                      onTap: () {
                        UtilsWidgetClass()
                            .navigateScreen(context, const FacebookPage());
                      },
                      leading: Image(
                        image: const AssetImage(
                          "assets/appIcons/facebook.png",
                        ),
                        height: screenSizeWithoutContext.height / 50,
                      ),
                      subtitle: const Text("Quản lý:",
                          style: TextStyle(fontSize: 12)),
                      title: Text("Facebook", style: TextStyle(fontSize: 12)),
                    )),
                    Card(
                        child: ListTile(
                      onTap: () {
                        UtilsWidgetClass()
                            .navigateScreen(context, const ZaloPage());
                      },
                      leading: Image(
                        image: const AssetImage(
                          "assets/appIcons/zalo.jpg",
                        ),
                        height: screenSizeWithoutContext.height / 50,
                      ),
                      subtitle: const Text("Quản lý:",
                          style: TextStyle(fontSize: 12)),
                      title: Text("Zalo", style: TextStyle(fontSize: 12)),
                    )),
                    Card(
                        child: ListTile(
                      onTap: () {
                        UtilsWidgetClass()
                            .navigateScreen(context, const EmailPage());
                      },
                      leading: Image(
                        image: const AssetImage(
                          "assets/appIcons/gmail.png",
                        ),
                        height: screenSizeWithoutContext.height / 50,
                      ),
                      subtitle: const Text("Quản lý:",
                          style: TextStyle(fontSize: 12)),
                      title: Text("Email", style: TextStyle(fontSize: 12)),
                    ))
                  ]))),
      appBar: CustomAppBar(
          backButton: true,
          title: TitleAppbarWidget(content: "Riêng tư"),
          widgetActions: [
            IconButton(
                onPressed: () async {
                  final _formKey = GlobalKey<FormState>();

                  TextEditingController _oldPassword = TextEditingController();
                  TextEditingController _newPassword = TextEditingController();

                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("Đổi mật khẩu"),
                          content: Container(
                            height: 300,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Form(
                                key: _formKey,
                                child: Column(children: [
                                  SizedBox(
                                      height: 80,
                                      child: InputDecorator(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Mật khẩu cũ"),
                                        ),
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Vui lòng nhập mật khẩu cũ';
                                            }
                                            return null;
                                          },
                                          controller: _oldPassword,
                                          onChanged: (value) => {},
                                          decoration: const InputDecoration(
                                              border: InputBorder.none),
                                        ),
                                      )),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                      height: 80,
                                      child: InputDecorator(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Mật khẩu mới"),
                                        ),
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Vui lòng nhập mật khẩu mới';
                                            }
                                            return null;
                                          },
                                          controller: _newPassword,
                                          onChanged: (value) => {},
                                          decoration: const InputDecoration(
                                              border: InputBorder.none),
                                        ),
                                      )),
                                  const SizedBox(height: 20),
                                  UtilsWidgetClass().renderGroupActionsButton(
                                      context, () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (secret.password ==
                                          _oldPassword.text) {
                                        secret.password = _newPassword.text;
                                        UtilsWidgetClass().callToast(
                                            "Đổi mật khẩu thành công",
                                            ToastGravity.CENTER);
                                        await reAddBox();
                                        Navigator.pop(context);
                                      } else {
                                        UtilsWidgetClass().callToast(
                                            "Sai mật khẩu",
                                            ToastGravity.CENTER);
                                      }
                                    }

                                    // secretModel.facebooks[i].password =
                                    //     _textUserPassword.text;
                                    // secretModel.facebooks[i].username =
                                    //     _textUserName.text;

                                    // await reAddBox();
                                  })
                                ]),
                              ),
                            ),
                          ),
                        );
                      });

                  // Box box = await Hive.openBox('secret');
                  // box.clear();
                },
                icon: const Icon(color: Colors.black, Icons.lock_outlined))
          ]),
    );
  }
}
