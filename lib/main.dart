import 'package:flutter/material.dart';
import 'package:ghosts/screens/playerchartscreen.dart';
import 'package:ghosts/screens/playerdetailscreen.dart';
import 'package:ghosts/screens/playerstatscreen.dart';
import 'package:ghosts/screens/teamchartscreen.dart';

import 'package:ghosts/models/setuplocator.dart';
import 'package:ghosts/screens/seasondetailscreen.dart';
import 'package:ghosts/screens/seasonlistscreen.dart';

void main() {
  setupLocator();
  runApp(
    MaterialApp(
      title: 'Ghosts Statistics',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => SeasonListScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/playerchart': (context) => PlayerChartScreen(0, 0),
        '/playerstat': (context) => PlayerStatScreen(0, 0),
        '/playerdetail': (context) => PlayerDetailScreen(0, 0),
        '/teamchart': (context) => TeamChartScreen(0, 0),
        '/seasonlist': (context) => SeasonListScreen(),
        '/seasondetail': (context) => SeasonDetailScreen(0, 0),
      },
    )
  );
}
