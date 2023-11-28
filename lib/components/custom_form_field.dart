import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final IconData? prefixIcon;
  final String hintText;
  final String labelText;
  final String? initialValue;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const CustomFormField({
    Key? key,
    this.prefixIcon,
    required this.hintText,
    required this.labelText,
    this.initialValue,
    this.onSaved,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        initialValue: initialValue,
        onSaved: onSaved,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.blue)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: hintText,
          label: Text(labelText),
        ),
      ),
    );
  }
}
