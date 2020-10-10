
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
  
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Home()
      );
      }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection:Axis.vertical,
        child:Center(
          child: Column(children: [],),
        ) ,
      ),
    );
  }
}