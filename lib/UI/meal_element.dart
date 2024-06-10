import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:namer_app/globals.dart';

Future<List<dynamic>> fetchData(mealName, date) async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = userID.toString();
  String mealNameID = 1.toString();
  if (mealName == 'breakfast') {
    mealNameID = 1.toString();
  } else if (mealName == 'brunch') {
    mealNameID = 2.toString();
  } else if (mealName == 'lunch') {
    mealNameID = 3.toString();
  } else if (mealName == 'dinner') {
    mealNameID = 4.toString();
  } else if (mealName == 'snack') {
    mealNameID = 5.toString();
  } else if (mealName == 'supper') {
    mealNameID = 6.toString();
  }
  //print('Making request...');
  //DateTime date = DateTime.now();
  final response = await http.get(
      Uri.parse('http://192.168.0.102:3000/meals/$userId/$mealNameID/$date'));

  //print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

Future<int> fetchConsumedCalories(mealName, date) async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = userID.toString();

  String mealNameID = 1.toString();
  if (mealName == 'breakfast') {
    mealNameID = 1.toString();
  } else if (mealName == 'brunch') {
    mealNameID = 2.toString();
  } else if (mealName == 'lunch') {
    mealNameID = 3.toString();
  } else if (mealName == 'dinner') {
    mealNameID = 4.toString();
  } else if (mealName == 'snack') {
    mealNameID = 5.toString();
  } else if (mealName == 'supper') {
    mealNameID = 6.toString();
  }

  final response = await http.get(Uri.parse(
      'http://192.168.0.102:3000/calories/$userId/$mealNameID/$date'));

  //print('Response status: ${response.statusCode}');
  //print("Regi");
  //print('Response body: ${response.body}');

  final responseData = jsonDecode(response.body);
  final int caloriess = responseData['totalCalories']?.toInt() ?? 0;
  return caloriess;
}

Future<int> fetchTotalCalories() async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = userID.toString();

  final response = await http
      .get(Uri.parse('http://192.168.0.102:3000/totalcalories/$userId'));

  //print('Response status: ${response.statusCode}');
  //print("Uj");
  //print('Response body: ${response.body}');

  final responseData = jsonDecode(response.body);
  final int caloriess = responseData['calorieIntake']?.toInt() ?? 0;
  return caloriess;
}

Future<void> deleteMeal(int mealID) async {
  final response = await http.delete(
    Uri.parse('http://192.168.0.102:3000/meal/$mealID'),
  );

  if (response.statusCode == 200) {
    print('Meal deleted successfully');
  } else if (response.statusCode == 404) {
    print('Meal not found');
  } else {
    throw Exception('Failed to delete meal');
  }
}

Future<int> getPersonalGoal() async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //String personalGoal = prefs.getString('personalGoal') ?? '1';
  print('Personal goal meal element: $personalGoal');
  //int nr = int.parse(personalGoal);
  return personalGoal;
}

class MealElement extends StatefulWidget {
  final String mealName;
  final Color color;
  final DateTime date;
  final bool deleteMode;

  const MealElement(
      {required this.mealName,
      required this.color,
      required this.date,
      required this.deleteMode});

  @override
  State<MealElement> createState() => _MealElementState();
}

