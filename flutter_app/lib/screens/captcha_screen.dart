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
  final String email; // Added email parameter to the constructor
  
  const CaptchaScreen({super.key, required this.username, required this.email}); // Constructor to receive the username from the sign-up process.

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
   * Verifies the entered captcha against the generated captcha.
   * If the captcha matches, navigates to the ConfirmScreen.
   * Otherwise, shows an error message.
   */
  ///
  void verifyCaptcha() {
    if (captchaController.text.trim() == generatedCaptcha) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Captcha verified successfully!')));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(username: widget.username, email: widget.email,),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid captcha. Please try again.')));
      captchaController.clear();
      buildCaptcha(); // Generate a new captcha
    }
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
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Verify Captcha',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Please solve the captcha to proceed.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        generatedCaptcha,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: captchaController,
                      decoration: InputDecoration(
                        hintText: 'Enter captcha',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyCaptcha,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Verify',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}