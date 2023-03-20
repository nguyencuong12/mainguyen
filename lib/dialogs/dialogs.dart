import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

getDeleteDialog(BuildContext context, Function callback) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    // transitionDuration: Duration(milliseconds: 100),
    pageBuilder: (_, __, ___) {
      return AlertDialog(
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              // style: ButtonStyle(
              //   shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
              // ),
              child: const Text("Hủy"),
            ),
            OutlinedButton(
              onPressed: () {
                callback();
                Fluttertoast.showToast(
                    msg: "Đã xóa !! ",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.pop(context);
              },
              // style: ButtonStyle(
              //   shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
              // ),
              child: const Text("Xóa", style: TextStyle(color: Colors.red)),
            ),
          ],
          content: const SizedBox(
              height: 100,
              child: Center(
                  child: Text(
                "Bạn có muốn xóa hay không !!!",
                style: TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ))));
    },
    // transitionBuilder: (_, anim, __, child) {
    //   Tween<Offset> tween;
    //   if (anim.status == AnimationStatus.reverse) {
    //     tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
    //   } else {
    //     tween = Tween(begin: Offset(1, 0), end: Offset.zero);
    //   }

    //   return SlideTransition(
    //     position: tween.animate(anim),
    //     child: FadeTransition(
    //       opacity: anim,
    //       child: child,
    //     ),
    //   );
    // },
  );
}
