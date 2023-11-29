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
    String name = lastname.toUpperCase();
    name += " ${firstname[0].toUpperCase()}${firstname.substring(1)}";
    return name;
  }

  MyUser(){
    uid = "";
    lastname = "";
    firstname = "";
    email = "";
    favoris = [];
  }

  MyUser.database(DocumentSnapshot snapshot) {
    uid = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    lastname = map['lastname'];
    firstname = map['firstname'];
    email = map['email'] ;
    avatar = map['avatar'] ?? imageDefault;
    favoris = List<String>.from(map['favoris'] ?? []);
  }

  void addToFavorites(String userFavoriteUid) {
    favoris ??= [];
    if ( !favoris!.contains(userFavoriteUid)) {
      favoris!.add(userFavoriteUid);
    }

  }

  void removeFromFavorites(String userFavoriteUid) {
    if (favoris != null && favoris!.contains(userFavoriteUid)) {
      favoris!.remove(userFavoriteUid);
    }
  }

  bool isInFavorites(String userFavoriteUid) {
    return favoris != null && favoris!.contains(userFavoriteUid);
  }

}