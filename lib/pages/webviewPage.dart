import 'package:flutter/material.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/pages/webViewCustom.dart';
import 'package:mainguyen/utils/screenSize.dart';
import 'package:mainguyen/utils/utilsWidget.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';

import 'ourOfStock.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class GroupInterfaces {
  GroupInterfaces(
      {required this.title, required this.image, required this.link});
  String title;
  String image;
  String link;
}

class _WebviewPageState extends State<WebviewPage> {
  @override
  List<GroupInterfaces> getGroups = [
    GroupInterfaces(
        image:
            "https://scontent.fsgn2-4.fna.fbcdn.net/v/t39.30808-6/300265503_149176751090675_2464523333058174632_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=8631f5&_nc_ohc=m3-spHseEpMAX9rThtZ&_nc_ht=scontent.fsgn2-4.fna&oh=00_AfAorXaG6uzUf6d9zjTScC30Gmxd0Eb5YOn0-Eb1M71Rmg&oe=64298D62",
        link: "https://www.facebook.com/groups/hoibuonbanvaitonkhoxuatdu",
        title: "HỘI BUÔN BÁN VẢI TỒN KHO XUẤT DƯ"),
    GroupInterfaces(
        image:
            "https://scontent.fsgn2-7.fna.fbcdn.net/v/t39.30808-6/297160944_1705093509866538_8643457070503243978_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=8631f5&_nc_ohc=OHHaHsSLApEAX9OKVyH&_nc_ht=scontent.fsgn2-7.fna&oh=00_AfB_crlVTZ3J_jQKhh2jwL_cd2BmcXV0cWvHz5erqPdW-A&oe=642953E8",
        link: "https://www.facebook.com/groups/567162020831922/",
        title: "VẢI GIÁ RẺ"),
    GroupInterfaces(
        image:
            "https://scontent.fsgn2-9.fna.fbcdn.net/v/t1.6435-9/69130247_2304712443175495_4968753188346789888_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=8631f5&_nc_ohc=DTYpRie0VXgAX-wfOt0&_nc_ht=scontent.fsgn2-9.fna&oh=00_AfBNtMQMjJWB_sNZGFGu8p7V5x9mSphfquvawydohmdxrw&oe=644B4D5D",
        link: "https://www.facebook.com/groups/1255730657853886/",
        title: "Hội Mua Bán Vải Tp Hồ Chí Minh"),
    GroupInterfaces(
        image:
            "https://scontent.fsgn2-5.fna.fbcdn.net/v/t1.6435-9/140980853_729949071224818_6774864780626008117_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=8631f5&_nc_ohc=Vb566wpOeCsAX8dl0FA&_nc_ht=scontent.fsgn2-5.fna&oh=00_AfBibLHhU35Z_MEwl4L4fGqStDhmTLz_3n4goJKgPIASpA&oe=644B5194",
        link: "https://www.facebook.com/groups/269337430898006/",
        title: "CHỢ VẢI TOÀN QUỐC"),
    GroupInterfaces(
        image:
            "https://scontent.fsgn2-6.fna.fbcdn.net/v/t39.30808-6/250697630_121213773664310_6140664068458620924_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=8631f5&_nc_ohc=RBPPTjA-dIwAX8TWzSa&_nc_ht=scontent.fsgn2-6.fna&oh=00_AfD3w62tbUORoeozOyU_RksK9E48y57ce3781wq9eled_w&oe=6427E5FF",
        link: "https://www.facebook.com/groups/1564942943672299/",
        title: "Vải Ninh Hiệp"),
    GroupInterfaces(
        image:
            "https://scontent.fsgn2-9.fna.fbcdn.net/v/t39.30808-6/279215472_1134595543771103_9174275978900097474_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=8631f5&_nc_ohc=RqC5b4LEztsAX837LTc&_nc_ht=scontent.fsgn2-9.fna&oh=00_AfD3pPO0D_AE96D7NRCWeqCZ8CUb2r1hMRxqRv2MtRJeow&oe=6428FB84",
        link: "https://www.facebook.com/groups/371300766550550/",
        title: "Hội Mua Bán Vải Xuất Dư"),
  ];
  renderItem(String imageUrl, String title, Function onSubmit) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: ListTile(
        onTap: () {
          onSubmit();
        },
        leading: Image(
          image: NetworkImage(
            imageUrl,
          ),
          height: screenSizeWithoutContext.height,
        ),
        subtitle: const Text("Nhóm:",
            style: TextStyle(
              fontSize: 12,
            )),
        title: Text(title,
            style: const TextStyle(fontSize: 14, color: Colors.red)),
      )),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          backButton: true,
          title: const TitleAppbarWidget(content: "Các nhóm vải trên facebook"),
          widgetActions: []),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: (1 / .3),
        ),
        children: [
          ...getGroups.map(
            (group) => renderItem(
                group.image,
                group.title,
                () => {
                      UtilsWidgetClass().navigateScreen(
                          context,
                          WebViewCustom(
                              groupTitle: group.title, url: group.link))
                    }),
          )
        ],
      ),
    );
  }
}
