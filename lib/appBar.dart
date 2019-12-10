import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

Widget myAppBar([String title = 'Quiz App']) => AppBar(
        title: FittedBox(fit: BoxFit.fitWidth, child: Text(title)),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Site\n Admin',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              var fbAuth = fb.auth();
              var provider = fb.GoogleAuthProvider();
              try {
                await fbAuth.signInWithPopup(provider);
              } catch (e) {
                print("Error in sign in with google: $e");
              }
            },
          ),
        ]);
