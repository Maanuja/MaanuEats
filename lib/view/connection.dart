import 'package:flutter/material.dart';
import 'package:maanueats/controller/firestoreHelper.dart';
import 'package:maanueats/restaurant.dart';
import 'package:maanueats/view/dashboard.dart';
import 'package:maanueats/view/my_animation.dart';
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
                  const Text ('Log In your account',
                      style:TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                          color: Colors.grey
                      )
                  ),
                  const SizedBox(height: 10),
                  MyAnimation(
                    duration: 0,
                    child: Image.network('https://media.tenor.com/arL-Och6Y7sAAAAC/connecting-loading.gif',
                        height: 200
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyAnimation(
                    duration: 0,
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
                    duration: 0,
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
                        print('click connect');
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
                      child: Text('connect')
                  )
                ],
              )
          ),
        ],
      ),
    );
  }
}