class _MealElementState extends State<MealElement> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              backgroundColor: widget.color,
              initiallyExpanded: false,
              leading: Image.asset(
                'assets/meals/${widget.mealName}.png',
                width: 42,
                height: 42,
              ),
              trailing:
                  Icon(Icons.do_not_touch_outlined, color: Colors.transparent),
              tilePadding: EdgeInsets.fromLTRB(8, 8, 0, 8),
              title: Row(
                children: [
                  Text(
                      widget.mealName[0].toUpperCase() +
                          widget.mealName.substring(1),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                  Spacer(),
                  FutureBuilder<int>(
                    future: fetchConsumedCalories(widget.mealName, widget.date),
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return FutureBuilder<int>(
                          future: fetchTotalCalories(),
                          builder: (BuildContext context,
                              AsyncSnapshot<int> snapshot2) {
                            if (snapshot2.hasError) {
                              return Text('Error: ${snapshot2.error}');
                            } else {
                              return FutureBuilder<int>(
                                future: getPersonalGoal(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot3) {
                                  if (snapshot3.hasError) {
                                    return Text('Error: ${snapshot3.error}');
                                  } else {
                                    int? personalGoal = snapshot3.data;
                                    double kiszamoltKaloriak = 0;
                                    int kellenekKaloriak = snapshot2.data ?? 0;
                                    String kiszamoltKaloriakKijelzo = '';
                                    if (widget.mealName == 'breakfast') {
                                      if (personalGoal == 2 ||
                                          personalGoal == 3) {
                                        kiszamoltKaloriak = 20;
                                      } else if (personalGoal == 5) {
                                        kiszamoltKaloriak = 25;
                                      } else if (personalGoal == 1 ||
                                          personalGoal == 4) {
                                        kiszamoltKaloriak = 30;
                                      }
                                    } else if (widget.mealName == 'brunch' ||
                                        widget.mealName == 'snack') {
                                      if (personalGoal == 2 ||
                                          personalGoal == 3) {
                                        kiszamoltKaloriak = 10;
                                      } else if (personalGoal == 5) {
                                        kiszamoltKaloriak = 5;
                                      } else if (personalGoal == 1 ||
                                          personalGoal == 4) {
                                        kiszamoltKaloriak = 5;
                                      }
                                    } else if (widget.mealName == 'lunch') {
                                      if (personalGoal == 2 ||
                                          personalGoal == 3) {
                                        kiszamoltKaloriak = 30;
                                      } else if (personalGoal == 5) {
                                        kiszamoltKaloriak = 35;
                                      } else if (personalGoal == 1 ||
                                          personalGoal == 4) {
                                        kiszamoltKaloriak = 40;
                                      }
                                    } else if (widget.mealName == 'dinner') {
                                      if (personalGoal == 2 ||
                                          personalGoal == 3) {
                                        kiszamoltKaloriak = 20;
                                      } else if (personalGoal == 5) {
                                        kiszamoltKaloriak = 25;
                                      } else if (personalGoal == 1 ||
                                          personalGoal == 4) {
                                        kiszamoltKaloriak = 20;
                                      }
                                    } else if (widget.mealName == 'supper') {
                                      if (personalGoal == 2 ||
                                          personalGoal == 3) {
                                        kiszamoltKaloriak = 10;
                                      } else if (personalGoal == 5) {
                                        kiszamoltKaloriak = 5;
                                      } else if (personalGoal == 1 ||
                                          personalGoal == 4) {
                                        kiszamoltKaloriak = 0;
                                      }
                                    }
                                    kiszamoltKaloriak = kiszamoltKaloriak *
                                        kellenekKaloriak /
                                        100;
                                    kiszamoltKaloriakKijelzo =
                                        kiszamoltKaloriak.ceil().toString();
                                    return Text(
                                      '${snapshot.data}/$kiszamoltKaloriakKijelzo kcal',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                },
                              );
                            }
                          },
                        );
                      }
                    },
                  )
                ],
              ),
              subtitle: FutureBuilder<List<dynamic>>(
                  future: fetchData(widget.mealName, widget.date),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 26.0,
                        width: 10.0,
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<dynamic> data = snapshot.data!;
                      List mealNames = data
                          .map((element) => element['name'] ?? 'No meal name')
                          .toList();
                      String joinedMealNames = mealNames.join(', ');
                      return Center(
                        child: Text(
                          joinedMealNames,
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 113, 113, 113),
                          ),
                        ),
                      );
                    }
                  }),
              children: <Widget>[
                FutureBuilder<List<dynamic>>(
                    future: fetchData(widget.mealName, widget.date),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 26.0,
                          width: 10.0,
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Column(
                          children: snapshot.data!.map<Widget>((element) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 0, bottom: 0),
                              child: ExpansionTile(
                                title: Row(
                                  children: [
                                    Text(
                                      (element['name'] != null &&
                                              element['name'].isNotEmpty)
                                          ? element['name'][0].toUpperCase() +
                                              element['name'].substring(1) +
                                              ':'
                                          : 'No meal name',
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      (element['name'] != null &&
                                              element['name'].isNotEmpty)
                                          ? '${element['calories'].round()} kcal'
                                          : '0 kcal',
                                      style: TextStyle(
                                        color: Colors.black45,
                                      ),
                                    ),
                                    //SizedBox(width: 4),
                                    // Text(
                                    //   (element['name'] != null &&
                                    //           element['name'].isNotEmpty)
                                    //       ? '${element['serving_size']} g'
                                    //       : '100 g',
                                    //   style: TextStyle(
                                    //     color: Colors.black45,
                                    //   ),
                                    // ),
                                    Spacer(),
                                    Visibility(
                                        visible: widget.deleteMode,
                                        child: IconButton(
                                          onPressed: () {
                                            //print(element['mealID']);
                                            deleteMeal(element['mealID']);
                                            setState(() {
                                              snapshot.data?.remove(element['mealID']);
                                            });
                                          },
                                          icon: Icon(Icons.delete, size: 20),
                                        ))
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 0, bottom: 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Portion: ${element['serving_size']} g',
                                              style: TextStyle(
                                                color: Colors.black45,
                                              ),
                                            ),
                                            Text(
                                              'Protein: ${element['protein_g']} g',
                                              style: TextStyle(
                                                color: Colors.black45,
                                              ),
                                            ),
                                            
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Carbs: ${element['carbohydrates_total_g']} g',
                                              style: TextStyle(
                                                color: Colors.black45,
                                              ),
                                            ),
                                            Text(
                                              'Fat: ${element['fat_total_g']} g',
                                              style: TextStyle(
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Sugar: ${element['sugar_g']} g',
                                              style: TextStyle(
                                                color: Colors.black45,
                                              ),
                                            ),
                                            Text(
                                              'Fiber: ${element['fiber_g']} g',
                                              style: TextStyle(
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(height: 12),
                                          ]
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
