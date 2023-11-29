/* Controller des conversations de mon application de messagerie */

// Importation des packages
import 'package:maanueats/controller/firestoreHelper.dart';
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

  // Envoie un message
  Future<void> sendMessage(String content, String receiverId) async {
    messageService.sendMessage(content, receiverId);
  }
}