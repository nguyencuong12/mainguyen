import 'package:flutter/material.dart';
import 'package:mainguyen/utils/colorApps.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  bool backButton;
  Widget title;
  List<Widget> widgetActions;

  CustomAppBar(
      {Key? key,
      required this.backButton,
      required this.title,
      required this.widgetActions})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);
  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: widget.title,
        actions: widget.widgetActions,
        centerTitle: true,
        leading:
            widget.backButton ? const BackButton(color: Colors.black) : null);
  }
}
