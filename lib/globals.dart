// globals.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

int calorieIntake = 0; // The user's daily calorie intake calculated from the user's personal data
int userID = 0;
int personalGoal = 0;

void initializeGlobals() async {
  var data = await getUserData();
  if (data.isNotEmpty) {
    calorieIntake = data[0]['calorieIntake'];
    //userID = data[0]['userID'];
    print('Globals initialized');
    print('Calorie intake: $calorieIntake');
    print('User ID: $userID');
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
  final response = await http.get(Uri.parse('http://192.168.0.103:3000/$userId'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print('User data: $data');
    return data;
  } else {
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to get user data');
  }
}