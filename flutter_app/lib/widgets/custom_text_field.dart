import 'package:flutter/material.dart';

/**
 * CustomTextField is a StatelessWidget that represents a customizable text field.
 * It includes a label, an icon, and an optional obscure text feature for password fields.
 */
///
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;

  /**
   * Constructor for CustomTextField.
   * @param controller The TextEditingController to manage the text input.
   * @param labelText The label text displayed above the text field.
   * @param icon The icon displayed inside the text field.
   * @param obscureText A boolean indicating whether the text should be obscured (for password fields).
   */
  ///
  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.obscureText = false,
  });

  /**
   * The build method returns a TextField widget with the specified properties.
   * It includes a label, an icon, and an optional obscure text feature.
   */
  ///
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      obscureText: obscureText,
    );
  }
}