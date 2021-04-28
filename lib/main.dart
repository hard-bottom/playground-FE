import 'package:flutter/material.dart';
import 'package:playground/models/constants.dart';
import 'package:playground/pages/floatingPopulationPage.dart';

void main() => runApp(PlayGroundApp());

class PlayGroundApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlayGround',
      theme: ThemeData(
        primarySwatch: myBlack,
      ),
      home: FloatingPopulationPage(),
    );
  }
}