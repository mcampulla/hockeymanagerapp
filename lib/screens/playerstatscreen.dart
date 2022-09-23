import 'package:flutter/material.dart';
import 'package:ghosts/models/chart.dart';
import 'package:ghosts/models/manager.service.dart';
import 'package:ghosts/models/match.dart';
import 'package:ghosts/models/player.dart';
import 'package:ghosts/models/setuplocator.dart';
import 'package:ghosts/models/tournament.dart';
import 'package:ghosts/screens/playerchartscreen.dart';
import 'package:ghosts/screens/playerdetailscreen.dart';
import 'package:ghosts/screens/seasondetailscreen.dart';
import 'package:ghosts/screens/teamchartscreen.dart';
import 'package:ghosts/widget/player.dart';

class PlayerStatScreen extends StatefulWidget {
  final int tournamentid;
  final int id; //phase
  PlayerStatScreen(this.tournamentid, this.id);

  @override
  _PlayerStatScreenState createState() => _PlayerStatScreenState();
}

class _PlayerStatScreenState extends State<PlayerStatScreen> {
  List<PlayerChart> charts = [];
  List<MatchStat> stats = [];
  Tournament tournament = Tournament();
  List<Phase> phases = [];
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
        if (data.length != 0 && widget.id == 0) {
          this.currentPhase = data[0].id;
        } else {
          currentPhase = widget.id;
        }
      });
      manager.getMatchStatsByPhase(currentPhase).then((data) {
        setState(() {
          this.stats = data;
          charts = getPlayerCharts(stats);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Statistiche"),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.calendar_view_month_outlined), label: 'Stagione'),
            BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Classifica'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Giocatori'),
            BottomNavigationBarItem(icon: Icon(Icons.add_chart_outlined), label: 'Statistiche')
          ],
          currentIndex: 3,
          //selectedItemColor: Colors.amber[800],
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.orange.shade300,  
          onTap: (int index) {
            print(index.toString());
            switch (index) {
              case 0:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SeasonDetailScreen(widget.tournamentid, 0)));
                break;
              case 1:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeamChartScreen(widget.tournamentid, widget.id)));
                break;
              case 2:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlayerChartScreen(widget.tournamentid, widget.id)));
                break;
              case 3:
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlayerStatScreen(widget.tournamentid, widget.id)));
                break;
              default:
            }              
          },
        ),
        body: ListView(
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
                      manager.getMatchStatsByPhase(shape).then((data) {
                        setState(() {
                          currentPhase = shape ?? 0;
                          stats = data;
                          charts = getPlayerCharts(stats);
                        });
                      });
                    }),
                ],),
              ),
            _createDataTable(),
        ])
      );
  }

  Widget _createDataTable() {
    List<Widget> list = charts.map((e) =>     
        GestureDetector(
          child: PlayerItem(e),
          onTap: () => Navigator.push(context, 
              MaterialPageRoute(builder: (context) => PlayerDetailScreen(currentPhase, e.id))
          ))
      ).toList();
    return Column(children: list);
  }

  PlayerChart getPlayerChart(List<PlayerChart> charts, Player player) {
    PlayerChart pc;
    List<PlayerChart> arr = charts.where((t) => t.id == player.id).toList();
    if (arr.length == 0) {
      pc = PlayerChart();
      pc.id = player.id;
      pc.name = '${player.lastname} ${player.firstname}';
      pc.icon = player.photo;
      charts.add(pc);
    } else {
      pc = arr[0];
    }
    return pc;
  }

  List<PlayerChart> getPlayerCharts(List<MatchStat> stats)  {
    List<PlayerChart> charts = [];
    PlayerChart pc;

    for (MatchStat m in stats) {  
      if(m.player.role != 0){    
        pc = getPlayerChart(charts, m.player);
        pc.played += 1;
        pc.point += m.goal + m.assist;
        pc.goal += m.goal;
        pc.assist += m.assist;
        pc.shootin += m.shootin;
        pc.shootout += m.shootout;
        pc.faceoffwon += m.faceoffwon;
        pc.faceofflost += m.faceofflost;
        pc.puckwon += m.puckwon;
        pc.pucklost += m.pucklost;
        pc.penalty += m.penalty;
        pc.penaltywon += m.penaltywon;
        pc.minus += m.minus;
        pc.plus += m.plus;
      }
    }
    charts.sort((a, b) => (b.point.compareTo(a.point)));
    return charts;
  }
}


