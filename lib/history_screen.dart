import 'package:flutter/material.dart';

import 'UI/meal_element.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
  bool deleteMode = false;

  @override
  Widget build(BuildContext context) {
    bool isToday = DateTime.now().day == selectedDate.day &&
        DateTime.now().month == selectedDate.month &&
        DateTime.now().year == selectedDate.year;
    bool isYesterday = yesterday.day == selectedDate.day &&
        yesterday.month == selectedDate.month &&
        yesterday.year == selectedDate.year;
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20),
                  Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.zero),
                      elevation: MaterialStateProperty.all<double>(0),
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedDate = selectedDate.subtract(Duration(days: 1));
                        print(selectedDate);
                      });
                    },
                    child: Icon(Icons.arrow_back_ios,
                        size: 26, color: Colors.black),
                  ),
                  //SizedBox(width: 20),
                  Column(
                    children: [
                      Visibility(
                        visible: isToday,
                        child: Text(
                          "Today",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isYesterday,
                        child: Text(
                          "Yesterday",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !isToday && !isYesterday,
                        child: Text(
                          "Day before",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${selectedDate.day} ${_getMonthName(selectedDate.month)}',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                  //SizedBox(width: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.zero),
                      elevation: MaterialStateProperty.all<double>(0),
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                    onPressed: () {
                      setState(() {
                        if (selectedDate.isBefore(yesterday)) {
                          selectedDate = selectedDate.add(Duration(days: 1));
                        }
                        print(selectedDate);
                      });
                    },
                    child: Icon(Icons.arrow_forward_ios,
                        size: 26, color: Colors.black),
                  ),
                  Spacer(),
                  Visibility(
                    visible: !deleteMode,
                    child: IconButton(
                      icon: Icon(Icons.delete_rounded,
                          color: Colors.black87, size: 30),
                      onPressed: () {
                        setState(() {
                          deleteMode = !deleteMode;
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: deleteMode,
                    child: IconButton(
                      icon: Icon(Icons.done_rounded,
                          color: Colors.black87, size: 30),
                      onPressed: () {
                        setState(() {
                          deleteMode = !deleteMode;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MealElement(
                      mealName: 'breakfast',
                      color: Color.fromRGBO(234, 81, 81, 0.15),
                      date: selectedDate,
                      deleteMode: deleteMode),
                  MealElement(
                      mealName: 'brunch',
                      color: Color.fromRGBO(241, 188, 83, 0.15),
                      date: selectedDate,
                      deleteMode: deleteMode),
                  MealElement(
                      mealName: 'lunch',
                      color: Color.fromRGBO(192, 247, 116, 0.2),
                      date: selectedDate,
                      deleteMode: deleteMode),
                  MealElement(
                      mealName: 'snack',
                      color: Color.fromRGBO(143, 239, 172, 0.2),
                      date: selectedDate,
                      deleteMode: deleteMode),
                  MealElement(
                      mealName: 'dinner',
                      color: Color.fromRGBO(192, 236, 247, 0.4),
                      date: selectedDate,
                      deleteMode: deleteMode),
                  MealElement(
                      mealName: 'supper',
                      color: Color.fromRGBO(237, 191, 249, 0.2),
                      date: selectedDate,
                      deleteMode: deleteMode),
                ]),
          )
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
