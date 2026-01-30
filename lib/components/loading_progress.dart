import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingProgress {
  static onLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoActivityIndicator(radius: 30, color: Colors.black54);
      },
    );
  }

  static hideDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
