import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/dialogs/dialogs.dart';
import 'package:mainguyen/models/secret/secret.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';

class FacebookPage extends StatefulWidget {
  const FacebookPage({super.key});

  @override
  State<FacebookPage> createState() => _FacebookPageState();
}

class _FacebookPageState extends State<FacebookPage> {
  late SecretModel secretModel =
      SecretModel(password: "xzx", facebooks: [], zalos: [], emails: []);
  Future<void> openBox() async {
    Box box = await Hive.openBox('secret');
    secretModel = await box.getAt(0);

    setState(() {});
    return;
  }

  Future<void> reAddBox() async {
    Box test = await Hive.openBox('secret');
    await test.deleteAt(0);
    await test.add(secretModel);
    await openBox();
    return;
  }

  @override
  void initState() {
    super.initState();
    openBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyWidget(
          bodyWidget: Column(
        children: [
          RawMaterialButton(
            elevation: 2.0,
            shape: const CircleBorder(),
            fillColor: Colors.green,
            onPressed: () async {
              final _formKey = GlobalKey<FormState>();
              TextEditingController _textUserName = TextEditingController();
              TextEditingController _textUserPassword = TextEditingController();
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                        title: Text("Tạo facebook"),
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
                                        label: Text("Tên đăng nhập"),
                                      ),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Vui lòng nhập tên đăng nhập';
                                          }
                                          return null;
                                        },
                                        controller: _textUserName,
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
                                        label: Text("Mật khẩu"),
                                      ),
                                      child: TextFormField(
                                        controller: _textUserPassword,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Vui lòng nhập mật khẩu';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) => {},
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                      ),
                                    )),
                                const SizedBox(height: 20),
                                UtilsWidgetClass().renderGroupActionsButton(
                                    context, () async {
                                  if (_formKey.currentState!.validate()) {
                                    secretModel.facebooks.add(FacebookSecret(
                                        password: _textUserPassword.text,
                                        username: _textUserName.text));
                                    Box test = await Hive.openBox('secret');
                                    await test.deleteAt(0);
                                    await test.add(secretModel);
                                    await openBox();
                                    Navigator.pop(context);
                                  }
                                })
                              ]),
                            ),
                          ),
                        ));
                  });
            },
            constraints: const BoxConstraints.tightFor(
              width: 35.0,
              height: 35.0,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 20.0,
            ),
          ),
          SizedBox(
              height: screenSizeWithoutContext.height,
              width: screenSizeWithoutContext.width,
              child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: (1 / .2),
                  ),
                  children: [
                    // Text(secretModel.password),
                    for (var i = secretModel.facebooks.length - 1;
                        i >= 0;
                        i--) ...[
                      Card(
                          child: ListTile(
                        trailing:
                            Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(
                                    text: secretModel.facebooks[i].password));
                              },
                              icon: const Icon(color: Colors.blue, Icons.copy)),
                          IconButton(
                              onPressed: () async {
                                getDeleteDialog(
                                    context,
                                    () async => {
                                          secretModel.facebooks.removeAt(i),
                                          await reAddBox()
                                        });
                              },
                              icon:
                                  const Icon(color: Colors.red, Icons.delete)),
                        ]),
                        onTap: () {
                          TextEditingController _textUserName =
                              TextEditingController()
                                ..text = secretModel.facebooks[i].username!;
                          TextEditingController _textUserPassword =
                              TextEditingController()
                                ..text = secretModel.facebooks[i].password!;

                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text("Sửa thông tin"),
                                  content: Container(
                                    height: 300,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(children: [
                                        SizedBox(
                                            height: 80,
                                            child: InputDecorator(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                label: Text("Tên đăng nhập"),
                                              ),
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Vui lòng nhập tên đăng nhập';
                                                  }
                                                  return null;
                                                },
                                                controller: _textUserName,
                                                onChanged: (value) => {},
                                                decoration:
                                                    const InputDecoration(
                                                        border:
                                                            InputBorder.none),
                                              ),
                                            )),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                            height: 80,
                                            child: InputDecorator(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                label: Text("Mật khẩu"),
                                              ),
                                              child: TextFormField(
                                                controller: _textUserPassword,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Vui lòng nhập mật khẩu';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) => {},
                                                decoration:
                                                    const InputDecoration(
                                                        border:
                                                            InputBorder.none),
                                              ),
                                            )),
                                        const SizedBox(height: 20),
                                        UtilsWidgetClass()
                                            .renderGroupActionsButton(context,
                                                () async {
                                          secretModel.facebooks[i].password =
                                              _textUserPassword.text;
                                          secretModel.facebooks[i].username =
                                              _textUserName.text;

                                          await reAddBox();
                                          Navigator.pop(context);
                                        })
                                      ]),
                                    ),
                                  ),
                                );
                              });
                        },
                        leading: Image(
                          image: const AssetImage(
                            "assets/appIcons/facebook.png",
                          ),
                          height: screenSizeWithoutContext.height / 50,
                        ),
                        subtitle: Text(
                            "Mật khẩu: ${secretModel.facebooks[i].password!}",
                            style: const TextStyle(fontSize: 12)),
                        title: Text(
                            "Tên đăng nhập: ${secretModel.facebooks[i].username!}",
                            style: const TextStyle(fontSize: 12)),
                      )),
                    ],
                  ]))
        ],
      )),
      appBar: CustomAppBar(
          backButton: true,
          title: const TitleAppbarWidget(content: "Facebook Passwords"),
          widgetActions: []),
    );
  }
}
