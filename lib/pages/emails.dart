import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/models/secret/secret.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  late SecretModel secretModel =
      SecretModel(password: "xzx", emails: [], facebooks: [], zalos: []);
  Future<void> openBox() async {
    Box box = await Hive.openBox('secret');
    secretModel = box.getAt(0);

    setState(() {});
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
          bodyWidget: SizedBox(
              height: screenSizeWithoutContext.height,
              width: screenSizeWithoutContext.width,
              child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: (1 / .2),
                  ),
                  children: [
                    // Text(secretModel.password),
                    for (var i = 0; i < secretModel.emails.length; i++) ...[
                      Card(
                          child: ListTile(
                        onTap: () {},
                        leading: Image(
                          image: const AssetImage(
                            "assets/appIcons/gmail.png",
                          ),
                          height: screenSizeWithoutContext.height / 50,
                        ),
                        subtitle: Text(secretModel.emails[i].password,
                            style: const TextStyle(fontSize: 12)),
                        title: Text(secretModel.emails[i].username,
                            style: const TextStyle(fontSize: 12)),
                      )),
                    ],
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      child: const Icon(
                        Icons.add,
                      ),
                      onPressed: () async {
                        final _formKey = GlobalKey<FormState>();

                        TextEditingController _textUserName =
                            TextEditingController();
                        TextEditingController _textUserPassword =
                            TextEditingController();
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                  title: Text("Tạo Email"),
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
                                                decoration:
                                                    const InputDecoration(
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
                                                decoration:
                                                    const InputDecoration(
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
                                            if (_formKey.currentState!
                                                .validate()) {
                                              secretModel.emails.add(
                                                  EmailSecret(
                                                      password:
                                                          _textUserPassword
                                                              .text,
                                                      username:
                                                          _textUserName.text));

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
                    ),
                  ]))),
      appBar: CustomAppBar(
          backButton: true,
          title: TitleAppbarWidget(content: "Email Passwords"),
          widgetActions: [
            IconButton(
                onPressed: () {},
                icon: Icon(color: Colors.black, Icons.edit_outlined))
          ]),
    );
  }
}
