import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'home4.dart' as home4;
import 'home3.dart' as home3;

class add_user extends StatefulWidget {
  static const String id = 'add-user';
  @override
  State<add_user> createState() => _add_userState();
}

class _add_userState extends State<add_user> {
  late String name;
  late List users_list;

  void return_() {
    Navigator.pop(context);
  }

  Future<void> sendEmail({
    required collection,
    required String from_name,
    required String to_name,
    required String user_email,
    required String reply_to,
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
            'template_id': 'template_52ekd9s',
            'user_id': 'aFugyS_d_7n5oB0qF',
            'template_params': {
              'from_name': from_name,
              'to_name': to_name,
              'user_email': user_email,
              'reply_to': reply_to,
              'collection': collection,
            },
          },
        ));
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as home3.Arguments;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Add User',
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List users_list = [];
          if (snapshot.hasData) {
            final users = snapshot.data;
            if (users != null) {
              for (var user in users.docs) {
                if (user.data()!["Collections"].contains(args.Collection)) {
                  continue;
                } else {
                  users_list.add(user.data()!["Name"]);
                }
              }
            }
          }
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButtonFormField(
                  onChanged: (val) {
                    setState(() {
                      name = val as String;
                    });
                  },
                  items: users_list
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final data1 = await FirebaseFirestore.instance
                        .collection("users")
                        .get()
                        .then((value) {
                      for (var doc in value.docs) {
                        if (name == doc.data()["Name"]) {
                          List l = [
                            doc.data()["Collections"],
                            doc.data()["User-ID"],
                            doc.data()["Email"],
                          ];
                          return l;
                        }
                      }
                    });
                    final creator = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get()
                        .then((value) {
                      return [value.data()!["Name"], value.data()!["Email"]];
                    });
                    final data = await FirebaseFirestore.instance
                        .collection(args.Collection)
                        .doc("Users")
                        .get()
                        .then((value) {
                      return value.data()!['Users'];
                    });
                    data.add(name);
                    List l1 = data1![0];
                    l1.add(args.Collection);
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(data1[1])
                        .update({
                      "Collections": l1,
                    });
                    await FirebaseFirestore.instance
                        .collection(args.Collection)
                        .doc('Users')
                        .update({
                      'Users': data,
                    });
                    sendEmail(
                      collection: args.Collection,
                      from_name: creator[0],
                      to_name: name,
                      user_email: data1[2],
                      reply_to: creator[1],
                    );
                    return_();
                  } catch (e) {
                    if (e.runtimeType.toString() == 'LateError') {
                      Fluttertoast.showToast(
                        msg: 'Please select a user.',
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
      ),
    );
  }
}
