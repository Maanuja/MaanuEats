/* Controller des conversations de mon application de messagerie */

// Importation des packages
import 'package:maanueats/controller/firestoreHelper.dart';
import 'package:maanueats/model/my_message.dart';
import 'package:maanueats/model/my_user.dart';
import 'package:maanueats/service/messageService.dart';

class MessageController {
  // Instanciation des services
  final firestoreHelper = FirestoreHelper();
  final messageService = MessageService();

  // Récupère l'uid de l'utilisateur actuellement connecté
  Future<String> getCurrentUid() async {
    String uid = await firestoreHelper.getCurrentUid();
    return uid;
  }

  // Récupère la liste des messages
  Future<List<MyMessage>> getMessages(MyUser contactedUserId) async {
    String currentUid = await getCurrentUid();
    return messageService.getMessages(currentUid, contactedUserId.uid);
  }

  // Envoie un message
  Future<void> sendMessage(String content, String receiverId) async {
    messageService.sendMessage(content, receiverId);
  }
}