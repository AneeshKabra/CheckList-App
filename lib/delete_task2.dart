import 'home3.dart' as home3;
import 'home4.dart' as home4;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class delete_task2 extends StatefulWidget {
  static const id = 'deleteTask2';

  @override
  State<delete_task2> createState() => _delete_task2State();
}

class _delete_task2State extends State<delete_task2> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as home3.Arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delete Task',
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection(args.Collection).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<del_task> list = [];
          if (snapshot.hasData) {
            final tasks = snapshot.data;
            if (tasks != null) {
              for (var task in tasks.docs) {
                if (task.data()["Progress"] != null) {
                  if (task.data()["Tasks"].length > 0) {
                    list.add(del_task(
                      collection: args.Collection,
                      label: "",
                      title: "",
                      user: "",
                      priority: "",
                      all: 2,
                    ));
                    list.add(del_task(
                      collection: args.Collection,
                      label: task.data()["Progress"],
                      title: "Title",
                      user: "",
                      priority: "",
                      all: 1,
                    ));
                  }

                  for (int i = 0; i < task.data()["Tasks"].length; i++) {
                    list.add(
                      del_task(
                        collection: args.Collection,
                        label: task.data()["Progress"],
                        title: task.data()["Tasks"][i]["Title"],
                        user: task.data()["Tasks"][i]["Creator"],
                        priority: task.data()["Tasks"][i]["Priority"],
                        all: 0,
                      ),
                    );
                  }
                }
              }
            }
          }
          return ListView(
            children: list,
          );
        },
      ),
    );
  }
}

class del_task extends StatefulWidget {
  del_task(
      {required this.collection,
      required this.label,
      required this.title,
      required this.user,
      required this.priority,
      required this.all});
  final String collection;
  final String label;
  final String title;
  final String user;
  final String priority;
  final int all;

  @override
  State<del_task> createState() => _del_taskState();
}

class _del_taskState extends State<del_task> {
  Color tilecolor(priority) {
    if (priority == 'Urgent') {
      return Colors.red;
    } else if (priority == 'Important') {
      return Colors.orange;
    } else if (priority == 'Medium') {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  Widget getlabel(all, label) {
    if (all == true) {
      return Text(
        label,
        style: const TextStyle(
          color: Colors.black,
        ),
      );
    } else {
      return const SizedBox(
        width: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.all == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: tilecolor(widget.priority),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    widget.title,
                  ),
                ],
              ),
              Text(
                widget.user,
              ),
              Row(
                children: <Widget>[
                  getlabel(widget.all, widget.label),
                  ElevatedButton(
                    onPressed: () async {
                      final List list = await FirebaseFirestore.instance
                          .collection(widget.collection)
                          .doc(widget.label)
                          .get()
                          .then((value) {
                        return value.data()!["Tasks"];
                      });
                      for (int i = 0; i < list.length; i++) {
                        if (widget.title == list[i]["Title"]) {
                          list.removeAt(i);
                          break;
                        }
                      }
                      await FirebaseFirestore.instance
                          .collection(widget.collection)
                          .doc(widget.label)
                          .update({
                        "Tasks": list,
                      });
                    },
                    child: const Text(
                      'Delete',
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else if (widget.all == 1) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    widget.label,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {},
                    child: Container(
                      child: const Text(
                        'Delete',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return const SizedBox(
        height: 50.0,
      );
    }
  }
}
