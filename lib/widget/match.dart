import 'package:flutter/material.dart';
import 'package:ghosts/models/settings.dart';
import 'package:ghosts/models/match.dart';
import 'package:intl/intl.dart';

class MatchItem extends StatelessWidget {
  final Match item;
  final bool isSmall;
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

  @override
  MatchItem(this.item, this.isSmall);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          MatchItemClub(item.homeclub.icon, item.homeclub.tag, isSmall),
          MatchItemScore(item, isSmall),
          MatchItemClub(item.awayclub.icon, item.awayclub.tag, isSmall),
        ]),
      if (!isSmall)  
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade400
        ),
        child: Center(child: Text(formatter.format(item.matchdate), 
          style: TextStyle(fontSize: 12),)))
    ]);
  }
}

class MatchItemClub extends StatelessWidget {
  final String icon;
  final String tag;
  final String url = Settings().imageurl;
  final bool isSmall;

  @override
  MatchItemClub(this.icon, this.tag, this.isSmall);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          width: isSmall ? 40 : 60,
          height: isSmall ? 40 : 60,
          margin: EdgeInsetsDirectional.all(isSmall ? 2 : 5),
          //color: Colors.grey[300],
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage('$url$icon'), fit: BoxFit.cover))),
      Text(tag, style: TextStyle(fontSize: isSmall ? 12 : 16, fontWeight: FontWeight.bold),)
    ]);
  }
}

class MatchItemScore extends StatelessWidget {
  final Match item;
  final bool isSmall;

  @override
  MatchItemScore(this.item, this.isSmall);

  @override
  Widget build(BuildContext context) {
    final hs = item.homescore;
    final as = item.awayscore;
   
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        '$hs - $as',
        style: TextStyle(fontSize: isSmall ? 24 : 48, fontWeight: FontWeight.bold),
      )
    ]);
  }
}

class MatchItemDate extends StatelessWidget {
  final Match item;

  @override
  MatchItemDate(this.item);

  @override
  Widget build(BuildContext context) { 
    return Container(
      margin: EdgeInsets.only(top:2.0, bottom: 2.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(DateFormat('yyyy').format(item.matchdate), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      Text(DateFormat('dd').format(item.matchdate), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      Text(DateFormat('MMM').format(item.matchdate), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    ]));
  }
}