import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/playerchartscreen.dart';
import 'package:flutter_application_1/screens/playerstatscreen.dart';
import 'package:flutter_application_1/screens/teamchartscreen.dart';

import 'models/setuplocator.dart';
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
        '/': (context) => SeasonListScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/playerchart': (context) => PlayerChartScreen(0),
        '/playerstat': (context) => PlayerStatScreen(0),
        '/teamchart': (context) => TeamChartScreen(0),
        '/seasonlist': (context) => SeasonListScreen(),
        '/seasondetail': (context) => SeasonDetailScreen(1),
      },
    )
  );
}
