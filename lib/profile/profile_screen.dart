import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/UI/custom_dialog.dart';
import 'package:namer_app/globals.dart';
import 'package:namer_app/profile/profile_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../UI/show_my_dialog.dart';

Future<List<dynamic>> fetchData() async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = userID.toString();

  print('Making request...');
  final response =
      await http.get(Uri.parse('http://192.168.0.103:3000/$userId'));

  //print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  // String persGoal = jsonDecode(response.body)[0]['fitnessGoal'];
  // print('Personal goal: $persGoal');
  // await prefs.setString('personalGoal', persGoal);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    int fitnessGoal = data[0]['fitnessGoal'];
    //print('Fitness goal: $fitnessGoal');
    //await prefs.setString('personalGoal', fitnessGoal.toString());
    setPersonalGoal(fitnessGoal);
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

final TextEditingController passwordController = TextEditingController();

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool enabled = true;
  String displayFitnessGoal = '';
  String displayActivityLevel = '';
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future _loadImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/profile_pic${userID.toString()}.jpg';
    final File savedImage = File(path);
    if (await savedImage.exists()) {
      setState(() {
        _image = savedImage;
      });
    }
  }

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      final dir = await getApplicationDocumentsDirectory();
      final targetPath = '${dir.path}/profile_pic${userID.toString()}.jpg';
      final targetFile = File(targetPath);

      setState(() {
        _image = File(image.path);
        _image!.copy(targetFile.path);
      });
    } else {
      print('No image selected.');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
          future: fetchData(),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            String birthday = snapshot.data?[0]['birthday'] ?? '';
            //_image = AssetImage('assets/profilepics/${(snapshot.data?[0]['userID']).toString()}.jpg') as File;
            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(166, 162, 222, 130),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 50, 10, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width: 38),
                          CircleAvatar(
                            backgroundImage: _image != null ? FileImage(_image!) : null,
                            child: _image == null ? Icon(Icons.person, size: 55) : null,
                            //backgroundImage: AssetImage(
                            //    'assets/profilepics/${(snapshot.data?[0]['userID']).toString()}.jpg'),
                            radius: 40,
                          ),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              Text(
                                snapshot.data?[0]['firstName'] ?? '',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Builder(
                                builder: (BuildContext context) {
                                  String activityLevel =
                                      (snapshot.data?[0]['activityLevel'] ?? 1)
                                          .toString();
                                  //print('activity level: $activityLevel');
                                  //String displayActivityLevel = '';
                                  if (activityLevel == '1') {
                                    displayActivityLevel = 'Sedentary';
                                  } else if (activityLevel == '2') {
                                    displayActivityLevel = 'Light';
                                  } else if (activityLevel == '3') {
                                    displayActivityLevel = 'Moderate';
                                  } else if (activityLevel == '4') {
                                    displayActivityLevel = 'Active';
                                  } else if (activityLevel == '5') {
                                    displayActivityLevel = 'High intensity';
                                  }
                                  String fitnessGoal =
                                      (snapshot.data?[0]['fitnessGoal'] ?? 1)
                                          .toString();
                                  //print('fitness goal: $fitnessGoal');
                                  //String displayFitnessGoal = '';
                                  if (fitnessGoal == '1') {
                                    displayFitnessGoal = 'Loose weight';
                                  } else if (fitnessGoal == '2') {
                                    displayFitnessGoal = 'Gain weight';
                                  } else if (fitnessGoal == '3') {
                                    displayFitnessGoal = 'Get toned';
                                  } else if (fitnessGoal == '4') {
                                    displayFitnessGoal = 'Get fit';
                                  } else if (fitnessGoal == '5') {
                                    displayFitnessGoal = 'Balanced diet';
                                  } else if (fitnessGoal == '6') {
                                    displayFitnessGoal = 'Hydration focused';
                                  }
                                  return Text(
                                    displayFitnessGoal,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  );
                                },
                              ),
                            ],
                          ),
                          Spacer(),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.settings,
                                color: Colors.black87, size: 30),
                            onSelected: (String result) {
                              switch (result) {
                                case 'Setting 1':
                                  resetGlobals();
                                  Navigator.pushNamed(context, '/login');
                                case 'Setting 2':
                                  break;
                                case 'Setting 3':
                                  getImage();
                                  break;
                              }
                            },
                            offset: Offset(0, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0)), // This will make the edges rounder
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'Setting 1',
                                child: ListTile(
                                  leading: Padding(
                                    padding: EdgeInsets.fromLTRB(8, 8, 0,
                                        8), // Adjust the padding as needed
                                    child: Icon(Icons.logout,
                                        color: Colors.black87, size: 24),
                                  ), // Set your desired icon here
                                  title: Text('Log out',
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 16)),
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Setting 2',
                                child: ListTile(
                                  leading: Padding(
                                    padding: EdgeInsets.fromLTRB(8, 8, 0,
                                        8), // Adjust the padding as needed
                                    child: Icon(Icons.lock_rounded,
                                        color: Colors.black87, size: 24),
                                  ), // Set your desired icon here
                                  title: Text('Change password',
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 16)),
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Setting 3',
                                child: ListTile(
                                  leading: Padding(
                                    padding: EdgeInsets.fromLTRB(8, 8, 0,
                                        8), // Adjust the padding as needed
                                    child: Icon(Icons.person_add_alt_1_rounded,
                                        color: Colors.black87, size: 24),
                                  ), // Set your desired icon here
                                  title: Text('Update profile picture',
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 16)),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 12, 0, 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Account details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      //SizedBox(height: 20),
                      ProfileMenu(
                        text: "Birthday",
                        infoText: birthday.length >= 10
                            ? birthday.substring(0, 10)
                            : birthday,
                        press: () {},
                        enabled: false,
                      ),
                      ProfileMenu(
                        text: "Gender",
                        infoText: snapshot.data?[0]['gender'] == 'F'
                            ? 'Female'
                            : 'Male',
                        press: () {},
                        enabled: false,
                      ),
                      ProfileMenu(
                        text: "Email",
                        infoText: snapshot.data?[0]['email'] ?? '',
                        press: () => {},
                        enabled: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 6, 0, 6),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Personal details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      ProfileMenu(
                        text: "Personal goal",
                        infoText: displayFitnessGoal,
                        press: () {},
                        enabled: enabled,
                      ),
                      ProfileMenu(
                        text: "Activity level",
                        infoText:
                            displayActivityLevel, //(snapshot.data?[0]['activityLevel'] ?? 1),
                        press: () {},
                        enabled: enabled,
                      ),
                      ProfileMenu(
                        text: "Current weight",
                        infoText: (snapshot.data?[0]['weightCurrent'] ?? '')
                            .toString(),
                        press: () {},
                        enabled: enabled,
                      ),
                      ProfileMenu(
                        text: "Weight goal",
                        infoText:
                            (snapshot.data?[0]['weightGoal'] ?? '').toString(),
                        press: () {},
                        enabled: enabled,
                      ),
                      ProfileMenu(
                        text: "Caloric intake",
                        infoText: (snapshot.data?[0]['calorieIntake'] ?? '')
                            .toString(),
                        press: () => {},
                        enabled: false,
                      ),
                      ProfileMenu(
                        text: "Height",
                        infoText:
                            (snapshot.data?[0]['height'] ?? '').toString(),
                        press: () {},
                        enabled: false,
                      ),
                    ]),
                  )
                ],
              ),
            );
          }),
    );
  }
}
