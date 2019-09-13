import 'package:flutter/material.dart';
import 'package:json_api/materialSearch/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      //Switch between HomePage() and DemoSearch() to see the different search implementations.
      // home:DemoSearch()
    );
  }
}
