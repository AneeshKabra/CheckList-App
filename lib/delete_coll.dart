import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class delete_coll extends StatefulWidget {
  static const id = 'delete_coll';

  @override
  State<delete_coll> createState() => _delete_collState();
}

class _delete_collState extends State<delete_coll> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Delete Collections',
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List list = [];
            if (snapshot.hasData) {
              final collections = snapshot.data;
              if (collections != null) {
                for (int i = 0;
                    i < collections.data()["Collections"].length;
                    i++) {
                  list.add(
                    delete_widget(
                      title: collections.data()["Collections"][i],
                    ),
                  );
                }
              }
            }
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: list[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class delete_widget extends StatefulWidget {
  delete_widget({required this.title});
  final String title;

  @override
  State<delete_widget> createState() => _delete_widgetState();
}

class _delete_widgetState extends State<delete_widget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
          ),
          ElevatedButton(
            onPressed: () async {
              final List data1 = await FirebaseFirestore.instance
                  .collection(widget.title)
                  .doc("Users")
                  .get()
                  .then(
                (value) {
                  return value.data()!["Users"];
                },
              );

              List<String> data2 = [];
              await FirebaseFirestore.instance.collection('users').get().then(
                (value) {
                  for (var val in value.docs) {
                    if (data1.contains(val.data()["Name"])) {
                      data2.add(val.data()["User-ID"]);
                    }
                  }
                },
              );
              for (int i = 0; i < data2.length; i++) {
                final data = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get()
                    .then((value) {
                  return value.data()!["Collections"];
                });
                data.remove(widget.title);
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(data2[i])
                    .update({"Collections": data});
              }

              await FirebaseFirestore.instance
                  .collection(widget.title)
                  .get()
                  .then((value) {
                for (var val in value.docs) {
                  val.reference.delete();
                }
              });
            },
            child: const Text(
              'Delete',
            ),
          )
        ],
      ),
    );
  }
}
