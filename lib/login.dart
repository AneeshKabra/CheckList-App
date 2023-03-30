import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'collections.dart';
import 'register.dart';

class login extends StatefulWidget {
  static const id = 'login';

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  late String email;
  late String pwd;

  void login_() {
    Navigator.pushNamed(context, list.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('LOGIN'),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter email',
              ),
              onChanged: (value) {
                setState(() {
                  email = value.trim();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter password',
              ),
              onChanged: (value) {
                setState(() {
                  pwd = value.trim();
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance
                    .signInWithEmailAndPassword(email: email, password: pwd);
                login_();
              } on FirebaseAuthException catch (e) {
                print(e);
                if (e.code == 'too-many-requests') {
                  Fluttertoast.showToast(
                    msg: 'Too many requests, please try later',
                  );
                } else if (e.code == 'wrong-password') {
                  Fluttertoast.showToast(
                    msg: 'Wrong Email/Password',
                  );
                } else if (e.code == 'user-not-found') {
                  Fluttertoast.showToast(
                    msg: 'No user found with this Email-ID',
                  );
                } else if (e.code == 'invalid-email') {
                  Fluttertoast.showToast(
                    msg: 'Invailed Email ID',
                  );
                } else if (e.code == 'unknown') {
                  Fluttertoast.showToast(
                    msg: 'Please enter the values',
                  );
                } else if (e.code == 'network-request-failed') {
                  Fluttertoast.showToast(
                    msg: 'Internet Connection Required',
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: e.toString(),
                  );
                }
              } catch (e) {
                print(e);
                if (e.runtimeType.toString() == 'LateError') {
                  Fluttertoast.showToast(
                    msg: 'Please enter all the values',
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: e.toString(),
                  );
                }
              }
            },
            child: Text('Sign In'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, register.id);
            },
            child: const Text(
              'Sign Up',
            ),
          ),
        ],
      ),
    );
  }
}
