import 'package:flutter/material.dart';

class PlayerStatScreen extends StatelessWidget {
  final int id;

  PlayerStatScreen(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("PlayerStatScreen"),
        ),
        body: Center(
          child: Text("PlayerStatScreen - $id"),
        ));
  }
}
