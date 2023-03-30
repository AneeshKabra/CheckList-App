import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class add_col extends StatefulWidget {
  static const id = 'add_collections';

  @override
  State<add_col> createState() => _add_colState();
}

class _add_colState extends State<add_col> {
  final _firebase = FirebaseFirestore.instance;

  final user = FirebaseAuth.instance.currentUser!.uid;
  late String name;
  void return_() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Create Collection',
            ),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List list = [];
            if (snapshot.hasData) {
              final collections = snapshot.data;
              if (collections != null) {
                for (var collection in collections.docs) {
                  for (int i = 0;
                      i < collection.data()["Collections"].length;
                      i++) {
                    if (list.contains(collection
                        .data()["Collections"][i]
                        .toString()
                        .toUpperCase())) {
                      continue;
                    } else {
                      list.add(
                        collection
                            .data()["Collections"][i]
                            .toString()
                            .toUpperCase(),
                      );
                    }
                  }
                }
              }
            }
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter Name of Collection',
                    ),
                    onChanged: (value) {
                      name = value.trim();
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (list.contains(name.toUpperCase())) {
                        Fluttertoast.showToast(
                          msg:
                              'Collection with the same name already exists. \n Please enter a different name',
                        );
                      } else if (name == '') {
                        Fluttertoast.showToast(
                          msg: 'Please enter a name.',
                        );
                      } else {
                        await _firebase.collection(name).doc("To Do").set({
                          "Progress": "To Do",
                          "Tasks": [],
                        });
                        final _firestore = _firebase.collection(name);
                        await _firestore.doc("In Progress").set({
                          "Progress": "In Progress",
                          "Tasks": [],
                        });
                        await _firestore.doc("Completed").set({
                          "Progress": "Completed",
                          "Tasks": [],
                        });

                        final list = await _firebase
                            .collection("users")
                            .doc(user)
                            .get()
                            .then((value) {
                          return [
                            value.data()!["Name"],
                            value.data()!["Collections"]
                          ];
                        });
                        list[1].add(name);
                        await _firestore.doc("Users").set({
                          "Users": [list[0]]
                        });

                        await _firebase.collection('users').doc(user).update({
                          'Collections': list[1],
                        });

                        return_();
                      }
                    } catch (e) {
                      if (e.runtimeType.toString() == 'LateError') {
                        Fluttertoast.showToast(
                          msg: 'Please enter the name',
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Submit',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
