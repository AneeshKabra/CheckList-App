import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'tasklist.dart';

class edit_task extends StatefulWidget {
  static const String id = 'edit_task';

  @override
  State<edit_task> createState() => _edit_taskState();
}

class _edit_taskState extends State<edit_task> {
  TextEditingController dateinput = TextEditingController();

  @override
  void initState() {
    dateinput.text = "";
    super.initState();
  }

  void return_() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Arguments_edit;
    String task_name = args.name;
    String priority = args.priority;
    Timestamp dueby = args.date;
    String user = args.user;
    String progress = args.label;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Edit Task",
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(args.Collection)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List progress_list = [];
            List users = [];
            List<String> task_names = [];
            if (snapshot.hasData) {
              final labels = snapshot.data;
              if (labels != null) {
                for (var label in labels.docs) {
                  if (label.data()["Progress"] != null) {
                    progress_list.add(label.data()["Progress"]);
                    for (int i = 0; i < label.data()["Tasks"].length; i++) {
                      task_names.add(label.data()["Tasks"][i]["Title"]);
                    }
                  } else {
                    users = label.data()["Users"];
                  }
                }
              }
            }
            task_names.remove(args.name);
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    initialValue: args.name,
                    onChanged: (value) {
                      task_name = value.trim();
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Task',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButtonFormField(
                    value: args.priority,
                    items: [
                      'Urgent',
                      'Important',
                      'Medium',
                      'Low',
                    ]
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      priority = val as String;
                      print(priority);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButtonFormField(
                    value: args.label,
                    items: progress_list
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      progress = val as String;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButtonFormField(
                    value: args.user,
                    items: users
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      user = val as String;
                    },
                  ),
                ),
                TextField(
                  controller: dateinput, //editing controller of this TextField
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Enter Date" //label text of field
                      ),
                  onTap: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: args.date.toDate(),
                      lastDate: DateTime(2100),
                      firstDate: DateTime(2000),
                    );
                    if (date != null) {
                      dateinput.text = DateFormat('yyyy-MM-dd').format(date);

                      dueby = Timestamp.fromDate(date);
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (task_name != '') {
                        if (task_names.contains(task_name)) {
                          Fluttertoast.showToast(
                            msg: 'Task already exists with that name.',
                          );
                        } else {
                          var list = await FirebaseFirestore.instance
                              .collection(args.Collection)
                              .doc(args.label)
                              .get()
                              .then((value) {
                            return value.data()!["Tasks"];
                          });
                          for (var task in list) {
                            if (task["Title"] == args.name) {
                              task["Title"] = task_name;
                              task["User"] = user;
                              task["Dueby"] = dueby;
                              task["Priority"] = priority;
                              if (args.label != progress) {
                                list.remove(task);
                                final list2 = await FirebaseFirestore.instance
                                    .collection(args.Collection)
                                    .doc(progress)
                                    .get()
                                    .then((value) {
                                  return value.data()!["Tasks"];
                                });
                                list2.add(task);

                                await FirebaseFirestore.instance
                                    .collection(args.Collection)
                                    .doc(progress)
                                    .update({"Tasks": list2});
                                break;
                              }
                            }
                          }
                          await FirebaseFirestore.instance
                              .collection(args.Collection)
                              .doc(args.label)
                              .update({"Tasks": list});
                          return_();
                        }
                      } else {
                        Fluttertoast.showToast(msg: 'Please enter a task name');
                      }
                    } catch (e) {
                      print(e);
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  },
                  child: const Text('Edit Task'),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
