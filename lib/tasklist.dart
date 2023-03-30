import 'package:checklist/add%20task.dart';
import 'package:checklist/delete_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home2.dart' as home2;
import 'edit_task.dart';

class tasklist extends StatelessWidget {
  static const id = 'tasklist';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as home2.Arg;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.label),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                add_task.id,
                arguments: Arguments1(
                  args.Collection,
                  args.label,
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                delete_task.id,
                arguments: Arguments1(
                  args.Collection,
                  args.label,
                ),
              );
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection(args.Collection).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<tasktile> TaskLists = [];
          if (snapshot.hasData) {
            final tasks = snapshot.data;
            if (tasks != null) {
              for (var task in tasks.docs) {
                if (args.label == 'All') {
                  if (task.data()!["Progress"] != null) {
                    for (var t = 0; t < (task.data()!["Tasks"].length); t++) {
                      TaskLists.add(
                        tasktile(
                          title: task.data()["Tasks"][t],
                          collection: args.Collection,
                          label: task.data()!["Progress"],
                          all: true,
                        ),
                      );
                    }
                  }
                } else {
                  if (task.data()!["Progress"] == args.label) {
                    for (var t = 0; t < (task.data()!["Tasks"].length); t++) {
                      TaskLists.add(
                        tasktile(
                          title: task.data()["Tasks"][t],
                          collection: args.Collection,
                          label: args.label,
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
            itemCount: TaskLists.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: TaskLists[index],
              );
            },
          );
        },
      ),
    );
  }
}

class tasktile extends StatefulWidget {
  tasktile(
      {required this.title,
      required this.collection,
      required this.label,
      required this.all});
  final Map title;
  final String collection;
  final String label;
  final bool all;

  double height = 0;
  @override
  State<tasktile> createState() => _tasktileState();
}

class _tasktileState extends State<tasktile> {
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

  TextStyle _black() {
    return const TextStyle(
      color: Colors.black,
    );
  }

  Widget getlabel(all, label) {
    if (all == true) {
      return Text(
        label,
        style: _black(),
      );
    } else {
      return const SizedBox(
        width: 0.0,
      );
    }
  }

  int c = 0;
  double size() {
    if (c == 0) {
      return 50;
    } else {
      return 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size(),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (c == 0) {
              c = 1;
            } else {
              c = 0;
            }
          });
        },
        style: ElevatedButton.styleFrom(
          primary: tilecolor(widget.title["Priority"]),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      widget.title["Title"],
                      style: _black(),
                    ),
                  ],
                ),
                Text(
                  widget.title["User"],
                  style: _black(),
                ),
                Row(
                  children: <Widget>[
                    getlabel(widget.all, widget.label),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          edit_task.id,
                          arguments: Arguments_edit(
                            widget.collection,
                            widget.label,
                            widget.title["Title"],
                            widget.title["User"],
                            widget.title["Dueby"],
                            widget.title["Priority"],
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: size() - 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Creator: ${widget.title["Creator"]}', style: _black()),
                  Text(
                    widget.title["Dueby"].toDate().toString().substring(0, 10),
                    style: _black(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Arguments_edit extends Arguments1 {
  final String Collection;
  final String label;
  final String name;
  final String user;
  final Timestamp date;
  final String priority;
  Arguments_edit(
    this.Collection,
    this.label,
    this.name,
    this.user,
    this.date,
    this.priority,
  ) : super(Collection, label);
}

class Arguments1 {
  final String Collection;
  final String label;
  Arguments1(
    this.Collection,
    this.label,
  );
}
