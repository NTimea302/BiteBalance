import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/UI/custom_dialog.dart';
import 'package:namer_app/globals.dart';
import 'package:namer_app/login/input_field.dart';
import 'package:http/http.dart' as http;
import '../UI/show_my_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'package:namer_app/database_service.dart';
import 'package:namer_app/models/person.dart';

class LoginScreen extends StatelessWidget {
  final _auth = AuthService();
  final _dbService = DatabaseService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Log In",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Image.asset(
              'assets/ic_launcher.png',
              width: 70,
              height: 70,
            ),
            SizedBox(height: 20),
            InputField(
                controller: emailController,
                text: "Email",
                infoText: "Enter email address!",
                icon: Icon(Icons.email),
                obscureText: false),
            InputField(
                controller: passwordController,
                text: "Password",
                infoText: "Enter password!",
                icon: Icon(Icons.lock),
                obscureText: true),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgotPassword');
                },
                child: Text('Forgot password?'),
              ),
            ),
            ElevatedButton(
              onPressed: () => loginUser(context),
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                print('Google login');
                await _auth.loginWithGoogle();
                print('Google login done');
                Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor:
                    Colors.transparent, // Set background color to transparent
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image.png',
                    width: 40,
                    height: 40,
                  ),
                  Text("  log in with "),
                  Text('G', style: TextStyle(color: Colors.blue)),
                  Text('o', style: TextStyle(color: Colors.red)),
                  Text('o',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 225, 0),
                          fontWeight: FontWeight.bold)),
                  Text('g', style: TextStyle(color: Colors.green)),
                  Text('l', style: TextStyle(color: Colors.blue)),
                  Text('e', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text("Don't have an account?"),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                'Register',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginUser(BuildContext context) async {
    print('Login user');
    final user = await _auth.loginUserWithEmailAndPassword(
        emailController.text, passwordController.text);
    if (user != null) {
      print("User Logged In");
      Navigator.pushNamed(context, '/home');
    } else {
      print("User not logged in");
      showMyDialog(
        context,
        'Invalid email or password',
        'Please try again',
        [ButtonData(text: "Ok")],
      );
    }

    //   final url = Uri.parse('http://192.168.0.103:3000/userlogin');
    //   final response = await http.post(
    //     url,
    //     body: {
    //       'email': emailController.text,
    //       'password': passwordController.text,
    //     },
    //   );
    //   print('Response status: ${response.body}');
    //   Map<String, dynamic> responseData = jsonDecode(response.body);
    //   String userId = responseData['userID'].toString();
    //   print('User ID: $userId');

    //   if (response.statusCode == 200) {
    //     // Login successful
    //     print('Login successful');
    //     setUserID(int.parse(userId));
    //     initializeGlobals();
    //     Navigator.pushNamed(context, '/home');
    //   }
    //   else if (response.statusCode == 401) {
    //     print('Invalid email or password');
    //     showMyDialog(
    //       context,
    //       'Invalid email or password',
    //       'Please try again',
    //       [ButtonData(text: "Ok")],
    //     );
    //   } else {
    //     showMyDialog(
    //       context,
    //       'Error occured',
    //       'Please try again',
    //       [ButtonData(text: "Ok")],
    //     );
    //     print('Error: ${response.body}');
    //   }
  }
}
