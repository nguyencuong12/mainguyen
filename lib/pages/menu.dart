import 'package:flutter/material.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/pages/soldOrdered.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/textSize.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            backButton: true,
            title: Text("Danh mục",
                style: TextStyle(fontSize: TextSize().getLabelTextSize())),
            widgetActions: []),
        body: BodyWidget(
            bodyWidget: Container(
                height: screenSizeWithoutContext.height,
                width: screenSizeWithoutContext.width,
                child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 10,
                    ),
                    children: [
                      InkWell(
                          onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SoldOrders()),
                                )
                              },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.green)),
                              child: const Align(
                                child: ListTile(
                                  onTap: null,
                                  leading: Image(
                                      image: AssetImage(
                                          'assets/appIcons/package.png')),
                                  title: Text(
                                    'Hàng hóa đã bán ',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ))),
                    ]))

            // Generate 100 widgets that display their index in the List.

            ));
  }
}
