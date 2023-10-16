import 'package:cloud_firestore/cloud_firestore.dart';

import '../constant.dart';

class MyUser {
  late String uid;
  late String lastname;
  late String firstname;
  late String email;
  String ? avatar;
  List ? favoris;


  String get fullName {
    return "$lastname $firstname";
  }

  MyUser(){
    uid = "";
    lastname = "";
    firstname = "";
    email = "";
  }

  MyUser.database(DocumentSnapshot snapshot) {
    uid = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    lastname = map['lastname'];
    firstname = map['firstname'];
    email = map['email'] ;
    avatar = map['avatar'] ?? imageDefault;
    favoris = map['favoris'] ?? [];
  }
}