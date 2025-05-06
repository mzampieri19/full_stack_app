import 'package:flutter/material.dart';
import 'package:test_app/screens/confirm_screen.dart';
import 'package:test_app/widgets/password_requirments.dart';
import '../services/auth_service.dart';
import 'user_list_screen.dart';
import '../widgets/custom_text_field.dart';

/**
 * AuthScreen is a StatefulWidget that handles user authentication (login and sign-up).
 * It includes text fields for username, password, and email (for sign-up).
 * It also provides buttons for login, sign-up, and toggling between the two modes.
 */
///
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

/**
 * _AuthScreenState is the state class for AuthScreen.
 * It manages the state of the authentication process, including loading indicators and input validation.
 */
///
class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool _isLoading = false;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  /**
   * Login function that handles user login.
   * It validates the input fields, makes an API call to the login endpoint,
   * and navigates to the UserListScreen if successful.
   */
  ///
  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    debugPrint('Attempting to log in with username: $username');

    if (username.isEmpty || password.isEmpty) {
      debugPrint('Validation failed: Username or password is empty');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter both username and password')));
      return;
    }

    setState(() {
      _isLoading = true;
      debugPrint('Loading state set to true');
    });

    try {
      final success = await AuthService.login(username, password);
      debugPrint('Login API call completed');
      
      setState(() {
        _isLoading = false;
        debugPrint('Loading state set to false');
      });

      if (success) {
        debugPrint('Login successful for username: $username');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserListScreen(username: username)),
        );
      } else {
        debugPrint('Login failed for username: $username');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed')));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        debugPrint('Loading state set to false due to error');
      });
      debugPrint('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login error: $e')));
    }
  }

  /**
   * Sign-up function that handles user registration.
   * It validates the input fields, verifies the captcha,
   * and makes an API call to the sign-up endpoint.
   * If successful, it navigates to the ConfirmScreen for email confirmation.
   */
  ///
  Future<void> _signUp() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final email = _emailController.text.trim();

    // Make sure all fields are filled
    if (username.isEmpty || password.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter username, password, and email')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await AuthService.signUp(username, password, email);
      setState(() => _isLoading = false);

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmScreen(username: username,),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign up failed')));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign up error: $e')));
    }
  }
  
  /**
   * Build method that constructs the UI for the authentication screen.
   * It includes text fields for username, password, and email (for sign-up),
   * as well as buttons for login, sign-up, and toggling between the two modes.
   */
  ///
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Welcome Back' : 'Create an Account'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Card for input fields
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          controller: _usernameController,
                          labelText: 'Username',
                          icon: Icons.person,
                        ),
                        SizedBox(height: 15),
                        CustomTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        if (!isLogin) ...[
                          SizedBox(height: 15),
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            icon: Icons.email,
                          ),
                          SizedBox(height: 15),
                          PasswordRequirements(),
                          SizedBox(height: 15),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Login/Sign Up Button
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: isLogin ? _login : _signUp,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(isLogin ? 'Login' : 'Sign Up'),
                      ),
                SizedBox(height: 20),
                // Toggle between Login and Sign Up
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin
                        ? 'Don’t have an account? Sign up'
                        : 'Already have an account? Log in',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}