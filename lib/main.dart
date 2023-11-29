import 'package:flutter/material.dart';
import 'package:maanueats/controller/firestoreHelper.dart';
import 'package:maanueats/view/connection.dart';
import 'package:maanueats/view/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
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
                    const SizedBox(height: 100),
                    // Image network
                    const Image(
                      image: NetworkImage(
                          'https://www.creativefabrica.com/wp-content/uploads/2022/03/07/Restaurant-yummy-food-logo-design-Graphics-26620420-2-580x387.png'),
                      height: 200,
                    ),
                    // Text "Register your account" en orange à gauche de l'écran
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Register your account',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      onChanged: (text){
                        setState(() {
                          firstName = text;
                        });
                      },
                      decoration:  InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          hintText: "Firstname",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          )
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      controller : lastName,
                      decoration:  InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          hintText: "Lastname",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          )
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: email,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      decoration:  InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          )
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      obscureText: true,
                      controller: password,
                      decoration:  InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          )
                      ),
                    ),
                    const SizedBox(height: 10),

                    ElevatedButton(
                        onPressed:(){
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
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          backgroundColor: Colors.deepOrangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Yummy !',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        )
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