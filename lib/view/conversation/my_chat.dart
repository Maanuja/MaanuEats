import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maanueats/model/my_message.dart';
import 'package:flutter/material.dart';
import 'package:maanueats/model/my_user.dart';
import 'package:maanueats/service/messageService.dart';

import '../../constant.dart';
import '../../controller/firestoreHelper.dart';

class MyChat extends StatefulWidget {
  String userId1;
  MyUser userId2;

  MyChat({super.key, required this.userId1, required this.userId2});

  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  final messageService = MessageService();
  final firestoreHelper = FirestoreHelper();
  final _controllerScroll = ScrollController(initialScrollOffset: 100000);

  // Variable pour le formulaire, le champ de texte et le bouton d'envoi
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  late String _text;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title : Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.userId2.avatar!,
                ),
              ),
              const SizedBox(width: 16),
              Text(widget.userId2.fullName)
            ]
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: messageService.getMessagesStream(widget.userId2.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Une erreur est survenue"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
          return ListView.builder(
            // Page need to be scrolled to the bottom when a new message is sent and received and when the page is loaded
            controller: _controllerScroll,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              MyMessage message = MyMessage.database(messages[index]);
              bool isCurrentUser = message.senderId == widget.userId1;
              return Padding(
                padding: EdgeInsets.all(4),
                child: Align(
                  alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      color: isCurrentUser ? Colors.lime[50] : Colors.red[50],
                      child: ListTile(
                        leading: CircleAvatar(
                          // image of the user with userId2.avatar
                          backgroundImage: isCurrentUser ? NetworkImage(moi.avatar!) : NetworkImage(widget.userId2.avatar!),
                        ),
                        title: Text(message.content),
                        // subtitle with the date in the format dd/MM/yyyy HH:mm. message.datetime is type DateTime
                        subtitle: Text(
                          "${message.datetime.day}/${message.datetime.month}/${message.datetime.year} ${message.datetime.hour}:${message.datetime.minute}",
                        ),
                      ),
                    ),
                  ),
                ),
              );

            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: "Envoyer un message",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez saisir un message";
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  _text = _textController.text;
                  if (_formKey.currentState!.validate()) {
                    messageService.sendMessage(_text, widget.userId2.uid).then((value) => {
                      _textController.clear(),
                      _controllerScroll.animateTo(
                        _controllerScroll.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      )
                    });
                  }

                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }
}