import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({
    super.key,
    required this.nameButton,
    required this.onPressed,
    this.color,
  });

  final String nameButton;
  final void Function() onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        color: color ?? Colors.blue,
        child: TextButton(
          onPressed: onPressed,
          child: Text(nameButton, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
