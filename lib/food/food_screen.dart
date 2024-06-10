import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:namer_app/database_service.dart';
import 'package:namer_app/food/consumed_kcal_view.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/food/water_view.dart';
import 'package:namer_app/globals.dart';

final TextEditingController foodController = TextEditingController();
const apiKey = "PllGHxA8jt8cpAXS82CTY49TgnQPReT4tpPhUTLj";
var query = foodController.text;
String finalMealType = 'Snack';
final _dbService = DatabaseService();

Future<List<dynamic>> requestTodaysNutrition() async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();

  String userId = userID.toString();
  print('User ID: $userId');
  String date = DateTime.now().toString();

  print('Requesting today\'s nutrition...');
  String url = 'http://192.168.0.102:3000/nutrients/$userId/$date';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    data = jsonDecode(response.body);
    print('Today\'s nutrition: $data');
    if (data == null || data.isEmpty) {
      // Create an instance of today's nutrition here
      print('No data received. Creating an instance of today\'s nutrition...');
      await updateTodaysNutrition({
        'calories': 0,
        'proteins': 0,
        'carbs': 0,
        'fats': 0,
        'sugar': 0,
        'fiber': 0,
        'water': 0,
        "lastDrink": "00:00:00"
      });
      return jsonDecode(response.body);
    }
  } else {
    data = jsonDecode(response.body);
    throw Exception('Failed to load nutrition data');
  }
  return data = jsonDecode(response.body);
}

Future<String> requestFood() async {
  print('Making HTTP request...');
  query = foodController.text;
  print('Query: $query');
  final response = await http.get(
    Uri.parse('https://api.calorieninjas.com/v1/nutrition?query=$query'),
    headers: {
      'X-Api-Key': apiKey,
    },
  );
  print("Requesting from API finished");
  if (response.statusCode == 200) {
    print("Response api: ${response.body}");
    return response.body;
  } else {
    throw Exception('Error: ${response.statusCode} ${response.body}');
  }
}

void addToDatabase() async {
  try {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = userID.toString();
    final response = await requestFood();
    final responseData = jsonDecode(response);
    print("Adding to database...");
    print("Calories: ${responseData['items'][0]['calories']}");

    final mealData = {
      'userID': userId.toString(),
      'mealNameID': finalMealType == 'Breakfast'
          ? '1'
          : finalMealType == 'Brunch'
              ? '2'
              : finalMealType == 'Lunch'
                  ? '3'
                  : finalMealType == 'Dinner'
                      ? '4'
                      : finalMealType == 'Snack'
                          ? '5'
                          : '6',
      'name': responseData['items'][0]['name']?.toString() ?? 'Unknown',
      'date': DateTime.now().toString(),
      'calories': responseData['items'][0]['calories']?.toString() ?? '0',
      'serving_size':
          responseData['items'][0]['serving_size_g']?.toString() ?? '0',
      'fat_total_g': responseData['items'][0]['fat_total_g']?.toString() ?? '0',
      'fat_saturated_g':
          responseData['items'][0]['fat_saturated_g']?.toString() ?? '0',
      'protein_g': responseData['items'][0]['protein_g']?.toString() ?? '0',
      'sodium_mg': responseData['items'][0]['sodium_mg']?.toString() ?? '0',
      'potassium_mg':
          responseData['items'][0]['potassium_mg']?.toString() ?? '0',
      'cholesterol_mg':
          responseData['items'][0]['cholesterol_mg']?.toString() ?? '0',
      'carbohydrates_total_g':
          responseData['items'][0]['carbohydrates_total_g']?.toString() ?? '0',
      'fiber_g': responseData['items'][0]['fiber_g']?.toString() ?? '0',
      'sugar_g': responseData['items'][0]['sugar_g']?.toString() ?? '0',
    };
    final url = Uri.parse('http://192.168.0.102:3000/meal');
    final response2 = await http.post(
      url,
      body: mealData,
    );
    if (response2.statusCode == 200) {
      print('Meal inserted successfully');
      updateTodaysNutrition({
        'calories': responseData['items'][0]['calories']?.toString() ?? '0',
        'proteins': responseData['items'][0]['protein_g']?.toString() ?? '0',
        'carbs': responseData['items'][0]['carbohydrates_total_g']?.toString() ?? '0',
        'fats': responseData['items'][0]['fat_total_g']?.toString() ?? '0',
        'sugar': responseData['items'][0]['sugar_g']?.toString() ?? '0',
        'fiber': responseData['items'][0]['fiber_g']?.toString() ?? '0',
        'water': 2000,
        'lastDrink': '2022-01-01T00:00:00Z', // ISO 8601 formatted date string
      });
    } else {
      throw Exception('Error: ${response2.statusCode} ${response2.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

Future<String> updateTodaysNutrition(Map<String, dynamic> newValues) async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = userID.toString();
  String date = DateTime.now().toString().substring(0, 10);

  print('Updating today\'s nutrition...');
  print('New values: $newValues');
  String url = 'http://192.168.0.102:3000/nutrientss/$userId/$date';
  final response = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(newValues),
  );

  if (response.statusCode == 200) {
    print('Nutrition updated successfully');
    return response.body;
  } else {
    print('Response of update: ${response.body}');
    throw Exception('Failed to update nutrition data');
  }
}



class MealTypeDropdown extends StatefulWidget {
  @override
  MealTypeDropdownState createState() => MealTypeDropdownState();
}

class MealTypeDropdownState extends State<MealTypeDropdown> {
  String mealType = 'Breakfast';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: mealType,
      onChanged: (String? newValue) {
        setState(() {
          mealType = newValue!;
          print('Meal type: $mealType');
          finalMealType = mealType;
        });
      },
      items: <String>[
        'Breakfast',
        'Brunch',
        'Lunch',
        'Snack',
        'Dinner',
        'Supper'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

// ignore: must_be_immutable
class FoodScreen extends StatefulWidget {
  String mealType = 'Breakfast';

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  String mealType = 'Breakfast';

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        "Today's Nutrition",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${DateTime.now().day} ${_getMonthName(DateTime.now().month)}',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(width: 18),
                ],
              ),
            ),
          ),
          // SizedBox(
          //   height: 310,
          //   child: ConsumedKcalView(),
          // ),
          //Text(_dbService.read()),
          ConsumedKcalView(),
          WaterView(),
        ],
      ),
    );
  }
}

_getMonthName(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return 'Unknown';
  }
}
