import 'package:flutter/material.dart';
import 'package:ghosts/models/chart.dart';
import 'package:ghosts/models/settings.dart';

class PlayerItem extends StatelessWidget {
  final PlayerChart item;

  @override
  PlayerItem(this.item);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Container(
      height: 450,
      child: Column(children: [
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(color: Colors.grey.shade800),
        child: Text(item.name.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        Container(
          width: size/4.1*2,
          height: 196,          
          margin: EdgeInsets.symmetric(horizontal: 2.0),
          decoration: item.icon != '' ? BoxDecoration(image: DecorationImage(
            alignment: Alignment(-1.0, -1.0),
            image: NetworkImage('${Settings().imageurl}${item.icon}'), 
            fit: BoxFit.cover)) : BoxDecoration(color: Colors.grey.shade400)
        ),
        Column(children: [
          Row(children: [
            PlayerItemData(item.goal.toString(), 'Goal', size/4.2),
            PlayerItemData(item.assist.toString(), 'Assist', size/4.2)
          ],),
          Row(children: [
            PlayerItemData(item.penalty.toString(), 'Penalty', size/4.2),
            PlayerItemData(item.penaltywon.toString(), 'Pen. Won', size/4.2),
          ],)
        ],)
      ],),
      Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        PlayerItemData(item.plus.toString(), 'Plus', size/4.2),
        PlayerItemData(item.minus.toString(), 'Minus', size/4.2),
        PlayerItemData((item.plus-item.minus).toString(), '+/-', size/4.2),
        PlayerItemData(item.played.toString(), 'Played', size/4.2),
      ],)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        PlayerItemData(getPercentage(item.faceoffwon, item.faceofflost), 'Faceoff ${item.faceoffwon}/${item.faceofflost}', size/3.1),
        PlayerItemData(getPercentage(item.shootin, item.shootout), 'Shoot ${item.shootin}/${item.shootout}', size/3.1),
        PlayerItemData(getPercentage(item.puckwon, item.pucklost), 'Puck ${item.puckwon}/${item.pucklost}', size/3.1),
      ],)
    ]));
  }

  String getPercentage(int a, int b) {
    print('$a $b');
    if (a == 0 || b == 0)
      return '0%';
    else {
      print((100*(a/(a+b))).toInt());
      int perc = (100*(a/(a+b))).toInt();
      return '$perc%';
    }
  }
}

class PlayerItemData extends StatelessWidget {
  final String value;
  final String text;
  final double size;
  final String color = '';

  @override
  PlayerItemData(this.value, this.text, this.size);

  @override
  Widget build(BuildContext context) {
    return SizedBox(      
      height: 100, child: Container(
        margin: EdgeInsets.all(2),
        child: Column(
      children: [
      Expanded(child: Container( 
        width: size,
        decoration: BoxDecoration(color: Colors.grey.shade400),
        child: Center(child: Text(value, style: TextStyle(fontSize: 40),)))),
      Container(    
        width: size,    
        height: 30,
        decoration: BoxDecoration(color: Colors.grey.shade800),
        child: Center(child: Text(text, style: TextStyle(color: Colors.white),)))
    ])));
  }
}