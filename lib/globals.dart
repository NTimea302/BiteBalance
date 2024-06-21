import 'dart:convert';
import 'package:http/http.dart' as http;

int calorieIntake =
    0; // The user's daily calorie intake calculated from the user's personal data
int userID = 1;
int personalGoal = 0;

Future<int> initializeGlobals(String firebaseUserID) async {
  print('Initializing globals');
  userID = await getUserID(firebaseUserID);
  print('User ID (initialise globals fcn): $userID');
  // var data = await getUserData();
  // if (data.isNotEmpty) {
  //   calorieIntake = data[0]['calorieIntake'];
  //   print('Globals initialized');
  //   print('Calorie intake: $calorieIntake');
  //   print('User ID: $userID');
  // }
  return userID;
}

Future<int> getUserID(String firebaseUserID) async {
  print('Getting user ID from globals.dart');
  final response = await http
      .get(Uri.parse('http://192.168.0.100:3000/uidfromfuid/$firebaseUserID'));
  print("Got response");
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    userID = data[0]['userID'];
    var data1 = await getUserData();
    if (data1.isNotEmpty) {
      calorieIntake = data1[0]['calorieIntake'];
      print('Calorie intake (getUserData): $calorieIntake');
    }
    print('User ID (getUserID): $userID');
    return userID;
  } else {
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to get user ID');
  }
}

void resetGlobals() {
  print('Resetting globals');
  calorieIntake = 0;
  userID = 0;
  personalGoal = 0;
}

void setCalorieIntake(int intake) {
  print('Setting calorie intake to $intake');
  calorieIntake = intake;
}

void setPersonalGoal(int goal) {
  print('Setting personal goal to $goal');
  personalGoal = goal;
}

void setUserID(int id) {
  print('Setting user ID to $id');
  userID = id;
}

Future<List<dynamic>> getUserData() async {
  print('Getting user data from globals.dart');
  String userId = userID.toString();
  final response =
      await http.get(Uri.parse('http://192.168.0.100:3000/$userId'));
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print('User data: $data');
    return data;
  } else {
    throw Exception('Failed to get user data');
  }
}
