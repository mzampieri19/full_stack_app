import 'package:flutter/material.dart';
import 'package:test_app/screens/captcha_screen.dart';
import 'package:test_app/services/user_service.dart';
import 'package:test_app/widgets/encouragement_widget.dart';
import 'package:test_app/widgets/password_requirments.dart';

import 'user_list_screen.dart';

import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';

/**
 * AuthScreen is a StatefulWidget that handles user authentication (login and sign-up).
 * It includes text fields for username, password, and email (for sign-up).
 * It also provides buttons for login, sign-up, and toggling between the two modes.
 */
///
class AuthScreen extends StatefulWidget {
  final String username; 
  final String email;

  const AuthScreen({super.key, required this.username, required this.email}); // Constructor to receive the username and email from the sign-up process.

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
    final success = await AuthService.login(username, password); // Modify AuthService to return user details
    debugPrint('Login API call completed');

    if (success) {
      final userDetails = await UserService.getUserDetails(username); // Fetch specific user details
      final email = userDetails['email']; // Extract email from user details

      // Fetch all users and extract only the required fields
      final users = (await UserService.fetchUsers())
          .map((user) => {
                'username': user['username'] as String,
                'email': user['email'] as String,
              })
          .toList();

      debugPrint('Login successful for username: $username');
      debugPrint('Navigating to UserListScreen with username: $username, email: $email');
      setState(() {
        _isLoading = false; // Reset loading state before navigation
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserListScreen(
            currentUser: username,
            currentUserEmail: email,
            users: users,
          ),
        ),
      );
    } else {
      debugPrint('Login failed for username: $username');
      setState(() {
        _isLoading = false; // Reset loading state on failure
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed')));
    }
  } catch (e) {
    setState(() {
      _isLoading = false; // Reset loading state on error
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

    debugPrint('Attempting to sign up with username: $username, email: $email');

    // Make sure all fields are filled
    if (username.isEmpty || password.isEmpty || email.isEmpty) {
      debugPrint('Validation failed: One or more fields are empty');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter username, password, and email')));
      return;
    }

    setState(() {
      _isLoading = true;
      debugPrint('Loading state set to true');
    });

    try {
      final success = await AuthService.signUp(username, password, email);
      debugPrint('Sign-up API call completed');

      setState(() {
        _isLoading = false;
        debugPrint('Loading state set to false');
      });

      if (success) {
        debugPrint('Sign-up successful for username: $username');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaptchaScreen(username: username, email: widget.email,),
          ),
        );
      } else {
        debugPrint('Sign-up failed for username: $username');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign up failed')));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        debugPrint('Loading state set to false due to error');
      });
      debugPrint('Sign-up error: $e');
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
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                isLogin ? 'Log in to your account' : 'Sign up for a new account',
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
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
             _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: isLogin ? _login : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      isLogin ? 'Login' : 'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin ? 'Don’t have an account? Sign up' : 'Already have an account? Log in',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 20),
              EncouragementWidget()
            ],
          ),
        ),
      ),
    );
  }
}