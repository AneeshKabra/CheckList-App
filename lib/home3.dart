import 'package:checklist/tasklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import 'delete_task.dart';
import 'add_user.dart';
import 'add%20task.dart';
import 'collections.dart';
import 'edit_task.dart';

class home3 extends StatefulWidget {
  static const id = 'home3';
  @override
  State<home3> createState() => _home3State();
}

class _home3State extends State<home3> {
  int _selectedIndex = 0;
  late String label;
  List<BottomNavigationBarItem> _navbar = [];
  late int n;

  void return_() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Args;

    List<String> _navBar2 = [];
    _navbar = _navBar2.map((e) {
      return BottomNavigationBarItem(
        backgroundColor: Colors.black,
        label: e,
        icon: const Icon(
          Icons.home,
        ),
      );
    }).toList();

    n = _navbar.length;
    int count = 0;
    if (_selectedIndex != n - 1) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(args.title),
            centerTitle: false,
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
                icon: const Icon(
                  Icons.add,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    add_task.id,
                    arguments: Arguments(
                      args.title,
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    delete_task.id,
                    arguments: Arg(
                      args.title,
                      _navBar2[_selectedIndex],
                    ),
                  );
                },
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedIconTheme: const IconThemeData(
              opacity: 0.0,
              size: 0,
            ),
            unselectedIconTheme: const IconThemeData(
              opacity: 0.0,
              size: 0,
            ),
            showSelectedLabels: false,
            showUnselectedLabels: true,
            backgroundColor: Colors.black,
            items: _navbar,
            onTap: (int index) {
              setState(() {
                print(_navBar2[_selectedIndex]);
                print(_selectedIndex);
                _selectedIndex = index;
                print(_selectedIndex);
                print(_navBar2[_selectedIndex]);
                print(_navBar2.toString());
              });
            },
            currentIndex: _selectedIndex,
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(args.title)
                .doc(_navBar2[_selectedIndex])
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(_navBar2[_selectedIndex]);
              print(_navBar2.toString());
              List list = [];
              if (snapshot.hasData) {
                final data = snapshot.data;
                if (data != null) {
                  list = [args.title, data.data()["Progress"]];
                  count = data.data()["Tasks"].length;
                  for (int i = 0; i < data.data()["Tasks"].length; i++) {
                    final Map<String, dynamic> title1 = data.data()["Tasks"][i];
                    list.add(title1);
                  }
                }
              }
              return ListView(
                scrollDirection: Axis.vertical,
                children: list.map((e) {
                  if (e == args.title) {
                    return const SizedBox();
                  } else if (e == _navBar2[_selectedIndex]) {
                    if (_selectedIndex == 0) {
                      return SwipeTo(
                          onRightSwipe: () {
                            setState(() {
                              _selectedIndex += 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.teal,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(
                                      5.0,
                                      5.0,
                                    ), //Offset
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ), //BoxShadow
                                ],
                              ),
                              height: 50.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Center(
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      child: Text('$count'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    } else {
                      return SwipeTo(
                        onRightSwipe: () {
                          setState(() {
                            _selectedIndex += 1;
                          });
                        },
                        onLeftSwipe: () {
                          setState(() {
                            _selectedIndex -= 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.teal,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(
                                    5.0,
                                    5.0,
                                  ), //Offset
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ), //BoxShadow
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ), //BoxShadow
                              ],
                            ),
                            height: 50.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Center(
                                    child: Text(
                                      e,
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Text('$count'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  } else {
                    return SwipeTo(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: tasktile(
                          title: e,
                          collection: list[0],
                          label: list[1],
                        ),
                      ),
                      onRightSwipe: () async {
                        if (_selectedIndex != n - 2) {
                          final data = await FirebaseFirestore.instance
                              .collection(args.title)
                              .doc(_navBar2[_selectedIndex])
                              .get()
                              .then((value) => value.data()!["Tasks"]);
                          final data1 = await FirebaseFirestore.instance
                              .collection(args.title)
                              .doc(_navBar2[_selectedIndex + 1])
                              .get()
                              .then((value) => value.data()!["Tasks"]);
                          for (int i = 0; i < data.length; i++) {
                            if (data[i]["Title"] == e["Title"]) {
                              data.removeAt(i);
                              data1.add(e);
                              break;
                            }
                          }
                          await FirebaseFirestore.instance
                              .collection(args.title)
                              .doc(_navBar2[_selectedIndex])
                              .update({"Tasks": data});

                          await FirebaseFirestore.instance
                              .collection(args.title)
                              .doc(_navBar2[_selectedIndex + 1])
                              .update({"Tasks": data1});
                          setState(() {
                            _selectedIndex += 1;
                          });
                        }
                      },
                    );
                  }
                }).toList(),
              );
            },
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Center(
              child: Text('Add Label'),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedIconTheme: const IconThemeData(opacity: 0.0, size: 0),
            unselectedIconTheme: const IconThemeData(opacity: 0.0, size: 0),
            showUnselectedLabels: true,
            showSelectedLabels: false,
            backgroundColor: Colors.black,
            items: _navbar,
            onTap: (int index) {
              setState(() {
                print(_navBar2[_selectedIndex]);
                print(_selectedIndex);
                _selectedIndex = index;
                print(_selectedIndex);
                print(_navBar2[_selectedIndex]);
              });
            },
            currentIndex: _selectedIndex,
          ),
          body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection(args.title).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List list = [];
              if (snapshot.hasData) {
                final labels = snapshot.data;
                for (var label in labels.docs) {
                  if (label.data()["Progress"] != null) {
                    list.add(
                      label.data()["Progress"].toString().toUpperCase(),
                    );
                  }
                }
              }
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter Label',
                      ),
                      onChanged: (value) {
                        setState(() {
                          label = value.trim();
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        print(n);
                        print(_selectedIndex);
                        print(_navBar2[_selectedIndex]);
                        if (list.contains(label.toUpperCase())) {
                          Fluttertoast.showToast(
                            msg:
                                'This name is already in use. \n Please enter a new name',
                          );
                        } else if (label == '') {
                          Fluttertoast.showToast(
                            msg: 'Please enter a name',
                          );
                        } else {
                          await FirebaseFirestore.instance
                              .collection(args.title)
                              .doc(label)
                              .set({
                            "Progress": label,
                            "Tasks": [],
                          });
                          List<String> data = await FirebaseFirestore.instance
                              .collection(args.title)
                              .doc(label)
                              .get()
                              .then((value) => value.data()!["Docs"]);
                          data.insert(n - 1, label);
                          print(data.toString());
                          print(123);
                          await FirebaseFirestore.instance
                              .collection(args.title)
                              .doc("Documents")
                              .update({
                            "Docs": data,
                          });
                          setState(() {
                            print(n);
                            print(_selectedIndex);
                            print(_navBar2[_selectedIndex]);
                          });
                        }
                      } catch (e) {
                        if (e.runtimeType.toString() == 'LateError') {
                          Fluttertoast.showToast(
                            msg: 'Please enter the label name',
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Submit',
                    ),
                  )
                ],
              );
            },
          ));
    }
  }
}

class Arguments {
  final String Collection;
  Arguments(this.Collection);
}

class Arg extends Arguments {
  final String label;
  final String Collection;
  Arg(this.Collection, this.label) : super(Collection);
}

class tasktile extends StatefulWidget {
  tasktile({
    required this.title,
    required this.collection,
    required this.label,
  });
  Map<String, dynamic> title;
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
                        icon: const Icon(
                          Icons.edit,
                        ),
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
