import 'package:calculator_app/screens/calculator_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
     MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      home: CalculatorApp(),
    )
  );
}

