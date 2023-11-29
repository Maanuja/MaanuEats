import 'package:flutter/material.dart';
import 'package:maanueats/controller/firestoreHelper.dart';
import 'package:maanueats/view/my_background.dart';

import '../../constant.dart';
import '../../model/my_user.dart';
import '../dashboard.dart';


class EditProfil extends StatefulWidget {
  MyUser connectedUser;
  EditProfil({super.key, required this.connectedUser});

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController password = TextEditingController();

  popErreur(){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Erreur'),
            content: const Text('Mot de passe incorrect'),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text('ok')
              )
            ],
          );
        }
    );
  }
  popSuccess(){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Succès'),
            content: const Text('Donné changé avec succès'),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context){
                          return DashBoard(firstName: moi.firstname, lastName : moi.lastname );
                        }
                    ));
                  },
                  child: const Text('ok')
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Edit Your Informations',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Roboto',
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  ),
                  TextField(
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    controller: lastName,
                    decoration:  InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: moi.lastname,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        labelText: 'Last Name'
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    controller: firstName,
                    decoration:  InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: moi.firstname,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        labelText: 'First Name',
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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Enter Password to Confirm"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: password,
                                    obscureText: true,
                                    decoration: InputDecoration(labelText: 'Password'),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    // Validate the password and perform the action if it's correct
                                    String enteredPassword = password.text;
                                    bool isPasswordCorrect = await FirestoreHelper.confirmPassword(enteredPassword);

                                    if (isPasswordCorrect) {
                                      FirestoreHelper().updateUser(moi.uid, {'firstname': firstName.text.isNotEmpty ? firstName.text : moi.firstname, 'lastname': lastName.text.isNotEmpty ? lastName.text : moi.lastname});
                                      Navigator.pop(context); // Close the dialog
                                      popSuccess();
                                    } else {
                                      // Incorrect password, you can display an error message or take other actions
                                      Navigator.pop(context);
                                      popErreur();
                                    }
                                  },
                                  child: Text('Confirm'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Edit Me !',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
                      )
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}