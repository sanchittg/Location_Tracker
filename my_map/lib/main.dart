import 'package:flutter/material.dart';
import 'package:my_map/screen/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Demo',
      home: HomeScreen(),
    );
  }
}
