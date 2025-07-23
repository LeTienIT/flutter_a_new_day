import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  final TextEditingController category;
  final String? Function(String?)? validator;
  final String title;
  final String? hint;
  final bool readOnly;
  const TextForm({super.key, required this.category, this.validator, required this.title, this.hint='', this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: TextFormField(
          controller: category,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text(title),
              hintText: hint
          ),
          readOnly: readOnly,
          validator: validator ?? notEmpty,
        )
    );
  }

  static String? notEmpty(String? value, {String message = 'Không được để trống'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }
}