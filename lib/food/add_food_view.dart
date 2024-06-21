import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namer_app/UI/fitness_app_theme.dart';
import 'package:namer_app/food/consumed_kcal_view.dart';
import 'package:namer_app/food/food_screen.dart';
import 'package:tflite/tflite.dart';

class AddFoodView extends StatefulWidget {
  @override
  _AddFoodViewState createState() => _AddFoodViewState();
}

class _AddFoodViewState extends State<AddFoodView> {
  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  classifyImage(File image) async {
    print('Classifying image...');
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 101, //the amout of categories our neural network can predict
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print(output!);
    print('The object is: ${_output[0]['label']}!');
    setState(() {
      _output = output!;
      _loading = false;
    });
  }

  loadModel() async {
    print('Loading model..');
    await Tflite.loadModel(
        model: 'assets/model/model.tflite', labels: 'assets/model/labels.txt');
    print('Model loaded.');
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: pickGalleryImage,
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.nearlyWhite,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Color.fromARGB(255, 2, 130, 21).withOpacity(0.2),
                        offset: const Offset(4.0, 4.0),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.photo_rounded,
                    color: Color.fromARGB(255, 2, 130, 21),
                    size: 35,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap:pickImage,
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.nearlyWhite,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Color.fromARGB(255, 2, 130, 21).withOpacity(0.2),
                        offset: const Offset(4.0, 4.0),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.add_a_photo_rounded,
                    color: Color.fromARGB(255, 2, 130, 21),
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
                        color: Color.fromARGB(255, 2, 130, 21).withOpacity(0.2),
                        offset: const Offset(4.0, 4.0),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.add_circle_rounded,
                    color: Color.fromARGB(255, 2, 130, 21),
                    size: 35,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Upload photo',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
            Text('Take photo',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
            Text('Log manually',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
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
