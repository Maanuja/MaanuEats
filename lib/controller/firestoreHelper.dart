import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:maanueats/model/my_message.dart';
import 'package:maanueats/model/my_user.dart';
import 'package:async/async.dart' show StreamZip;

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

  // Récupère l'uid de l'utilisateur actuellement connecté
  Future<String> getCurrentUid() async {
    User? user = auth.currentUser;
    return user!.uid;
  }

  // getMessages avec un Stream
  Stream<List<QueryDocumentSnapshot>> getMessagesStream(String uid) async* {
    String currentUid = await getCurrentUid();
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('messages')
        .where('senderId', isEqualTo: currentUid)
        .where('receiverId', isEqualTo: uid)
        .snapshots();
    Stream<QuerySnapshot> stream2 = FirebaseFirestore.instance.collection('messages')
        .where('senderId', isEqualTo: uid)
        .where('receiverId', isEqualTo: currentUid)
        .snapshots();

    // Merge streams with StreamZip
    Stream<List<QuerySnapshot>> group = StreamZip([stream, stream2]);

    yield* group.map((snapshots) {
      List<QueryDocumentSnapshot> list = [];
      for (QuerySnapshot snapshot in snapshots) {
        list.addAll(snapshot.docs);
      }
      list.sort((a, b) => a.get('datetime').compareTo(b.get('datetime')));
      return list;
    });
    // await for (QuerySnapshot snapshot in group.stream) {
    //   List<QueryDocumentSnapshot> list = snapshot.docs;
    //   list.sort((a, b) => a.get('datetime').compareTo(b.get('datetime')));
    //   yield list;
    // }
  }

  // Envoie un message
  Future<void> sendMessage(MyMessage message) async {
    await FirebaseFirestore.instance.collection('messages').add({
      'content': message.content,
      'receiverId': message.receiverId,
      'senderId': message.senderId,
      'datetime': message.datetime,
    });
  }
}