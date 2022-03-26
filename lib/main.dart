import 'package:flutter/material.dart';
import 'package:gesmuseum/Screens/HomePage.dart';


void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Musée',
      theme: ThemeData(
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        //fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
