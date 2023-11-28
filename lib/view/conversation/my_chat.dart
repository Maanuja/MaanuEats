import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maanueats/model/my_message.dart';
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
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: messageService.getMessagesStream(widget.userId2),
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
          List<QueryDocumentSnapshot> messages = snapshot.data!;
          return ListView.builder(
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
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://picsum.photos/seed/${message.senderId}/200/300",
                          ),
                        ),
                        title: Text(message.content),
                        subtitle: Text(message.datetime.toString()),
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