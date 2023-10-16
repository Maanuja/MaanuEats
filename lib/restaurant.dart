import 'package:flutter/material.dart';

import 'main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Restaurant'),
    );
  }
}

class Restaurant extends StatefulWidget {
  String firstName;
  String lastName;

  Restaurant({required this.firstName, required this.lastName, super.key});

  @override
  State<Restaurant> createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.33,
          color: Colors.white,
          child: Text('Dans mon drawer'),
        ),
        appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text("Bonjour ${widget.lastName} ${widget.firstName}")
        ),
        body: const Text ('coucou')

    );
  }

}