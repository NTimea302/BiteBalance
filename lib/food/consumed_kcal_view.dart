import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:namer_app/food/food_screen.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/UI/fitness_app_theme.dart';
import 'package:namer_app/UI/curve_painter.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/globals.dart';
import 'package:path_provider/path_provider.dart';
import '../UI/nutrition_element.dart';
import 'package:namer_app/main.dart';

var data;
// const apiKey = "PllGHxA8jt8cpAXS82CTY49TgnQPReT4tpPhUTLj";
// var query = '3lb carrots and a chicken sandwich';

class ConsumedKcalView extends StatefulWidget {
  @override
  _ConsumedKcalViewState createState() => _ConsumedKcalViewState();
}

class _ConsumedKcalViewState extends State<ConsumedKcalView> {
  bool tapped = false;
  List<dynamic> fetchedData = [];
  bool isLoading = true;
  var data;
  late String name;
  late double calories,
      servingSize,
      fatTotal,
      fatSaturated,
      protein,
      sodium,
      potassium,
      cholesterol,
      carbohydratesTotal,
      fiber,
      sugar;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: requestTodaysNutrition(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              heightFactor: 310,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Today\'s nutrition data was created'));
          } else {
            print('snapshot data: ');
            print(snapshot.data);
            int calories = snapshot.data[0]
                ['calories']; //Invalid value: Valid value range is empty: 0
            int proteins = snapshot.data[0]['proteins'];
            int carbs = snapshot.data[0]['carbs'];
            int fats = snapshot.data[0]['fats'];
            int sugar = snapshot.data[0]['sugar'];
            int fiber = snapshot.data[0]['fiber'];
            int water = snapshot.data[0]['water'];
            String lastDrink = snapshot.data[0]['lastDrink'];
            print('Calorie Intake consumed_kcal_view: $calorieIntake');
            return GestureDetector(
                onTap: () {
                  setState(() {
                    tapped = !tapped;
                  });
                },
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 16, bottom: 10),
                    child: Column(children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: FitnessAppTheme.grey.withOpacity(0.2),
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, left: 16, right: 16, bottom: 16),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 4),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 48,
                                                width: 2,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4,
                                                              bottom: 2),
                                                      child: Text(
                                                        'Eaten',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              FitnessAppTheme
                                                                  .fontName,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                          letterSpacing: -0.1,
                                                          color: FitnessAppTheme
                                                              .grey
                                                              .withOpacity(0.5),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: <Widget>[
                                                        // SizedBox(
                                                        //   width: 28,
                                                        //   height: 28,
                                                        //   child: Image.asset("assets/fitness_app/eaten.png"),
                                                        // ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4,
                                                                  bottom: 3),
                                                          child: Text(
                                                            calories
                                                                .toStringAsFixed(
                                                                    0),
                                                            //'2000',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  FitnessAppTheme
                                                                      .fontName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                              color:
                                                                  FitnessAppTheme
                                                                      .darkerText,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4,
                                                                  bottom: 3),
                                                          child: Text(
                                                            'Kcal',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  FitnessAppTheme
                                                                      .fontName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  -0.2,
                                                              color: FitnessAppTheme
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 48,
                                                width: 2,
                                                // decoration: BoxDecoration(
                                                //   color: HexColor('#77DD77')
                                                //       .withOpacity(0.5),
                                                //   borderRadius: BorderRadius.all(
                                                //       Radius.circular(4.0)),
                                                // ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4,
                                                              bottom: 2),
                                                      child: Text(
                                                        'Goal',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              FitnessAppTheme
                                                                  .fontName,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                          letterSpacing: -0.1,
                                                          color: FitnessAppTheme
                                                              .grey
                                                              .withOpacity(0.5),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4,
                                                                  bottom: 3),
                                                          child: Text(
                                                            calorieIntake
                                                                .toStringAsFixed(
                                                                    0),
                                                            //'2000',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  FitnessAppTheme
                                                                      .fontName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                              color:
                                                                  FitnessAppTheme
                                                                      .darkerText,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8,
                                                                  bottom: 3),
                                                          child: Text(
                                                            'Kcal',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  FitnessAppTheme
                                                                      .fontName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  -0.2,
                                                              color: FitnessAppTheme
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Center(
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                color: FitnessAppTheme.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(100.0),
                                                ),
                                                border: Border.all(
                                                    width: 4,
                                                    color: Color.fromARGB(
                                                            255, 88, 197, 25)
                                                        .withOpacity(0.2)),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    (calorieIntake -
                                                            calories.round())
                                                        .toStringAsFixed(0),
                                                    //'2000',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FitnessAppTheme
                                                              .fontName,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 24,
                                                      letterSpacing: 0.0,
                                                      color: Color.fromARGB(
                                                          255, 88, 197, 25),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Kcal left',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FitnessAppTheme
                                                              .fontName,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      letterSpacing: 0.0,
                                                      color: FitnessAppTheme
                                                          .grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: CustomPaint(
                                              painter: CurvePainter(
                                                  colors: [
                                                    Color.fromARGB(
                                                            255, 88, 197, 25)
                                                        .withOpacity(0.6),
                                                    Color.fromARGB(
                                                        255, 58, 131, 16),
                                                    Color.fromARGB(
                                                        255, 37, 83, 10),
                                                  ],
                                                  angle: 360 *
                                                      (calories.toDouble() /
                                                          calorieIntake
                                                              .toDouble())
                                                  //angle: 180
                                                  ),
                                              child: SizedBox(
                                                width: 108,
                                                height: 108,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Visibility(
                              visible: !tapped,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                child: Text("Tap for nutritional information",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black54)),
                              ),
                            ),
                            if (tapped)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 0, bottom: 8),
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: FitnessAppTheme.background,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                ),
                              ),
                            if (tapped)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 24, right: 24, top: 8, bottom: 16),
                                child: Column(
                                  children: [
                                    Row(children: <Widget>[
                                      NutritionElement(
                                          title: 'Protein',
                                          valueConsumed: proteins,
                                          valueTotal: 150),
                                      NutritionElement(
                                          title: 'Carbs',
                                          valueConsumed: carbs,
                                          valueTotal: 250),
                                      NutritionElement(
                                          title: 'Fat',
                                          valueConsumed: fats,
                                          valueTotal: 80),
                                    ]),
                                    SizedBox(height: 10),
                                    Row(children: <Widget>[
                                      SizedBox(width: 30),
                                      NutritionElement(
                                          title: 'Sugar',
                                          valueConsumed: sugar,
                                          valueTotal: 50),
                                      NutritionElement(
                                          title: 'Fiber',
                                          valueConsumed: fiber,
                                          valueTotal: 30),
                                    ]),
                                  ],
                                ),
                              ),
                            Visibility(
                              visible: tapped,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                child: Text("Tap to collapse",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black54)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 0, bottom: 8),
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: FitnessAppTheme.background,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  'Add Food',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          final image = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery);
                                        } catch (e) {
                                          print('Error: $e');
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: FitnessAppTheme.nearlyWhite,
                                          shape: BoxShape.circle,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Color.fromARGB(
                                                        255, 2, 130, 21)
                                                    .withOpacity(0.2),
                                                offset: const Offset(4.0, 4.0),
                                                blurRadius: 8.0),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Icon(
                                            Icons.photo_rounded,
                                            color:
                                                Color.fromARGB(255, 2, 130, 21),
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          final image = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.camera);
                                        } catch (e) {
                                          print('Error: $e');
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: FitnessAppTheme.nearlyWhite,
                                          shape: BoxShape.circle,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Color.fromARGB(
                                                        255, 2, 130, 21)
                                                    .withOpacity(0.2),
                                                offset: const Offset(4.0, 4.0),
                                                blurRadius: 8.0),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Icon(
                                            Icons.add_a_photo_rounded,
                                            color:
                                                Color.fromARGB(255, 2, 130, 21),
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        addFoodDialog(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: FitnessAppTheme.nearlyWhite,
                                          shape: BoxShape.circle,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Color.fromARGB(
                                                        255, 2, 130, 21)
                                                    .withOpacity(0.2),
                                                offset: const Offset(4.0, 4.0),
                                                blurRadius: 8.0),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Icon(
                                            Icons.add_circle_rounded,
                                            color:
                                                Color.fromARGB(255, 2, 130, 21),
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('Upload photo',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54)),
                                    Text('Take photo',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54)),
                                    Text('Log manually',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54)),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ])));
          }
        });
  }

  Future<dynamic> addFoodDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Food'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Type the food and portion you want to add.'),
              SizedBox(height: 6),
              Container(
                alignment: Alignment.centerLeft,
                child: MealTypeDropdown(),
              ),
              TextField(
                controller: foodController,
                decoration: InputDecoration(
                  labelText: 'Type here...',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                //foodController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Return'),
            ),
            TextButton(
              onPressed: () {
                //requestFood();
                print('Adding food to database...');
                addToDatabase();
                //foodController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
