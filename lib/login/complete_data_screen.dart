import 'package:flutter/material.dart';
import 'package:namer_app/globals.dart';
import 'package:namer_app/login/input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:namer_app/login/auth_service.dart';

Future<void> updateUser(String firebaseUserID, String firstName, String lastName, String height, String weightCurrent, String weightGoal, String fitnessGoal, String calorieIntake, String birthday, String gender, String activityLevel) async {
  print('FLUTTER: userupdate START!!!!!!!!!!!!');    
  print('User ID: $userID');
  print('Updating user with data: $firebaseUserID, $firstName, $lastName, $height, $weightCurrent, $weightGoal, $fitnessGoal, $calorieIntake, $birthday, $gender, $activityLevel');
  final response = await http.put(
    Uri.parse('http://192.168.0.100:3000/userupdate'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'firebaseUserID': firebaseUserID,
      'firstName': firstName,
      'lastName': lastName,
      'height': height,
      'weightCurrent': weightCurrent,
      'weightGoal': weightGoal,
      'fitnessGoal': fitnessGoal,
      'calorieIntake': calorieIntake,
      'birthday': birthday,
      'gender': gender,
      'activityLevel': activityLevel,
      'proteinIntake': 150,
      'carbsIntake': 250,
      'fatIntake': 80,
      'sugarIntake': 50,
      'fiberIntake': 30,
    }),
  );
  print('Response of complete data screen: ${response.body}');
  if (response.statusCode == 200) {
    print('User updated successfully');
    
  } else {
    throw Exception('Failed to update user');
  }
  print('FLUTTER: userupdate STOP!!!!!!!!!!!!');    
}

enum Gender { male, female }

class CompleteDataScreen extends StatefulWidget {
  @override
  State<CompleteDataScreen> createState() => _CompleteDataScreenState();
}

class _CompleteDataScreenState extends State<CompleteDataScreen> {
  final _auth = AuthService();

  Gender? _gender = Gender.male;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final desiredWeightController = TextEditingController();
  final birthdayController = TextEditingController();
  final genderController = TextEditingController();
  final fitnessGoalController = TextEditingController();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String? dropdownValue = 'Loose weight';
  String? dropdown2Value = 'Sedentary';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: prefs,
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // String userId = userID.toString();
          // print('User ID from SP: $userId');
          //String fitnessGoal;
          String? firebaseUserId = _auth.getUser();
          return Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/ic_launcher.png',
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(width: 10),
                          Text("Registration successful!",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text("Complete your data",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal)),
                      SizedBox(height: 10),
                      SizedBox(height: 20),
                      InputField(
                          controller: firstNameController,
                          text: "First name",
                          infoText: "",
                          icon: Icon(Icons.person_2_rounded),
                          obscureText: false),
                      InputField(
                          controller: lastNameController,
                          text: "Last name",
                          infoText: "",
                          icon: Icon(Icons.person_2_rounded),
                          obscureText: false),
                      InputField(
                          controller: heightController,
                          text: "Height  [cm]",
                          infoText: "",
                          icon: Icon(Icons.height_rounded),
                          obscureText: false,
                          isNumeric: true,),
                      Container(
                        height: 58,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(width: 15),
                            Expanded(
                              child: InputField(
                                controller: weightController,
                                text: "Weight",
                                infoText: "",
                                icon: Icon(Icons.monitor_weight_rounded),
                                obscureText: false,
                                doubleRow: true,
                                isNumeric: true,
                              ),
                            ),
                            Expanded(
                              child: InputField(
                                controller: desiredWeightController,
                                text: "Goal",
                                infoText: "",
                                icon: Icon(Icons.monitor_weight_rounded),
                                obscureText: false,
                                doubleRow: true,
                                isNumeric: true,
                              ),
                            ),
                            SizedBox(width: 15)
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(width: 30),
                          Text('Select birthday: ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              )),
                          SizedBox(
                              width:
                                  20), // Add some spacing between the button and the text field
                          Expanded(
                            child: TextField(
                              controller: birthdayController,
                              readOnly: true,
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    birthdayController.text =
                                        "${picked.toLocal()}".split(' ')[0];
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.calendar_month,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    size: 20),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                filled: true, // Fill the TextField
                                fillColor: Colors.white, // Set the fill color
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Fitness goal: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                )),
                            SizedBox(width: 10),
                            Container(
                              width: 130, // Set the width
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Colors
                                      .white, // This will change the background color of the dropdown items to white
                                ),
                                child: DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.green),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.transparent,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'Loose weight',
                                    'Gain weight',
                                    'Get toned',
                                    'Get fit',
                                    'Balanced diet'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          ]),
                          SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Activity level: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                )),
                            SizedBox(width: 10),
                            Container(
                              width: 130, // Set the width
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Colors
                                      .white, // This will change the background color of the dropdown items to white
                                ),
                                child: DropdownButton<String>(
                                  value: dropdown2Value,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.green),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.transparent,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdown2Value = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'Sedentary',
                                    'Light',
                                    'Moderate',
                                    'Active',
                                    'High intensity'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          ]),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _gender = Gender.male;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(100, 45),
                              foregroundColor:
                                  _gender == Gender.male ? Colors.black : null,
                              backgroundColor:
                                  _gender == Gender.male ? Colors.yellow : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    14), // Set the border radius
                              ),
                            ),
                            child: Text('Male'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _gender = Gender.female;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(100, 45),
                              foregroundColor: _gender == Gender.female
                                  ? Colors.black
                                  : null,
                              backgroundColor: _gender == Gender.female
                                  ? Colors.yellow
                                  : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    14), // Set the border radius
                              ),
                            ),
                            child: Text('Female'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async => {
                          print('Firebase user ID: $firebaseUserId'),
                          await updateUser(firebaseUserId!, firstNameController.text,
                              lastNameController.text, heightController.text,
                              weightController.text,
                              desiredWeightController.text,
                              dropdownValue == 'Loose weight' ? '1' : dropdownValue == 'Gain weight' ? '2' : dropdownValue == 'Get toned' ? '3' : dropdownValue == 'Get fit' ? '4' : '5',
                              '2000', birthdayController.text, 'F'
                              , (dropdown2Value == 'Sedentary' ? '1' : dropdown2Value == 'Light' ? '2' : dropdown2Value == 'Moderate' ? '3' : dropdown2Value == 'Active' ? '4' : '5')),
                          Navigator.pushNamed(context, '/home'),
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Colors.green, // Change the text color
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Change the border radius
                          ),
                        ),
                        child: Text('Save & Continue'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Exit',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ]),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
