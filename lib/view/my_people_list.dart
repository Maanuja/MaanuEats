import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maanueats/constant.dart';
import 'package:maanueats/controller/firestoreHelper.dart';
import 'package:maanueats/model/my_user.dart';
import 'package:flutter/material.dart';
import 'package:maanueats/view/conversation/my_chat.dart';

class MyPeopleList extends StatefulWidget {
  const MyPeopleList({super.key});

  @override
  State<MyPeopleList> createState() => _MyPeopleListState();
}

class _MyPeopleListState extends State<MyPeopleList> {
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
                      bool isFavorite = moi.isInFavorites(otherUser.uid);
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
                          trailing: Wrap(
                            spacing: 12, // space between two icons
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.favorite_outline_outlined), onPressed: () {  },
                              ),
                              IconButton(
                                icon: const Icon(Icons.message),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context){
                                        return MyChat(userId1: moi.uid, userId2 : otherUser.uid);
                                      }
                                  ));
                                },
                              ),
                            ],
                          ),
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