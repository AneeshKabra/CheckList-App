import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class register extends StatefulWidget {
  static const id = 'register';

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final _auth = FirebaseAuth.instance;

  late String username;
  late String email;
  late String pwd;
  late List list1;

  Future<List> name() async {
    List list = [];
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var user in value.docs) {
        list.add(user.data()["Name"]);
      }
    });
    return list;
  }

  void return_() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text(
          'REGISTER',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  username = value.trim();
                });
              },
              decoration: const InputDecoration(
                hintText: 'Enter Username',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  email = value.trim();
                });
              },
              decoration: const InputDecoration(
                hintText: 'Enter Email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  pwd = value.trim();
                });
              },
              decoration: const InputDecoration(
                hintText: 'Enter Password',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              list1 = await name();
              try {
                if (list1.contains(username)) {
                  Fluttertoast.showToast(
                      msg: "Please Change Username or Password",
                      toastLength: Toast.LENGTH_LONG);
                } else {
                  final user = await _auth.createUserWithEmailAndPassword(
                      email: email, password: pwd);
                  await _auth.signInWithEmailAndPassword(
                      email: email, password: pwd);
                  final User user1 = _auth.currentUser!;

                  final _firebase =
                      FirebaseFirestore.instance.collection('users');
                  final json = {
                    'Name': username,
                    'User-ID': user1.uid,
                    'Collections': [],
                    "Email": email,
                  };
                  await _firebase.doc(user1.uid).set(json);
                  await _auth.signOut();
                  return_();
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  Fluttertoast.showToast(
                    msg:
                        'Weak Password\n Password should have at least 6 characters.',
                  );
                } else if (e.code == 'email-already-in-use') {
                  Fluttertoast.showToast(
                    msg: 'Email-ID has already been used',
                  );
                } else if (e.code == 'invalid-email') {
                  Fluttertoast.showToast(
                    msg: 'Please enter a valid Email-ID',
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: e.code,
                  );
                }
              } catch (e) {
                if (e.runtimeType.toString() == 'LateError') {
                  Fluttertoast.showToast(
                    msg: 'Please enter all the values.',
                  );
                }
              }
            },
            child: const Text(
              'Sign Up',
            ),
          )
        ],
      ),
    ));
  }
}
