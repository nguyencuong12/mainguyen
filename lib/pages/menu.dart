import 'package:flutter/material.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/pages/guests.dart';
import 'package:mainguyen/pages/ourOfStock.dart';
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
                    ]))

            // Generate 100 widgets that display their index in the List.

            ));
  }
}
