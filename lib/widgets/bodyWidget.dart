import 'package:flutter/material.dart';
import 'package:mainguyen/utils/utilsFunction.dart';

class BodyWidget extends StatefulWidget {
  BodyWidget({super.key, required this.bodyWidget});
  Widget bodyWidget;

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
                onTap: () => {UtilsFunction().closeKeyboard()},
                child: widget.bodyWidget)));
  }
}
