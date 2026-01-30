import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int? maxLength;
  final TextInputType? keyboardType;

  const TextFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.maxLength,
    this.keyboardType,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLength: maxLength,
        buildCounter:
            maxLength == null
                ? null
                : (
                  context, {
                  required currentLength,
                  required isFocused,
                  required maxLength,
                }) {
                  return Text('$currentLength/$maxLength');
                },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black),
          ),
        ).copyWith(labelText: label),
      ),
    );
  }
}
