import 'package:flutter/material.dart';
import '../models/manager.service.dart';
import '../models/setuplocator.dart';


class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var manager;

  @override
  void initState() {
    super.initState();
    manager = locator<ManagerService>();
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Center(child: Text("v 1.0.2"))
    );
  }
}
