import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home4.dart' as home4;
import 'home3.dart' as home3;

class delete_label extends StatelessWidget {
  static const id = 'delete-label';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as home3.Arguments;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(args.Collection),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(args.Collection)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<delete_list> list = [];
            if (snapshot.hasData) {
              final labels = snapshot.data;
              if (labels != null) {
                for (var label in labels.docs) {
                  if (label.data()["Progress"] != null) {
                    list.add(
                      delete_list(
                        Collection: args.Collection,
                        label: label.data()["Progress"],
                      ),
                    );
                  }
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

class delete_list extends StatefulWidget {
  delete_list({
    required this.Collection,
    required this.label,
  });
  final String Collection;
  final String label;

  @override
  State<delete_list> createState() => _delete_listState();
}

class _delete_listState extends State<delete_list> {
  void return_() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(
            width: 80,
          ),
          Text(
            widget.label,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection(widget.Collection)
                  .doc(widget.label)
                  .delete();
              return_();
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
