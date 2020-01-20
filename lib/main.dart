import 'package:flutter/material.dart';
import 'package:cinemaque/components/splash_screen.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cinemaque",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.white,
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/a': (context) => SplashScreen(),
      }));
}
