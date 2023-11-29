import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/firestoreHelper.dart';
import '../model/my_message.dart';

class MessageService {
  // Instanciation de la classe FirestoreHelper
  final firestoreHelper = FirestoreHelper();

  // getMessages avec Stream
  Stream<QuerySnapshot> getMessagesStream(String contactedUid) async* {
    yield* firestoreHelper.getMessagesStream(contactedUid);
  }

  // Envoie un message
  Future<void> sendMessage(String content, String receiverId) async {
    MyMessage message = MyMessage();
    message.content = content;
    message.receiverId = receiverId;
    message.senderId = await firestoreHelper.getCurrentUid();
    message.datetime = DateTime.now();
    await firestoreHelper.sendMessage(message);
  }
}