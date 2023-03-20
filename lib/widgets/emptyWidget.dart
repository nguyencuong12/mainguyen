import 'package:flutter/material.dart';
import 'package:mainguyen/utils/screenSize.dart';

class ImageEmpty extends StatelessWidget {
  const ImageEmpty({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage('assets/appIcons/package.png')),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.green),
            height: 300,
            width: screenSizeWithoutContext.width,
          ),
          SizedBox(height: 15),
          Text(title,
              style: TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}
