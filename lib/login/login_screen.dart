import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/UI/custom_dialog.dart';
import 'package:namer_app/globals.dart';
import 'package:namer_app/login/input_field.dart';
import 'package:http/http.dart' as http;
import '../UI/show_my_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => loginUser(context),
              child: Text('Login'),
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
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((value) {
      print('Login successful');
      //setUserID(value.user!.uid);
      initializeGlobals();
      Navigator.pushNamed(context, '/home');
    }).catchError((error) {
      print('Error: $error');
      showMyDialog(
        context,
        'Error occured',
        'Please try again',
        [ButtonData(text: "Ok")],
      );
    });
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
