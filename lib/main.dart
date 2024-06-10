import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/food/food_screen.dart';
import 'package:namer_app/globals.dart';
import 'package:namer_app/login/complete_data_screen.dart';
import 'package:namer_app/login/login_screen.dart';
import 'package:namer_app/login/register_screen.dart';
import 'package:namer_app/profile/profile_screen.dart';
import 'package:namer_app/history_screen.dart';
import 'package:namer_app/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'login/forgot_screen.dart';
import 'login/verification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bite Balance',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lime,
            secondary: Colors.lightGreen,
            error: Colors.red),
        scaffoldBackgroundColor: Colors.white,
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white,
        ),
        cardColor: Colors.white,
      ),
      home: MainPage(),
      routes: {
        '/completeData': (context) => CompleteDataScreen(),
        '/home': (context) => MyHomePage(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/settings': (context) => SettingsScreen(),
        '/main': (context) => MainPage(),
        '/forgotPassword': (context) => ForgotScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoginScreen();
            } else 
            if (snapshot.data?.emailVerified == true) {
              print('User is verified');
              String firebaseUserID = snapshot.data!.uid;
              return FutureBuilder(
                future: initializeGlobals(firebaseUserID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return MyHomePage();
                  }
                },
              );
            } else {
              return VerificationScreen();
            }
          }));
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HistoryScreen();
      case 1:
        page = FoodScreen();
      case 2:
        page = ProfileScreen();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Container(
          //color: Theme.of(context).colorScheme.shadow,
          child: page,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12.withOpacity(0.05),
              width: 1.0,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_outlined),
                  label: 'History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.apple_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outlined),
                  label: 'Profile',
                ),
              ],
              currentIndex: selectedIndex,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
      );
    });
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
