import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/main.dart';
import 'auth_service.dart';

class VerificationScreen extends StatefulWidget{
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _auth = AuthService();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _auth.sendEmailVerificationLink();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
        timer.cancel();
        Navigator.pushNamed(context, '/main');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/ic_launcher.png',
              width: 70,
              height: 70,
            ),
            SizedBox(height: 10),
            Text('Email Verification',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('A verification email has been sent to your email.'),
            Text('Please click on the link to continue.'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                _auth.sendEmailVerificationLink();
              },
              child: Text('Resend verification email'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                _auth.signout();
              },
              child: Text('Continue with another account'),
            ),
          ],
        ),
      ),
    );
  }
}
