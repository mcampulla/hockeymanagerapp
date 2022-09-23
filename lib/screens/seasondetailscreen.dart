import 'package:flutter/material.dart';
import 'package:ghosts/screens/playerchartscreen.dart';
import 'package:ghosts/screens/playerstatscreen.dart';
import 'package:ghosts/screens/teamchartscreen.dart';
import 'package:ghosts/models/manager.service.dart';
import 'package:ghosts/models/setuplocator.dart';
import 'package:ghosts/models/tournament.dart';
import 'package:ghosts/models/match.dart';
import 'package:ghosts/widget/match.dart';

class SeasonDetailScreen extends StatefulWidget {
  final int tournamentid;
  final int phaseid;
  SeasonDetailScreen(this.tournamentid, this.phaseid);

  @override
  _SeasonDetailScreenState createState() => _SeasonDetailScreenState();
}

class _SeasonDetailScreenState extends State<SeasonDetailScreen> {
  Tournament tournament = Tournament();
  List<Phase> phases = [];
  late Future<List<Matchday>> futureMatchdays;
  late Future<List<Match>> futureMatches;
  int currentPhase = 0;
  var manager;

  @override
  void initState() {
    super.initState();
    manager = locator<ManagerService>();
    manager.getTournament(widget.tournamentid).then((data) {
      setState(() {
        this.tournament = data;
      });
    });
    manager.getPhases(widget.tournamentid).then((data) {
      setState(() {
        this.phases = data;
        if (data.length != 0) {
          if(widget.phaseid == 0) {
            this.currentPhase = data[0].id;
          } else {
            this.currentPhase = widget.phaseid;
          }
          futureMatchdays = manager.getMatchdays(currentPhase);
        }
      });
    });
    futureMatchdays = manager.getMatchdays(currentPhase);
    futureMatches = manager.getMatches(widget.tournamentid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Partite"),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.calendar_view_month_outlined), label: 'Stagione'),
            BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Classifica'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Giocatori'),
            BottomNavigationBarItem(icon: Icon(Icons.add_chart_outlined), label: 'Statistiche')
          ],
          currentIndex: 0,
          //selectedItemColor: Colors.amber[800],
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.orange.shade300,  
          onTap: (int index) {
            switch (index) {
              case 0:
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SeasonDetailScreen(currentPhase)));
                break;
              case 1:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeamChartScreen(widget.tournamentid, currentPhase)));
                break;
              case 2:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlayerChartScreen(widget.tournamentid, currentPhase)));
                break;
              case 3:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlayerStatScreen(widget.tournamentid, currentPhase)));
                break;
              default:
            }              
          },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(tournament.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
                DropdownButton<int>(
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

            ],),
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
        height: 110,
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Center(child: MatchItem(item, false))));
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


