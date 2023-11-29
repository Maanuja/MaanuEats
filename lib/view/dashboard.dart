import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:maanueats/constant.dart';
import 'package:maanueats/controller/firestoreHelper.dart';
import 'package:maanueats/main.dart';
import 'package:flutter/cupertino.dart';

import 'my_background.dart';
import 'my_people_list.dart';

void main() {
  runApp(const MyApp());
}

class DashBoard extends StatefulWidget {
  String firstName;
  String lastName;

  DashBoard({required this.firstName, required this.lastName, super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  Uint8List? bytesImages;
  String ? nameImage;
  int selectedIndex = 0;

  selectImage(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          if(Platform.isIOS){
            return CupertinoAlertDialog(
              title: const Text("Souhaitez vous enregistrer cette image"),
              content: Image.memory(bytesImages!),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, child: const Text("Annulation")
                ),
                TextButton(
                    onPressed: (){
                      //notre enregistrement dans la base de donnée
                      FirestoreHelper().stockageFiles(nameImage!, bytesImages!, "Images", moi.uid).then((value) {
                        setState(() {
                          moi.avatar = value;
                        });
                        Map<String,dynamic> data = {
                          "avatar":moi.avatar
                        };
                        FirestoreHelper().updateUser(moi.uid, data);
                      });
                      Navigator.pop(context);
                    }, child: const Text("Enregistrement")
                ),
              ],
            );
          }
          else
          {
            return AlertDialog(
              title: const Text("Souhaitez-vous enregistrer cette image ?"),
              content: Image.memory(bytesImages!),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, child: const Text("Annulation")
                ),
                TextButton(
                    onPressed: (){
                      //notre enregistrement dans la base de donnée
                      FirestoreHelper().stockageFiles(nameImage!, bytesImages!, "Images", moi.uid).then((value) {
                        setState(() {
                          moi.avatar = value;
                        });
                        Map<String,dynamic> data = {
                          "avatar":moi.avatar
                        };
                        FirestoreHelper().updateUser(moi.uid, data);
                      });
                      Navigator.pop(context);
                    }, child: const Text("Enregistrement")
                ),
              ],
            );
          }
        }
    );
  }


  pickImage() async {
    FilePickerResult ? resultat = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.image,
    );
    if (resultat != null){
      bytesImages = resultat.files.first.bytes;
      nameImage = resultat.files.first.name;
      selectImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.66,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 100),
                InkWell(
                  onTap:(){
                    pickImage();
                  },
                  child :CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(moi.avatar?? imageDefault),

                  ),
                ),
                const SizedBox(height: 10),
                Text(
                    moi.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'Roboto',
                      color: Colors.deepOrangeAccent,
                    )
                ),
                ListTile(
                  leading: const Icon(
                      Icons.mail,
                      color: Colors.deepOrangeAccent
                  ),
                  title: Text(
                      moi.email,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                      )
                  ),
                ),
                ElevatedButton.icon(
                  onPressed:(){
                    FirestoreHelper().signOut();
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context){
                          return const MyHomePage(title: "MaanuEats" );
                        }
                    ));
                  },
                  icon: const Icon(
                      Icons.logout,
                      color: Colors.deepOrangeAccent
                  ),
                  label: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        color: Colors.deepOrangeAccent,
                      )
                  ),
                ),
                // ListTile(
                  // leading: IconButton(
                  //   icon: const Icon(
                  //       Icons.logout,
                  //       color: Colors.deepOrangeAccent
                  //   ),
                  //   onPressed:(){
                  //     FirestoreHelper().signOut();
                  //     Navigator.push(context, MaterialPageRoute(
                  //         builder: (context){
                  //           return const MyHomePage(title: "MaanuEats" );
                  //         }
                  //     ));
                  //   },
                  // ),
                  // title: const Text(
                  //     'logout',
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       fontFamily: 'Roboto',
                  //     )
                  // ),
                // ),
              ],
            )
        ),
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
        ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          MyBackground(),
          Center(child: bodyPage()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value){
          setState(() {
            selectedIndex = value;
          });
        },
        currentIndex: selectedIndex,
        selectedItemColor: Colors.deepOrangeAccent,
        items: const [
          BottomNavigationBarItem(
              label: "Personnes",
              icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Cartes",
          )
        ],
      ),
    );
  }
  Widget bodyPage(){
    switch(selectedIndex){
      case 0 : return MyPeopleList();
      case 1 : return Text("afficher une carte");
      default: return Text("Impossible");
    }
  }
}