import 'package:flutter/material.dart';
import 'package:self_checin/ui/home.ui.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Self CheckIn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeUI(),
    );
  }
}