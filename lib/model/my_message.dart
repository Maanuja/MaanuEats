import 'package:cloud_firestore/cloud_firestore.dart';

class MyMessage {
  late String content;
  late String receiverId;
  late String senderId;
  late DateTime datetime;

  MyMessage(){
    datetime = DateTime.now();
  }

  MyMessage.database(DocumentSnapshot snapshot) {
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    content = map['content'];
    receiverId = map['receiverId'];
    senderId = map['senderId'];
    datetime = map['datetime'] == null ? DateTime.now() : map['datetime'].toDate();
  }
}