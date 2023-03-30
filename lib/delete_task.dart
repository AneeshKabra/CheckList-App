import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'tasklist.dart';
import 'home3.dart';

class delete_task extends StatefulWidget {
  static const id = 'delete-tasks';

  @override
  State<delete_task> createState() => _delete_taskState();
}

class _delete_taskState extends State<delete_task> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Arg;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            'Delete Task',
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(args.Collection)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<del_task> del_list = [];
            if (snapshot.hasData) {
              final tasks = snapshot.data;
              if (tasks != null) {
                for (var task in tasks.docs) {
                  if (args.label == 'All') {
                    if (task.data()["Progress"] != null) {
                      for (int i = 0; i < task.data()["Tasks"].length; i++) {
                        del_list.add(
                          del_task(
                            collection: args.Collection,
                            label: task.data()["Progress"],
                            title: task.data()["Tasks"][i]["Title"],
                            user: task.data()["Tasks"][i]["User"],
                            priority: task.data()["Tasks"][i]["Priority"],
                            all: true,
                          ),
                        );
                      }
                    }
                  } else {
                    if (task.data()["Progress"] == args.label) {
                      for (int i = 0; i < task.data()["Tasks"].length; i++) {
                        del_list.add(
                          del_task(
                            collection: args.Collection,
                            label: args.label,
                            title: task.data()["Tasks"][i]["Title"],
                            user: task.data()["Tasks"][i]["User"],
                            priority: task.data()["Tasks"][i]["Priority"],
                            all: false,
                          ),
                        );
                      }
                    }
                  }
                }
              }
            }
            return ListView.builder(
              itemCount: del_list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: del_list[index],
                );
              },
            );
          },
        ),
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
  final bool all;

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
  }
}
