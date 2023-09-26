import 'package:flutter/material.dart';
import 'package:maanueats/restaurant.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:maanueats/view/my_animation.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
              children : [
                const Text ('Register your account',
                    style:TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                        color: Colors.grey
                    )
                ),
                MyAnimation(
                  duration: 1,
                  child: Image.network('https://images.unsplash.com/photo-1682685797406-97f364419b4a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80',
                      height: 200
                  ),
                ),
                const SizedBox(height: 10),
                MyAnimation(
                  duration: 2,
                  child: TextField(
                    controller : firstName,
                    decoration:  InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: "enter your fistname",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MyAnimation(
                  duration: 3,
                  child: TextField(
                    controller : lastName,
                    decoration:  InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: "enter your lastname",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MyAnimation(
                  duration: 4,
                  child: TextField(
                    decoration:  InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: "enter your mail",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MyAnimation(
                  duration: 5,
                  child: TextField(
                    obscureText: true,
                    decoration:  InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: "enter your password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                    onPressed:(){
                      print('click');
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context){
                            return Restaurant(firstName: firstName.text, lastName : lastName.text );
                          }
                      ));
                    },
                    child: Text('register')
                )
              ]
          )
      ),
    );
  }
}