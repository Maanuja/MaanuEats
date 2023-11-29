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
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Rechercher un utilisateur',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirestoreHelper().cloudUser.snapshots(),
            builder: (context, snap) {
              if (ConnectionState.waiting == snap.connectionState) {
                return const CircularProgressIndicator.adaptive();
              } else {
                if (snap.hasData == null) {
                  return const Text("Aucune donnée");
                } else {
                  List documents = snap.data!.docs;

                  List filteredUsers = documents.where((user) {
                    MyUser otherUser = MyUser.database(user);
                    return moi.uid != otherUser.uid &&
                        (otherUser.fullName.toLowerCase().contains(
                                searchController.text.toLowerCase()) ||
                            otherUser.email
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase()));
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      MyUser otherUser = MyUser.database(filteredUsers[index]);
                      if (moi.uid == otherUser.uid) {
                        return Container();
                      } else {
                        bool isFavorite = moi.isInFavorites(otherUser.uid);
                        return Card(
                          elevation: 5,
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(
                                  otherUser.avatar ?? imageDefault),
                            ),
                            title: Text(otherUser.fullName),
                            subtitle: Text(otherUser.email),
                            trailing: Wrap(
                              spacing: 12, // space between two icons
                              children: <Widget>[
                                IconButton(
                                  icon: isFavorite
                                  ? const Icon(Icons.favorite,
                                      color: Colors.red)
                                        : const Icon(Icons.favorite_outline_outlined),
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
                                IconButton(
                                  icon: const Icon(Icons.message),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context){
                                          return MyChat(userId1: moi.uid, userId2 : otherUser);
                                        }
                                    ));
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
