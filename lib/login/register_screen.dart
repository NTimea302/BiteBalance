import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:namer_app/UI/custom_dialog.dart';
import 'package:namer_app/globals.dart';
import 'package:namer_app/login/input_field.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 150),
                Text("Register Account",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                InputField(
                    controller: confirmPasswordController,
                    text: "Confirm password",
                    infoText: "Enter password!",
                    icon: Icon(Icons.lock),
                    obscureText: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => registerUser(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    // backgroundColor: Colors.grey[200],
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 26,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text('Register'),
                ),
                SizedBox(height: 20),
                Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                    //Navigator.pushNamed(context, '/completeData');
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  void registerUser(BuildContext context) async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: 'Error',
            message: 'Please complete all fields!',
            buttons: [ButtonData(text: 'Ok')],
          );
        },
      );
    } else if (!emailController.text.contains('@') ||
        !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
            .hasMatch(emailController.text)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: 'Error',
            message: 'Invalid email address!',
            buttons: [ButtonData(text: 'Ok')],
          );
        },
      );
    } else if (passwordController.text.length < 8 ||
        !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
            .hasMatch(passwordController.text)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: 'Error',
            message:
                'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number!',
            buttons: [ButtonData(text: 'Ok')],
          );
        },
      );
    } else if (passwordController.text != confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: 'Error',
            message: 'Passwords do not match',
            buttons: [ButtonData(text: 'Ok')],
          );
        },
      );
    } else {
      print("Registering user...");
      final url = Uri.parse('http://192.168.0.103:3000/userreg');

      final response = await http.post(
        url,
        body: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        print('User registered successfully');
        print('Response: ${response.body}');
        final decodedResponse = json.decode(response.body);
        final userID = decodedResponse['userID'];
        print('User ID: $userID');
        final userId = userID.toString();
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString('userId', userId);
        setUserID(int.parse(userId));
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              title: 'Success',
              message: 'User registered successfully',
              buttons: [
                ButtonData(
                    text: 'Ok',
                    onPressed: (bool value) {
                      Navigator.pushNamed(context, '/completeData');
                    })
              ],
            );
          },
        );
      } else {
        print('Error registering user: ${response.body}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              title: 'Error',
              message: 'Server currently not working, please try again later!',
              buttons: [ButtonData(text: 'Ok')],
            );
          },
        );
      }
    }
  }
}
