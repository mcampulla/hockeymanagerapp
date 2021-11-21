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

}



  // Future getYears2() async {
  //   final response = await http
  //     .get(Uri.parse('$api/odata/years'));

  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     //var value =
  //     var value =
  //         jsonDecode(response.body)['value'].map((i) => Year.fromJson(i));
  //     return value.toList();
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load album');
  //   }
  // }