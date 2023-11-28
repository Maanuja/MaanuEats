import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maanueats/constant.dart';
import 'package:maanueats/controller/firestoreHelper.dart';
import 'package:maanueats/model/my_message.dart';
import 'package:maanueats/model/my_user.dart';
import 'package:flutter/material.dart';
import 'package:maanueats/service/messageService.dart';

class MyChat extends StatefulWidget {
  String userId1;
  String userId2;

  MyChat({super.key, required this.userId1, required this.userId2});

  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  final messageService = MessageService();
  late Future<List<QueryDocumentSnapshot>> messagesFuture = messageService.getMessages(widget.userId2).catchError((error) {
    print(error);
    return [];
  });
  // Variable pour le formulaire, le champ de texte et le bouton d'envoi
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  late String _text;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: messagesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> messages = snapshot.data!;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                MyMessage message = MyMessage.database(messages[index]);
                return ListTile(
                  title: Text(message.content),
                  subtitle: Text(message.datetime.toString()),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
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
                    hintText: "Message",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez saisir un message";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _text = value;
                    });
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    messageService.sendMessage(_text, widget.userId2);
                    _textController.clear();
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