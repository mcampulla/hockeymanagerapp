import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/playerchartscreen.dart';
import 'package:flutter_application_1/screens/playerstatscreen.dart';
import 'package:flutter_application_1/screens/teamchartscreen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/models/manager.service.dart';
import 'package:flutter_application_1/models/setuplocator.dart';
import 'package:flutter_application_1/models/tournament.dart';
import 'package:flutter_application_1/models/match.dart';
import 'package:flutter_application_1/models/settings.dart';

class SeasonDetailScreen extends StatefulWidget {
  final int id;
  SeasonDetailScreen(this.id);

  @override
  _SeasonDetailScreenState createState() => _SeasonDetailScreenState();
}

class _SeasonDetailScreenState extends State<SeasonDetailScreen> {
  late Future<Tournament> futureTournament;
  List<Phase> phases = [];
  late Future<List<Matchday>> futureMatchdays;
  late Future<List<Match>> futureMatches;
  int currentPhase = 0;
  var manager;

  @override
  void initState() {
    super.initState();
    manager = locator<ManagerService>();
    futureTournament = manager.getTournament(widget.id);
    manager.getPhases(widget.id).then((data) {
      setState(() {
        this.phases = data;
        if (data.length != 0) {
          this.currentPhase = data[0].id;
          futureMatchdays = manager.getMatchdays(currentPhase);
        }
      });
    });
    futureMatchdays = manager.getMatchdays(currentPhase);
    futureMatches = manager.getMatches(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Partite"),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Classifica'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Giocatori'),
            BottomNavigationBarItem(icon: Icon(Icons.add_chart_outlined), label: 'Statistiche')
          ],
          onTap: (int index) {
            print(index.toString());
            switch (index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (context) => TeamChartScreen(currentPhase)));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerChartScreen(currentPhase)));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerStatScreen(currentPhase)));
                break;
              default:
            }              
          },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
              child: FutureBuilder<Tournament>(
            future: futureTournament,
            builder: (context, snapshot) {
              //print(snapshot.data);
              if (snapshot.hasData) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(snapshot.data!.id.toString()),
                      Text(snapshot.data!.name),
                    ]);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          )),
          Center(
            child: DropdownButton<int>(
                value: currentPhase,
                items: phases.map((Phase value) {
                  return new DropdownMenuItem<int>(
                    value: value.id,
                    child: Text(
                      value.name,
                      style: TextStyle(fontSize: 24.0),
                    ),
                  );
                }).toList(),
                onChanged: (shape) {
                  print(shape);
                  setState(() {
                    currentPhase = shape ?? 0;
                    futureMatchdays = manager.getMatchdays(currentPhase);
                  });
                }),
          ),
          Expanded(child: MatchdayList(futureMatchdays)),
          // ElevatedButton(
          //   // Within the `FirstScreen` widget
          //   onPressed: () {
          //     // Navigate to the second screen using a named route.
          //     Navigator.pop(context);
          //   },
          //   child: Text('Back'),
          // )
        ],
      ),
    );
  }
}

class MatchdayList extends StatelessWidget {
  final Future items;

  @override
  MatchdayList(this.items);

  @override
  Widget build(BuildContext context) {
    //  return Text("aas");
    return FutureBuilder(
        future: items,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.length);
            return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = snapshot.data[index];
                  return Column(children: addMatches(item));
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

List<Widget> addMatches(Matchday mday) {
  List<Widget> matches = [];

  matches.add(
    Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        height: 30,
        decoration: BoxDecoration(color: Color.fromARGB(255, 120, 120, 120)),
        child: Container(
          margin: EdgeInsets.all(5),
          child: Text(mday.name, style: TextStyle(color: Colors.white70 ),))),
  );
  for (Match item in mday.matches) {
    matches.add(Container(
        margin: EdgeInsets.all(5.0),
        height: 100,
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Center(child: MatchItem(item))));
  }
  return matches;
}

// class MatchList extends StatelessWidget {
//   final List<Match> items;

//   @override
//   MatchList(this.items);

//   @override
//   Widget build(BuildContext context) {
//     //  return Text("aas");
//     if (items.length == 0) {
//       return Text('no data');
//     } else {
//       print(items.length);
//       return ListView.builder(
//         padding: EdgeInsets.all(8),
//         itemCount: items.length,
//         itemBuilder: (BuildContext context, int index) {
//           var item = items[index];
//           return Container(
//               margin: EdgeInsets.all(5.0),
//               height: 100,
//               decoration: BoxDecoration(
//                   color: Color.fromARGB(240, 120, 120, 120)),
//               child: Center(
//                       child: MatchItem(item)
//                   ));
//         });
//     }
//   }
// }

class MatchItem extends StatelessWidget {
  final Match item;

  @override
  MatchItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      MatchItemClub(item.homeclub.icon, item.homeclub.tag),
      MatchItemScore(item),
      MatchItemClub(item.awayclub.icon, item.awayclub.tag),
    ]);
  }
}

class MatchItemClub extends StatelessWidget {
  final String icon;
  final String tag;
  final String url = Settings().imageurl;

  @override
  MatchItemClub(this.icon, this.tag);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          width: 30,
          height: 30,
          //color: Colors.grey[300],
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage('$url$icon'), fit: BoxFit.cover))),
      Text(tag)
    ]);
  }
}

class MatchItemScore extends StatelessWidget {
  final Match item;

  @override
  MatchItemScore(this.item);

  @override
  Widget build(BuildContext context) {
    final hs = item.homescore;
    final as = item.awayscore;
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        '$hs - $as',
        style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      ),
      Text(formatter.format(item.matchdate))
    ]);
  }
}
