import 'package:checklist/home3.dart';

import 'add_label.dart';
import 'collections.dart';
import 'delete_coll.dart';
import 'delete_label.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'add task.dart';
import 'home2.dart';
import 'tasklist.dart';
import 'add_collections.dart';
import 'add_user.dart';
import 'edit_task.dart';
import 'delete_task.dart';
import 'home4.dart';
import 'delete_task2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(checklist());
}

class checklist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: login.id,
      routes: {
        login.id: (context) => login(),
        register.id: (context) => register(),
        homepage.id: (context) => homepage(),
        add_task.id: (context) => add_task(),
        tasklist.id: (context) => tasklist(),
        list.id: (context) => list(),
        add_col.id: (context) => add_col(),
        add_user.id: (context) => add_user(),
        add_label.id: (context) => add_label(),
        delete_label.id: (context) => delete_label(),
        edit_task.id: (context) => edit_task(),
        delete_task.id: (context) => delete_task(),
        delete_coll.id: (context) => delete_coll(),
        home3.id: (context) => home3(),
        home.id: (context) => home(),
        delete_task2.id: (context) => delete_task2(),
      },
    );
  }
}
