import 'package:flutter/material.dart';
import 'package:maanueats/controller/firestoreHelper.dart';
import 'package:maanueats/restaurant.dart';
import 'package:maanueats/view/connection.dart';
import 'package:maanueats/view/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:maanueats/view/my_animation.dart';
import 'package:maanueats/view/my_background.dart';
import 'controller/permissionPhoto.dart';
import 'firebase_options.dart';
import 'constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PermissionPhoto().init();
  runApp(const MyApp());
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
  String firstName = "";
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          const MyBackground(),
          Padding(
              padding: const EdgeInsets.all(10),
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
                        onChanged: (text){
                          setState(() {
                            firstName = text;
                          });
                        },
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
                        controller: email,
                        decoration:  InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            hintText: "enter your email",
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
                        controller: password,
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
                          print('click register');
                          FirestoreHelper().RegisterMyUser(lastName.text, firstName, email.text, password.text)
                              .then((value){
                            setState(() {
                              moi = value;
                            });
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context){
                                  return DashBoard(lastName: lastName.text, firstName: firstName,);
                                }
                            ));
                          })
                              .catchError((error){
                            //afficher un pop
                          });
                        },
                        child: Text('register')
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the connection page when the text is tapped
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            // Replace the current page with the connection page
                            return const MyConnection();
                          },
                        ),
                        );
                      },
                      child: const Text(
                        'Already have an account? Log in',
                        style: TextStyle(
                          color: Colors.blue, // Customize the color as needed
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
              )
          ),
        ],
      ),
    );
  }
}