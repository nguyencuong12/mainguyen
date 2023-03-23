import 'package:flutter/material.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/models/secret/secret.dart';
import 'package:mainguyen/pages/facebooks.dart';
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
    print("MODEL11 ${secret.facebooks}");
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
                            .navigateScreen(context, FacebookPage());
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
                      onTap: () {},
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
                      onTap: () {},
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
                onPressed: () {},
                icon: Icon(color: Colors.black, Icons.edit_outlined))
          ]),
    );
  }
}
