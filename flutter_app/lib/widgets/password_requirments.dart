import 'package:flutter/material.dart';

/**
 * PasswordRequirements is a StatelessWidget that displays the password requirements.
 * It includes a list of requirements that the password must meet.
 */
///
class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({super.key});

  /**
   * The build method returns a Column widget that contains the password requirements.
   * Each requirement is displayed as a Text widget.
   */
  ///
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password must contain:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text('- At least 8 characters'),
        Text('- At least one uppercase letter'),
        Text('- At least one number'),
        Text('- At least one special character'),
      ],
    );
  }
}