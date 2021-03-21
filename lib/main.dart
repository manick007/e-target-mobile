import 'package:flutter/material.dart';
import 'Auth/login.dart';

void main() =>runApp(MyApp()); //

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(243, 156, 42, 1),
//        primaryColor: Color.fromRGBO(23, 179, 224, 1),
//        primaryColor: Color.fromRGBO(10, 122, 169, 1),
//        color
      ),
      home: Login(),
      debugShowCheckedModeBanner: false,

    );
  }
}
