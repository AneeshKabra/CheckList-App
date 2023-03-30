import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home4.dart' as home4;
import 'home3.dart' as home3;

class add_label extends StatefulWidget {
  static const String id = 'add-label';

  @override
  State<add_label> createState() => _add_labelState();
}

class _add_labelState extends State<add_label> {
  late String label;
  void return_() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as home3.Arguments;
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Add Label'),
            centerTitle: true,
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(args.Collection)
                .snapshots(),
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
                              .collection(args.Collection)
                              .doc(label)
                              .set({
                            "Progress": label,
                            "Tasks": [],
                          });
                          return_();
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
          )),
    );
  }
}
