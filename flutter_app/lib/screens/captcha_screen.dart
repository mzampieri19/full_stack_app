import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/material.dart';

class CaptchaScreen extends StatefulWidget {
  const CaptchaScreen({super.key});

  @override
  State<CaptchaScreen> createState() => _CaptchaState();
}

class _CaptchaState extends State<CaptchaScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeHCaptcha();
    });
  }

  void _initializeHCaptcha() {
    void injectCaptcha() {
      final container = html.document.getElementById('hcaptcha-container');
      if (container != null && container.children.isEmpty) {
        js.context.callMethod('hcaptcha', [
          'render',
          'hcaptcha-container',
          js.JsObject.jsify({
            'sitekey': 'your-site-key-here',
            'theme': 'light',
            'size': 'normal',
            'callback': js.allowInterop((token) {
              html.window.console.log('hCaptcha token: $token');
            }),
          }),
        ]);
      }
    }

    void waitForHcaptcha() {
      if (js.context.hasProperty('hcaptcha')) {
        html.window.console.log('hCaptcha is ready.');
        injectCaptcha();
      } else {
        Future.delayed(const Duration(milliseconds: 100), waitForHcaptcha);
      }
    }

    waitForHcaptcha();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Captcha Verification')),
      body: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: HtmlElementView(viewType: 'hcaptcha-container'),
        ),
      ),
    );
  }
}
