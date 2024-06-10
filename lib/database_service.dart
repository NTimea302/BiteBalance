import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namer_app/models/person.dart';

class DatabaseService{
  final _fire = FirebaseFirestore.instance;
  
  // create(Person pers){
  //   try{
  //     _fire.collection('users').add({
  //       'name': pers.firstName,
  //       'email': pers.email,
  //       'phone': pers.phoneNumber,
  //       'height': pers.height,
  //       'weightCurrent': pers.weightCurrent,
  //       'weightGoal': pers.weightGoal,
  //       'fitnessGoal': pers.fitnessGoal,
  //       'calorieIntake': pers.calorieIntake,
  //       'calorieBurn': pers.calorieBurn,
  //       'birthday': pers.birthday,
        
  //     });
  //     print('User created!');
  //   }catch(e){
  //     print(e);
  //   }
  // }

  // read() async {
  //   try{
  //     print('Reading data...');
  //     String idd = '0';
  //     final data = await _fire.collection('users').get().then((value){
  //       value.docs.forEach((element) {
  //         print('Next');
  //         print(element.data());
  //         idd = element.id;
  //         print(idd);
  //       });
  //     });
  //     return idd;
  //   }catch(e){
  //     print(e);
  //   };
  // }
}