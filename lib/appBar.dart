import 'package:flutter/material.dart';

Widget myAppBar([String title = 'Quiz App']) => AppBar(
      title: FittedBox(fit: BoxFit.fitWidth, child: Text(title)),
    );
