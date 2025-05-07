import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_app/screens/confirm_screen.dart';

/**
 * CaptchaScreen is a StatefulWidget that handles the captcha verification process.
 * It includes a text field for entering the captcha value and a button to verify it.
 * If the captcha is verified successfully, it shows a success message.
 * If the captcha is invalid, it shows an error message.
 * The captcha is generated randomly and displayed to the user.
 */
///
class CaptchaScreen extends StatefulWidget {
  final String username; 
  const CaptchaScreen({super.key, required this.username}); // Constructor to receive the username from the sign-up process.

  @override
  _CaptchaScreenState createState() => _CaptchaScreenState();
}

/**
 * CaptchaScreen is a StatefulWidget that handles the captcha verification process.
 * It includes a text field for entering the captcha value and a button to verify it.
 * If the captcha is verified successfully, it shows a success message.
 */
///
class _CaptchaScreenState extends State<CaptchaScreen> {
  TextEditingController captchaController = TextEditingController();
  String generatedCaptcha = '';

  /**
   * Initializes the state of the CaptchaScreen.
   * It generates a random captcha string when the screen is first created.
   */
  ///
  @override
  void initState() {
    super.initState();
    buildCaptcha();
  }

  /**
   * Generates a random captcha string.
   * The captcha consists of letters and numbers.
   * The length of the captcha is 6 characters.
   */
  ///
  void buildCaptcha() {
    debugPrint("buildCaptcha called");
    const letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#%&*()_+";
    const length = 6;
    final random = Random();
    var randomString = String.fromCharCodes(List.generate(length, (index) => letters.codeUnitAt(random.nextInt(letters.length))));
    setState(() {generatedCaptcha = randomString;});
    debugPrint("the random string is $randomString");
  }

  /**
   * Builds the UI for the CaptchaScreen.
   * It includes a text field for entering the captcha value,
   * a button to verify the captcha, and a display for the generated captcha.
   */
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captcha Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Captcha Value',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  generatedCaptcha,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: captchaController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Captcha',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (captchaController.text == generatedCaptcha) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Captcha Verified!')),
                  );
                  // Navigate to the next screen (ConfirmScreen)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmScreen(username: widget.username),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid Captcha!')),
                  );
                }
              },
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}