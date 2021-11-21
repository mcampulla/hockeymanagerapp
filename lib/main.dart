import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/setuplocator.dart';
import 'screens/homescreen.dart';
import 'screens/playerlistscreen.dart';
import 'screens/seasondetailscreen.dart';
import 'screens/seasonlistscreen.dart';

void main() {
  setupLocator();
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => HomeScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/playerlist': (context) => PlayerListScreen(),
        '/seasonlist': (context) => SeasonListScreen(),
        '/seasondetail': (context) => SeasonDetailScreen(1),
      },
    )
  );
}
