import 'package:flutter/material.dart';
import 'package:namer_app/login/auth_service.dart';
import 'package:namer_app/login/input_field.dart';

class ForgotScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final _auth = AuthService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Forgot Password",
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _auth.sendPasswordResetLink(emailController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Reset email sent'),
                  ),
                );
                Navigator.pop(context);
              },
              child: Text('Send reset email'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

