import 'package:flutter/material.dart';
import 'package:flutter_video/camera_page.dart';
import 'package:flutter_video/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(isFromVideoPage: false,),
    );
  }
}
