import 'package:flutter_application_1/models/club.dart';

class Match {
  final int id;
  final String matchcode;
  final Club homeclub;
  final int homeclubid;
  final int homescore;
  final Club awayclub;
  final int awayclubid;
  final int awayscore;
  final DateTime matchdate;
  final int matchstatus;
  final bool isot;
  final bool ispenalty;

  Match({required this.id, required this.matchcode, required this.homescore, 
    required this.awayscore, required this.matchdate, required this.matchstatus, 
    required this.isot, required this.ispenalty, required this.homeclubid, required this.awayclubid,
    required this.homeclub, required this.awayclub});

  factory Match.fromJson(Map<String, dynamic> json) {
    var value = json; // json['value'][0];
    //print(value['MatchDate']);
    return Match(  
      id: value['ID'],
      matchcode: value['MatchCode'],
      homeclub: Club.fromJson(value['HomeClub']),
      homeclubid: value['HomeClubID'], 
      homescore: value['HomeScore'],
      awayclub: Club.fromJson(value['AwayClub']),
      awayclubid: value['AwayClubID'],
      awayscore: value['AwayScore'],
      matchdate: DateTime.parse(value['MatchDate']),
      matchstatus: value['MatchStatus'],
      isot: value['IsOT'],
      ispenalty: value['IsPenalty']
    );
  }
}