import '../controller/firestoreHelper.dart';
import '../model/my_message.dart';

class MessageService {
  // Instanciation de la classe FirestoreHelper
  final firestoreHelper = FirestoreHelper();

  // Récupère la liste des messages
  Future<List<MyMessage>> getMessages(String currentUid, String contactedUid) async {
    List<MyMessage> messages = await firestoreHelper.getMessages(contactedUid);
    return messages;
  }

  // Envoie un message
  Future<void> sendMessage(String content, String receiverId) async {
    MyMessage message = MyMessage();
    message.content = content;
    message.receiverId = receiverId;
    message.senderId = await firestoreHelper.getCurrentUid();
    message.dateTime = DateTime.now();
    await firestoreHelper.sendMessage(message);
  }
}