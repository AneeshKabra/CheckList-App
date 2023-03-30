import 'package:checklist/add%20task.dart';
import 'package:checklist/add_label.dart';
import 'package:checklist/add_user.dart';
import 'package:checklist/delete_label.dart';
import 'package:checklist/delete_task2.dart';
import 'package:checklist/tasklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'collections.dart';
import 'edit_task.dart';

class home extends StatefulWidget {
  static const id = 'home4';
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Args;

    return Scaffold(
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: Text('Add Label'),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    add_label.id,
                    arguments: Arguments(
                      args.title,
                    ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    add_user.id,
                    arguments: Arguments(
                      args.title,
                    ),
                  );
                },
                child: const Text(
                  'Add User',
                ),
              ),
              ElevatedButton(
                child: const Text('Delete Label'),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    delete_label.id,
                    arguments: Arguments(
                      args.title,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
        appBar: AppBar(
          title: Text(
            args.title,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  add_task.id,
                  arguments: Arguments(
                    args.title,
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  delete_task2.id,
                  arguments: Arguments(
                    args.title,
                  ),
                );
              },
              icon: const Icon(
                Icons.delete,
              ),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(args.title).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<DragAndDropList> list = [];
            List<tasktile> list_ = [];
            List list___ = [];
            List<List> list__ = [];
            if (snapshot.hasData) {
              final data = snapshot.data;
              if (data != null) {
                for (var dat in data.docs) {
                  DragAndDropList Lists;
                  list_ = [];
                  if (dat.data()["Progress"] != null) {
                    list___ = [dat.data()["Progress"], args.title];
                    for (int i = 0; i < dat.data()["Tasks"].length; i++) {
                      list___.add(dat.data()["Tasks"][i]);
                      list_.add(tasktile(
                        title: dat.data()["Tasks"][i],
                        label: dat.data()["Progress"],
                        collection: args.title,
                      ));
                    }
                    list__.insert(0, list___);
                    list.insert(
                        0,
                        DragAndDropList(
                          canDrag: false,
                          header: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50.0,
                              color: Colors.blue,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dat.data()["Progress"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          children: list_
                              .map((e) => DragAndDropItem(
                                    child: ListTile(
                                      title: SizedBox(
                                        width: 100.0,
                                        child: e,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ));
                  }
                }
              }
              ;
            }
            print(list__.toString());
            _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex,
                int newListIndex) async {
              if (oldListIndex != newListIndex) {
                List test = list__[oldListIndex];

                String collection = test[1];
                String label = test[0];
                Map tasks = test[oldItemIndex + 2];
                List test1 = list__[newListIndex];
                String label1 = test1[0];
                final data = await FirebaseFirestore.instance
                    .collection(collection)
                    .doc(label)
                    .get()
                    .then((value) {
                  return value.data()!["Tasks"];
                });
                final data1 = await FirebaseFirestore.instance
                    .collection(collection)
                    .doc(label1)
                    .get()
                    .then((value) {
                  return value.data()!["Tasks"];
                });
                for (int i = 0; i < data.length; i++) {
                  if (tasks["Title"] == data[i]["Title"]) {
                    data.removeAt(i);
                    test.removeAt(oldItemIndex + 2);
                    list__[oldListIndex] = test;
                    test1.insert(newItemIndex + 2, tasks);
                    list__[newListIndex] = test1;
                    break;
                  }
                }
                data1.insert(newItemIndex, tasks);
                await FirebaseFirestore.instance
                    .collection(collection)
                    .doc(label)
                    .update({"Tasks": data});
                await FirebaseFirestore.instance
                    .collection(collection)
                    .doc(label1)
                    .update({"Tasks": data1});
                setState(() {
                  var movedItem =
                      list[oldListIndex].children.removeAt(oldItemIndex);
                  list[newListIndex].children.insert(newItemIndex, movedItem);
                });
              } else {
                List test = list__[oldListIndex];
                String collection = test[1];
                String label = test[0];
                Map tasks = test[oldItemIndex + 2];
                final data = await FirebaseFirestore.instance
                    .collection(collection)
                    .doc(label)
                    .get()
                    .then((value) {
                  return value.data()!["Tasks"];
                });

                for (int i = 0; i < data.length; i++) {
                  if (tasks["Title"] == data[i]["Title"]) {
                    data.removeAt(i);
                    data.insert(newItemIndex, tasks);
                    test.removeAt(oldItemIndex + 2);
                    test.insert(newItemIndex + 2, tasks);
                    list__[oldListIndex] = test;
                    break;
                  }
                }

                await FirebaseFirestore.instance
                    .collection(collection)
                    .doc(label)
                    .update({"Tasks": data});
                setState(() {
                  var movedItem =
                      list[oldListIndex].children.removeAt(oldItemIndex);
                  list[oldListIndex].children.insert(newItemIndex, movedItem);
                });
              }
            }

            return OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return DragAndDropLists(
                    listDecoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(7.0)),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black45,
                          spreadRadius: 3.0,
                          blurRadius: 6.0,
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                    onItemReorder: _onItemReorder,
                    onListReorder: (
                      int oldListIndex,
                      int newListIndex,
                    ) {},
                    children: list,
                  );
                } else {
                  return DragAndDropLists(
                    axis: Axis.horizontal,
                    listWidth: 400.0,
                    listDecoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(7.0)),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black45,
                          spreadRadius: 3.0,
                          blurRadius: 6.0,
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                    listPadding: const EdgeInsets.all(8.0),
                    onItemReorder: _onItemReorder,
                    onListReorder: (
                      int oldListIndex,
                      int newListIndex,
                    ) {},
                    children: list,
                  );
                }
              },
            );
          },
        ));
  }
}

class Arguments {
  final String Collection;
  Arguments(this.Collection);
}

class tasktile extends StatefulWidget {
  tasktile({
    required this.title,
    required this.collection,
    required this.label,
  });
  Map title;
  String collection;
  String label;
  String getCollection() {
    return collection;
  }

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
    if (widget.title["Title"] != null) {
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
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.title["User"],
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Creator: ${widget.title["Creator"]}',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.title["Dueby"]
                          .toDate()
                          .toString()
                          .substring(0, 10),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: <Widget>[
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
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: 50,
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }
  }
}
