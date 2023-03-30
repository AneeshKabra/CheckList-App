import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'home4.dart' as home4;
import 'home3.dart' as home3;

class add_task extends StatefulWidget {
  static const id = 'add task';

  @override
  State<add_task> createState() => _add_taskState();
}

class _add_taskState extends State<add_task> {
  late String task;
  late Timestamp dueby;
  late String user;
  late String progress;
  late String priority;

  TextEditingController dateinput = TextEditingController();
  @override
  void initState() {
    dateinput.text = "";
    super.initState();
  }

  void return_() {
    Navigator.pop(context);
  }

  Future<void> sendemail({
    required String from_name,
    required String to_name,
    required String user_email,
    required String reply_to,
    required String message1,
    required String message2,
    required String message3,
    required String message4,
  }) async {
    final url = Uri.parse(
      'https://api.emailjs.com/api/v1.0/email/send',
    );
    final response = await http.post(url,
        headers: {
          'origin': 'https://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'service_id': 'service_7kq05jo',
            'template_id': 'template_2jijc6y',
            'user_id': 'aFugyS_d_7n5oB0qF',
            'template_params': {
              'from_name': from_name,
              'to_name': to_name,
              'message1': message1,
              'message2': message2,
              'message3': message3,
              'message4': message4,
              'user_email': user_email,
              'reply_to': reply_to,
            },
          },
        ));
    print(response.body);
  }

  List<String> priority_list = ['Urgent', 'Important', 'Medium', 'Low'];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as home3.Arguments;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              'ADD TASK',
            ),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(args.Collection)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<String> users = [];
            List<String> task_name = [];
            List<String> label_list = [];
            if (snapshot.hasData) {
              final labels = snapshot.data;
              if (labels != null) {
                for (var label in labels.docs) {
                  if (label.data()["Progress"] == null) {
                    for (int i = 0; i < label.data()["Users"].length; i++) {
                      users.add(
                        label.data()!["Users"][i].toString(),
                      );
                    }
                  } else {
                    label_list.add(
                      label.data()["Progress"].toString(),
                    );
                    for (int i = 0; i < label.data()["Tasks"].length; i++) {
                      task_name.add(
                        label
                            .data()["Tasks"][i]["Title"]
                            .toString()
                            .toUpperCase(),
                      );
                    }
                  }
                }
              }
            }
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        task = value.trim();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter Task',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: SizedBox(
                    height: 45.0,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        hintText: 'Choose Priority',
                      ),
                      items: priority_list
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          priority = val as String;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: SizedBox(
                    height: 45.0,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        hintText: 'Choose Progress',
                      ),
                      items: label_list
                          .map(
                            (String e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          progress = val as String;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: SizedBox(
                    height: 45.0,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        hintText: 'Assign to a User',
                      ),
                      items: users
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          user = val as String;
                        });
                      },
                    ),
                  ),
                ),
                TextField(
                  controller: dateinput, //editing controller of this TextField
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.calendar_today,
                    ), //icon of text field
                    labelText: "Enter Date", //label text of field
                  ),
                  onTap: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      firstDate: DateTime(2000),
                    );
                    if (date != null) {
                      dateinput.text = DateFormat('yyyy-MM-dd').format(date);
                      setState(() {
                        dueby = Timestamp.fromDate(date);
                      });
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (task == '') {
                        Fluttertoast.showToast(msg: 'Please enter task name,');
                      } else {
                        if (task_name.contains(task.toUpperCase())) {
                          Fluttertoast.showToast(
                              msg: 'Task with that name already exists');
                        } else {
                          final data = await FirebaseFirestore.instance
                              .collection(args.Collection)
                              .doc(progress)
                              .get()
                              .then((value) {
                            return value.data()!["Tasks"];
                          });
                          final creator = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .get()
                              .then((value) {
                            return [
                              value.data()!["Name"],
                              value.data()!["Email"]
                            ];
                          });
                          data.add({
                            "Title": task,
                            "Creator": creator[0],
                            "User": user,
                            "Priority": priority,
                            "Dueby": dueby,
                          });
                          await FirebaseFirestore.instance
                              .collection(args.Collection)
                              .doc(progress)
                              .update({
                            "Tasks": data,
                          });
                          final recipient = await FirebaseFirestore.instance
                              .collection('users')
                              .get()
                              .then((value) {
                            for (var val in value.docs) {
                              if (val.data()["Name"] == user) {
                                return val.data()["Email"];
                              }
                            }
                          });
                          sendemail(
                            from_name: creator[0],
                            to_name: user,
                            user_email: recipient,
                            reply_to: creator[1],
                            message1: 'Task: $task',
                            message2: 'Progress: $progress',
                            message3: 'Priority: $priority',
                            message4: 'Dueby: ${dueby.toDate()}',
                          );
                          return_();
                        }
                      }
                    } catch (e) {
                      if (e.runtimeType.toString() == 'LateError') {
                        Fluttertoast.showToast(
                            msg: 'Please enter all the values');
                      } else {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    }
                  },
                  child: const Text(
                    'Add Task',
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
