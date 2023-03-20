import 'package:flutter/material.dart';
import 'package:mainguyen/utils/textSize.dart';

class TitleAppbarWidget extends StatelessWidget {
  const TitleAppbarWidget({super.key, required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    return Text(content,
        style: TextStyle(fontSize: TextSize().getLabelTextSize()));
  }
}
