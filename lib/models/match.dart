import 'package:ghosts/models/club.dart';
import 'package:ghosts/models/player.dart';

class Match {
  int id = 0;
  String matchcode = '';
  Club homeclub = Club(id:0, name: '', tag: '', icon: '');
  int homeclubid = 0;
  int homescore = 0;
  Club awayclub = Club(id:0, name: '', tag: '', icon: '');
  int awayclubid = 0;
  int awayscore = 0;
  DateTime matchdate = DateTime.now();
  int matchstatus = 0;
  bool isot = false;
  bool ispenalty = false;

  Match();
  Match.init({required this.id, required this.matchcode, required this.homescore, 
    required this.awayscore, required this.matchdate, required this.matchstatus, 
    required this.isot, required this.ispenalty, required this.homeclubid, required this.awayclubid});

  factory Match.fromJson(Map<String, dynamic> json) {
    var value = json;
    Match match = Match.init(  
      id: value['ID'],
      matchcode: value['MatchCode'],
      homeclubid: value['HomeClubID'], 
      homescore: value['HomeScore'],
      awayclubid: value['AwayClubID'],
      awayscore: value['AwayScore'],
      matchdate: DateTime.parse(value['MatchDate']),
      matchstatus: value['MatchStatus'],
      isot: value['IsOT'],
      ispenalty: value['IsPenalty']
    );
    if (value['HomeClub'] != null)
      match.homeclub = Club.fromJson(value['HomeClub']);
    if (value['AwayClub'] != null)
      match.awayclub = Club.fromJson(value['AwayClub']);
    return match;
  }
}

class MatchEvent {
  int id;
  String comment = '';
  int period;
  int minute;
  int second;
  int icon;
  Match? match;
  int matchid;
  Player? player;
  int playerid;
  int playernumber;
  Club? club;
  int clubid;
  DateTime dateassigned;
  DateTime? datestart;
  DateTime? dateend;
  DateTime? dateout;
  int? duration;
  int? penaltyid;
  Player? assistplayer;
  int? assistplayerid;
  int? assistnumber;

  MatchEvent({required this.id, required this.period, required this.minute,  required this.second,
    required this.icon, required this.matchid, required this.playerid, required this.playernumber,
    required this.clubid, required this.dateassigned, this.datestart, this.dateend, this.dateout,
    this.duration, this.penaltyid, this.assistplayerid, this.assistnumber});

  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    var value = json;
    MatchEvent match = MatchEvent(  
      id: value['ID'],
      period: value['Period'],
      minute: value['Minute'], 
      second: value['Second'],
      icon: value['Icon'],
      matchid: value['MatchID'],
      playerid: value['PlayerID'],
      playernumber: value['PlayerNumber'],
      clubid: value['ClubID'],
      dateassigned: DateTime.parse(value['DateAssigned']),
      datestart: DateTime.parse(value['DateDtart']),
      dateend: DateTime.parse(value['DateEnd']),
      dateout: DateTime.parse(value['DateOut']),
      duration: value['Duration'],
      penaltyid: value['PenaltyID'],
      assistplayerid: value['AssistPlayerID'],
      assistnumber: value['AssistNumber']
    );
    match.player = Player.fromJson(value['Player']);
    match.match = Match.fromJson(value['Match']);
    return match;
  }
}

class MatchStat {
  int id = 0;
  int goal = 0;
  int assist = 0;
  int shootin = 0;
  int shootout = 0;
  int faceoffwon = 0;
  int faceofflost = 0;
  int puckwon = 0;
  int pucklost = 0;
  int penalty = 0;
  int penaltywon = 0;
  int plus = 0;
  int minus = 0;
  int score = 0;
  Match match = Match();
  int matchid = 0;
  Player player = Player();
  int playerid = 0;
  int playernumber = 0;
  int matchnumber = 0;

  MatchStat();
  MatchStat.init({required this.id, required this.goal, required this.assist, required this.shootin,
    required this.shootout, required this.faceoffwon, required this.faceofflost, required this.puckwon,
    required this.pucklost, required this.penalty, required this.penaltywon, required this.plus, 
    required this.minus, required this.matchid, required this.playerid, required this.playernumber});

  factory MatchStat.fromJson(Map<String, dynamic> json) {
    var value = json;
    MatchStat match = MatchStat.init(  
      id: value['ID'],
      goal: value['Goal'],
      assist: value['Assist'], 
      shootin: value['ShootIn'],
      shootout: value['ShootOut'],
      faceoffwon: value['FaceOffWon'],
      faceofflost: value['FaceOffLost'],
      puckwon: value['PuckWon'],
      pucklost: value['PuckLost'],
      penalty: value['Penalty'],
      penaltywon: value['PenaltyWon'],
      plus: value['Plus'],
      minus: value['Minus'],
      matchid: value['MatchID'],
      playerid: value['PlayerID'],
      playernumber: value['PlayerNumber']
    );
    match.player = Player.fromJson(value['Player']);
    match.match = Match.fromJson(value['Match']);
    return match;
  }
}