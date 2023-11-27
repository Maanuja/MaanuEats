import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:maanueats/model/my_message.dart';
import 'package:maanueats/model/my_user.dart';


class FirestoreHelper {
  final auth = FirebaseAuth.instance;
  final cloudUser = FirebaseFirestore.instance.collection('users');
  final storage = FirebaseStorage.instance;

  //inscription
  Future<MyUser> RegisterMyUser(String lastname, String firstname , String email, String password) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
    String uid = credential.user!.uid;
    Map<String, dynamic> map = {
      'lastname' : lastname,
      'firstname' : firstname,
      'email' : email,
    };
    addUser(uid, map);
    return getUser(uid);
  }

  //récupération user
  Future<MyUser> getUser(String uid) async {
    DocumentSnapshot snapshot = await cloudUser.doc(uid).get();
    return MyUser.database(snapshot);
  }

  //ajout user
  addUser(String uid , Map<String, dynamic> data){
    cloudUser.doc(uid).set(data);
  }

  //connexion
  Future<MyUser>ConnectMyUser(String email, String password) async {
    UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
    String uid = credential.user!.uid;
    return getUser(uid);
  }

  //update user
  updateUser(String uid, Map<String,dynamic> data){
    cloudUser.doc(uid).update(data);
  }

  //stockage image
  Future<String>stockageFiles(String nameImage,Uint8List bytesImage,String dossier,String uid) async {
    TaskSnapshot snapshot = await storage.ref("/$dossier/$uid/$nameImage")
        .putData(bytesImage);
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  //ajouter une personne dans sa liste de favoris
  Future<void> addToFavoritesList(String userUid, String userFavoriteUid) async {
    await cloudUser.doc(userUid).update({
      'favoris': FieldValue.arrayUnion([userFavoriteUid]),
    });
    print("ajouter dans la db");
  }

  //supprimer une personne dans sa liste de favoris
  Future<void> removeFromFavoritesList(String userUid, String userFavoriteUid) async {
    await cloudUser.doc(userUid).update({
      'favoris': FieldValue.arrayRemove([userFavoriteUid]),
    });
    print("supprimer dans la db");

  }

  // Récupère l'uid de l'utilisateur actuellement connecté
  Future<String> getCurrentUid() async {
    User? user = auth.currentUser;
    return user!.uid;
  }

  // Récupère la liste des messages envoyés par l'utilisateur actuellement connecté à un utilisateur donné, et inversement
  Future<List<MyMessage>> getMessages(String uid) async {
    String currentUid = await getCurrentUid();
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('messages')
        .where('senderId', isEqualTo: currentUid)
        .where('receiverId', isEqualTo: uid)
        .get();
    QuerySnapshot snapshot2 = await FirebaseFirestore.instance.collection('messages')
        .where('senderId', isEqualTo: uid)
        .where('receiverId', isEqualTo: currentUid)
        .get();
    List<QueryDocumentSnapshot> list = snapshot.docs + snapshot2.docs;
    list.sort((a, b) => a['dateTime'].compareTo(b['dateTime']));
    List<MyMessage> messages = [];
    for (QueryDocumentSnapshot doc in list) {
      messages.add(MyMessage.database(doc));
    }
    return messages;
  }

  // Envoie un message
  Future<void> sendMessage(MyMessage message) async {
    await FirebaseFirestore.instance.collection('messages').add({
      'content': message.content,
      'receiverId': message.receiverId,
      'senderId': message.senderId,
      'dateTime': message.dateTime,
    });
  }

}