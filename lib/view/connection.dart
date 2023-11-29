import 'package:flutter/material.dart';
import 'package:maanueats/controller/firestoreHelper.dart';
import 'package:maanueats/restaurant.dart';
import 'package:maanueats/view/dashboard.dart';
import 'package:maanueats/view/my_background.dart';
import '../constant.dart';


class MyConnection extends StatefulWidget {
  const MyConnection({super.key});

  @override
  State<MyConnection> createState() => _MyConnectionState();
}

class _MyConnectionState extends State<MyConnection> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  popErreur(){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Email ou mot de passe incorrect'),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('ok')
              )
            ],
          );
        }
    );
  }

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
                      'Log in to your account',
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
                    controller: email,
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
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                        backgroundColor: Colors.deepOrangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed:(){
                        FirestoreHelper().ConnectMyUser(email.text, password.text)
                          .then((value) => {
                            setState(() {
                              moi = value;
                            }),
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context){
                                  return DashBoard(firstName: moi.firstname, lastName : moi.lastname );
                                }
                            ))
                          })
                          .catchError((error) {
                            popErreur();
                          });
                      },
                      child: const Text(
                          'Yummy !',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                      )
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return const MyApp();
                        },
                      ),
                      );
                    },
                    child: const Text(
                      'Don\'t have an account ? Register here',
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