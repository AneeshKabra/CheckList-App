import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';

import 'tasklist.dart';
import 'collections.dart';
import 'add_label.dart';
import 'delete_label.dart';
import 'add_user.dart';
import 'edit_task.dart';
import 'add%20task.dart';

class homepage extends StatefulWidget {
  static const id = 'home2';

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Args;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.title,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                add_user.id,
                arguments: Arguments(args.title),
              );
            },
            child: const Text(
              'Add User',
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                add_task.id,
                arguments: Arguments(args.title),
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
                delete_label.id,
                arguments: Arguments(args.title),
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
          List<taskwidget> TaskWidget = [];
          List<task_landscape> TaskWidget_landscape = [];

          num count = 0;
          num count1 = 0;
          if (snapshot.hasData) {
            final labels = snapshot.data;
            if (labels != null) {
              for (var label in labels.docs) {
                if (label.data() != null) {
                  if (label.data()["Progress"] != null) {
                    count += label.data()["Tasks"].length;
                    count1 = label.data()["Tasks"].length;
                    List<tasktile> tasks = [
                      tasktile(
                        title: const {},
                        collection: args.title,
                        label: label.data()["Progress"],
                      ),
                    ];
                    for (int i = 0; i < count1; i++) {
                      tasks.add(
                        tasktile(
                          title: label.data()["Tasks"][i],
                          collection: args.title,
                          label: label.data()["Progress"],
                        ),
                      );
                    }

                    TaskWidget_landscape.add(
                      task_landscape(
                        list: tasks,
                      ),
                    );
                    //TaskWidget_landscape.add(
                    //task_landscape(list: tasks),
                    //);
                    TaskWidget.add(
                      taskwidget(
                        Collection: args.title,
                        label: label.data()["Progress"],
                        count: label.data()!["Tasks"].length,
                      ),
                    );
                  }
                }
              }
            }
          }
          TaskWidget.insert(
            0,
            taskwidget(
              Collection: args.title,
              label: 'All',
              count: count,
            ),
          );
          TaskWidget.add(
            taskwidget(
              Collection: args.title,
              label: 'Add Label',
              count: 0,
            ),
          );
          return OrientationBuilder(builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return ListView(
                reverse: false,
                children: TaskWidget_landscape.reversed.toList(),
              );
            } else {
              List<DragAndDropList> _content = DragAndDropList(
                children: TaskWidget_landscape.reversed
                    .toList()
                    .map(
                      (e) => DragAndDropItem(
                        child: e,
                      ),
                    )
                    .toList(),
              ) as List<DragAndDropList>;
              return SizedBox(
                  width: 400.0,
                  height: 400.0,
                  child: DragAndDropLists(
                    onItemReorder: (int oldItemIndex, int oldListIndex,
                        int newItemIndex, int newListIndex) {
                      var movedItem = _content[oldListIndex]
                          .children
                          .removeAt(oldItemIndex);
                      _content[newListIndex]
                          .children
                          .insert(newListIndex, movedItem);
                    },
                    onListReorder: (int oldListIndex, int newListIndex) {
                      var movedList = _content.removeAt(oldListIndex);
                      _content.insert(newListIndex, movedList);
                    },
                    children: _content,
                    axis: Axis.horizontal,
                  ));
            }
          });
        },
      ),
    );
  }
}

class taskwidget extends StatelessWidget {
  taskwidget({
    required this.Collection,
    required this.label,
    required this.count,
  });
  final String Collection;
  final String label;
  final num count;

  Widget getcount() {
    if (label != 'Add Label') {
      return Text('$count');
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (label != 'Add Label') {
          Navigator.pushNamed(
            context,
            tasklist.id,
            arguments: Arg(Collection, label),
          );
        } else {
          Navigator.pushNamed(
            context,
            add_label.id,
            arguments: Arguments(Collection),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          getcount(),
        ],
      ),
    );
  }
}

class Arg extends Arguments {
  final String label;
  final String Collection;
  Arg(this.Collection, this.label) : super(Collection);
}

class Arguments {
  final String Collection;
  Arguments(this.Collection);
}

class task_landscape extends StatefulWidget {
  task_landscape({
    required this.list,
  });
  final List<Widget> list;
  @override
  State<task_landscape> createState() => _task_landscapeState();
}

class _task_landscapeState extends State<task_landscape> {
  late List<DragAndDropList> _content;

  void initState() {
    super.initState();
    _content = List.generate(1, (index) {
      return DragAndDropList(
        children: widget.list.map((e) {
          return DragAndDropItem(child: e);
        }).toList(),
        header: Text('Header $index'),
      );
    });
  }

  _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex,
      int newListIndex) async {
    setState(() {
      var movedItem = _content[oldListIndex].children.removeAt(oldItemIndex);
      _content[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _content.removeAt(oldListIndex);
      _content.insert(newListIndex, movedList);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.list.toString());
    print(_content.toList().toString());
    return SizedBox(
        width: 400.0,
        height: 400.0,
        child: DragAndDropLists(
          children: _content,
          onItemReorder: _onItemReorder,
          onListReorder: _onListReorder,
          listPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          itemDivider: const Divider(
            thickness: 2,
            height: 2,
          ),
          itemDecorationWhileDragging: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
        ));
  }
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

  String getCollection() {
    return widget.collection;
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
