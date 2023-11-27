import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maanueats/constant.dart';
import 'package:maanueats/controller/firestoreHelper.dart';
import 'package:maanueats/model/my_user.dart';
import 'package:flutter/material.dart';

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
                          trailing: IconButton(
                            icon: isFavorite
                                ? Icon(Icons.favorite, color: Colors.red)
                                : Icon(Icons.favorite_outline_outlined),
                            onPressed: () {
                              setState(() {
                                if (isFavorite) {
                                  moi.removeFromFavorites(otherUser.uid);
                                  FirestoreHelper().removeFromFavoritesList(
                                      moi.uid, otherUser.uid);
                                } else {
                                  moi.addToFavorites(otherUser.uid);
                                  FirestoreHelper().addToFavoritesList(
                                      moi.uid, otherUser.uid);
                                }
                              });
                            },
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