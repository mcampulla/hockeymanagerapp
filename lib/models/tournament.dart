import 'package:ghosts/models/category.dart';
import 'package:ghosts/models/club.dart';
import 'package:ghosts/models/match.dart';
import 'package:ghosts/models/year.dart';

class Tournament {
  int id = 0;
  String name = '';
  Year year = Year(id: 0, name: '', dateStart: DateTime.now(), dateEnd: DateTime.now(), isCurrent: false);
  int yearid = 0;
  Category category = Category(id: 0, name: '', tag: '', isenabled: false);
  int categoryid = 0;
  int periodnumber = 0;
  int periodlength = 0;
  int overtimenumber = 0;
  int overtimelength = 0;
  int drawpoint = 0;
  int winpoint = 0;
  int bonuspoint = 0;
  int status = 0;

  Tournament();
  Tournament.init({required this.id, required this.name, required this.yearid, required this.categoryid, 
    required this.periodnumber, required this.periodlength, required this.overtimenumber, 
    required this.overtimelength, required this.drawpoint, required this.winpoint, 
    required this.bonuspoint, required this.status});

  factory Tournament.fromJson(Map<String, dynamic> json) {
    var value = json; // json['value'][0];
    Tournament tournament = Tournament.init(
      id: value['ID'],
      name: value['Name'],
      yearid: value['YearID'],
      categoryid: value['CategoryID'],
      periodnumber: value['PeriodNumber'],
      periodlength: value['PeriodLength'],
      overtimenumber: value['OvertimeNumber'],
      overtimelength: value['OvertimeLength'],
      drawpoint: value['DrawPoint'],
      winpoint: value['WinPoint'],
      bonuspoint: value['BonusPoint'],
      status: value['Status']
    );
    if (value['Year'] != null)
      tournament.year = Year.fromJson(value['Year']);
    if (value['Category'] != null)
      tournament.category = Category.fromJson(value['Category']);
    return tournament;
  }
}

class Phase {
  int id;
  String name;
  Tournament? tournament;
  int tournamentid;
  int type;
  List<Matchday> matchdays = [];

  Phase({required this.id, required this.name, required this.tournamentid, required this.type});

  factory Phase.fromJson(Map<String, dynamic> json) {
    var value = json;
    Phase phase = Phase(
      id: value['ID'],
      name: value['Name'],
      tournamentid: value['TournamentID'],
      type: value['Type']
    );
    if (value['Tournament'] != null)
      phase.tournament = Tournament.fromJson(value['Tournament']);
    if (value['Matchdays'] != null)
      phase.matchdays = List<Matchday>.from(value['Matchdays'].map((i) => Matchday.fromJson(i)));
    return phase;
  }
}

class Matchday {
  int id;
  String name;
  Phase? phase;
  int phaseid;
  int round;
  String roundname;
  DateTime date;
  List<Match> matches = [];

  Matchday({required this.id, required this.name, required this.phaseid, required this.round,
    required this.roundname, required this.date});

  factory Matchday.fromJson(Map<String, dynamic> json) {
    var value = json;
    Matchday matchday = Matchday(
      id: value['ID'],
      name: value['Name'],
      phaseid: value['TournamentPhaseID'],
      round: value['Round'],
      roundname: value['RoundName'],
      date: DateTime.parse(value['Date']),
    );
    if (value['TournamentPhase'] != null)
      matchday.phase = Phase.fromJson(value['TournamentPhase']);
    if (value['Matches'] != null)
      matchday.matches = List<Match>.from(value['Matches'].map((i) => Match.fromJson(i)));
    return matchday;
  }
}

class TournamentClub {
  int id;
  Tournament? tournament;
  int tournamentid;
  Club? club;
  int clubid;

  TournamentClub({required this.id, required this.tournamentid, required this.clubid});

  factory TournamentClub.fromJson(Map<String, dynamic> json) {
    var value = json;
    TournamentClub tournamenclub = TournamentClub(
      id: value['ID'],
      tournamentid: value['TournamentID'],
      clubid: value['ClubID']
    );
    if (value['Tournament'] != null)
      tournamenclub.tournament = Tournament.fromJson(value['Tournament']);
    if (value['Club'] != null)
      tournamenclub.club = Club.fromJson(value['Club']);
    return tournamenclub;
  }
}