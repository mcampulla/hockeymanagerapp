import 'dart:convert';
import 'package:http/http.dart' as http;
import 'tournament.dart';
import 'match.dart';
import 'year.dart';

class ManagerService {
  final String api = "https://hockey-manager-api.azurewebsites.net";

  Future<List<Year>> getYears() async {
    final response = await http.get(Uri.parse('$api/odata/years'));

    if (response.statusCode == 200) {
      var value = jsonDecode(response.body)['value'].map((i) => Year.fromJson(i));
      return List<Year>.from(value);
    } else {
      throw Exception('Failed to load years');
    }
  }

  Future<Year> getYear(int id) async {
    final response = await http.get(Uri.parse('$api/odata/years/$id'));

    if (response.statusCode == 200) {
      return Year.fromJson(jsonDecode(response.body)['value'][0]);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Tournament>> getTournaments(int id) async {
    final response = await http.get(Uri.parse('$api/odata/tournaments?\$filter=yearid eq $id'));

    if (response.statusCode == 200) {
      var value = jsonDecode(response.body)['value'].map((i) => Tournament.fromJson(i));
      return List<Tournament>.from(value);
    } else {
      throw Exception('Failed to load tournament');
    }
  }

  Future<Tournament> getTournament(int id) async {
    final response = await http.get(Uri.parse('$api/odata/tournaments/$id'));

    if (response.statusCode == 200) {
      return Tournament.fromJson(jsonDecode(response.body)['value'][0]);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Match>> getMatches(int id) async {
    final response = await http.get(Uri.parse('$api/odata/matches?\$filter=tournamentid eq $id&\$expand=homeclub,awayclub'));

    if (response.statusCode == 200) {
      var value = jsonDecode(response.body)['value'].map((i) => Match.fromJson(i));
      List<Match> a = List<Match>.from(value);
      return a;
    } else {
      throw Exception('Failed to load matches');
    }
  }

  Future<List<Phase>> getPhases(int id) async {
    final response = await http.get(Uri.parse('$api/odata/tournamentphases?\$filter=tournamentid eq $id&\$expand=matchdays'));

    if (response.statusCode == 200) {
      var value = jsonDecode(response.body)['value'].map((i) => Phase.fromJson(i));
      List<Phase> a = List<Phase>.from(value);
      return a;
    } else {
      throw Exception('Failed to load tournament phases');
    }
  }

  Future<List<Matchday>> getMatchdays(int id) async {
    final response = await http.get(Uri.parse('$api/odata/tournamentmatchdays?\$filter=tournamentphaseid eq $id&\$expand=matches(\$expand=homeclub,awayclub)'));

    if (response.statusCode == 200) {
      var value = jsonDecode(response.body)['value'].map((i) => Matchday.fromJson(i));
      List<Matchday> a = List<Matchday>.from(value);
      return a;
    } else {
      throw Exception('Failed to load matchdays');
    }
  }

  Future<List<Match>> getMatchesByPhase(int pid) async {
    final response = await http.get(Uri.parse('$api/odata/matches?\$filter=TournamentMatchday/TournamentPhaseID eq $pid&\$expand=HomeClub,AwayClub'));

    if (response.statusCode == 200) {
      var value = jsonDecode(response.body)['value'].map((i) => Match.fromJson(i));
      List<Match> a = List<Match>.from(value);
      return a;
    } else {
      throw Exception('Failed to load match by phase');
    }
  }

  Future<List<MatchStat>> getMatchStatsByPhase(int pid) async {
    final response = await http.get(Uri.parse('$api/odata/matchstats?\$filter=match/tournamentmatchday/tournamentphaseid eq $pid&\$expand=player,match(\$expand=tournamentmatchday)'));

    if (response.statusCode == 200) {
      var value = jsonDecode(response.body)['value'].map((i) => MatchStat.fromJson(i));
      List<MatchStat> a = List<MatchStat>.from(value);
      return a;
    } else {
      throw Exception('Failed to load match by phase');
    }
  }
}
