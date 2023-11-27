import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maanueats/constant.dart';
import 'package:maanueats/controller/firestoreHelper.dart';
import 'package:maanueats/model/my_user.dart';
import 'package:flutter/material.dart';

class MyChat extends StatefulWidget {
  String userId1;
  String userId2;

  MyChat({super.key, required this.userId1, required this.userId2});

  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().cloudUser.snapshots(),
        builder: (context, snap){
          if(ConnectionState.waiting == snap.connectionState){
            return const CircularProgressIndicator.adaptive();
          }
          else
          {
            if(snap.hasData == null){
              return const Text("Aucune donnée");
            }
            else
            {
              List documents = snap.data!.docs;
              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context,index){
                    MyUser otherUser = MyUser.database(documents[index]);
                    if(moi.uid == otherUser.uid){
                      return Container();
                    }
                    else {
                      return Card(
                        elevation: 5,
                        color: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(otherUser.avatar ??
                                imageDefault),
                          ),
                          title: Text(otherUser.fullName),
                          subtitle: Text(otherUser.email),
                          trailing: Icon(Icons.favorite_outline_outlined),
                        ),
                      );
                    }
                  }
              );
            }

          }
        }
    );
  }
}