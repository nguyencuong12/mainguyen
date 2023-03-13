import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.all(10), child: widget.bodyWidget));
  }
}
