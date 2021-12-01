import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:june_3d/june_3d.dart';
import 'package:june_3d_example/page_view_simple.dart';

import 'digital_flop_sample.dart';
import 'fb_switch_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> items = <String>['1', '2', '3', '4', '5'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
            color: Colors.black12,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FBSwitcherDemo(),
                  const DigitalSimple(),
                  const PageViewSimple(),
                ],
              ),
            )),
      ),
    );
  }
}
