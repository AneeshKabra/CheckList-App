import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'add_collections.dart';
import 'delete_coll.dart';
import 'home4.dart';
// import 'home3.dart';

class list extends StatelessWidget {
  static const id = 'collections';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Collections',
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, add_col.id);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                delete_coll.id,
              );
            },
            icon: Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.exit_to_app,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<col_list> collectionlist = [];
          if (snapshot.hasData) {
            final collections = snapshot.data;
            if (collections != null) {
              for (var i = 0;
                  i < collections.data()["Collections"].length;
                  i++) {
                collectionlist
                    .add(col_list(title: collections.data()['Collections'][i]));
              }
            } else {
              Fluttertoast.showToast(
                msg: 'No Collections found'
                    'Please Create One',
              );
            }
          }
          return ListView.builder(
              itemCount: collectionlist.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: collectionlist[index],
                );
              });
        },
      ),
    );
  }
}

class col_list extends StatelessWidget {
  col_list({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          home.id,
          arguments: Args(
            title,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class Args {
  final String title;
  Args(
    this.title,
  );
}
