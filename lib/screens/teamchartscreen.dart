import 'package:flutter/material.dart';
import 'package:ghosts/models/club.dart';
import 'package:ghosts/models/manager.service.dart';
import 'package:ghosts/models/settings.dart';
import 'package:ghosts/models/setuplocator.dart';
import 'package:ghosts/models/match.dart';
import 'package:ghosts/models/chart.dart';
import 'package:ghosts/models/tournament.dart';
import 'package:ghosts/screens/playerchartscreen.dart';
import 'package:ghosts/screens/playerstatscreen.dart';
import 'package:ghosts/screens/seasondetailscreen.dart';

class TeamChartScreen extends StatefulWidget {
  final int tournamentid;
  final int id;  //phase
  TeamChartScreen(this.tournamentid, this.id);

  @override
  _TeamChartScreenState createState() => _TeamChartScreenState();
}

class _TeamChartScreenState extends State<TeamChartScreen> {
  List<Match> matches = [];
  List<TeamChart> charts = [];
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
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
    });
    manager.getMatchesByPhase(widget.id).then((data) {
      setState(() {
        this.matches = data;
        charts = getTeamCharts(matches);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Classifica"),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.calendar_view_month_outlined), label: 'Stagione'),
            BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Classifica'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Giocatori'),
            BottomNavigationBarItem(icon: Icon(Icons.add_chart_outlined), label: 'Statistiche')
          ],
          currentIndex: 1,
          //selectedItemColor: Colors.amber[800],
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.orange.shade300,  
          onTap: (int index) {
            print(index.toString());
            switch (index) {
              case 0:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SeasonDetailScreen(widget.tournamentid, currentPhase)));
                break;
              case 1:
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeamChartScreen(currentPhase)));
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
                    manager.getMatchesByPhase(shape).then((data) {
                      setState(() {
                        currentPhase = shape ?? 0;
                        this.matches = data;
                        charts = getTeamCharts(matches);
                      });
                    });
                  }),
              ],),
            ),
            currentPhase != 0 ? 
            _createDataTable() : Center(child: CircularProgressIndicator())
          ],
        ),);
  }

  Widget _createDataTable() {
    return SingleChildScrollView(scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: _createColumns(), 
        rows: _createRows(),
        sortColumnIndex: _currentSortColumn,
        sortAscending: _isSortAsc,
      ));
  }

  List<DataColumn> _createColumns() {
    return [
       DataColumn(label: Text('#')),
       DataColumn(label: Text('Team')),
      _createColumn('P'),
      _createColumn('G'),
      _createColumn('V'),
      _createColumn('VOT'),
      _createColumn('D'),
      _createColumn('LOT'),
      _createColumn('L'),
      _createColumn('GF'),
      _createColumn('GA'),
      _createColumn('GD'),
    ];
  }

  DataColumn _createColumn(String label) {
    return DataColumn(label: Text(label),
      onSort: (columnIndex, _) {
        setState(() {
          if(_currentSortColumn != columnIndex)
            _isSortAsc = true;
          _currentSortColumn = columnIndex;
          switch (label) {
            case 'P':
              charts.sort((a, b) => b.point.compareTo(a.point)*(_isSortAsc ? 1 : -1));  
              break;
            case 'G':
              charts.sort((a, b) => b.played.compareTo(a.played)*(_isSortAsc ? 1 : -1));  
              break;
            case 'V':
              charts.sort((a, b) => b.win.compareTo(a.win)*(_isSortAsc ? 1 : -1));  
              break;
            case 'VOT':
              charts.sort((a, b) => b.winot.compareTo(a.winot)*(_isSortAsc ? 1 : -1));  
              break;
            case 'D':
              charts.sort((a, b) => b.draw.compareTo(a.draw)*(_isSortAsc ? 1 : -1));  
              break;
            case 'LOT':
              charts.sort((a, b) => b.lossot.compareTo(a.lossot)*(_isSortAsc ? 1 : -1));  
              break;
            case 'L':
              charts.sort((a, b) => b.loss.compareTo(a.loss)*(_isSortAsc ? 1 : -1));  
              break;              
            case 'GF':
              charts.sort((a, b) => b.goalfor.compareTo(a.goalfor)*(_isSortAsc ? 1 : -1));  
              break;
            case 'GA':
              charts.sort((a, b) => b.goalagainst.compareTo(a.goalagainst)*(_isSortAsc ? 1 : -1));  
              break;
            case 'GD':
              charts.sort((a, b) => b.goaldiff.compareTo(a.goaldiff)*(_isSortAsc ? 1 : -1));  
              break;           
            default:
          }
          _isSortAsc = !_isSortAsc;
        });
    });
  }

  List<DataRow> _createRows() {
    final String url = Settings().imageurl;

    List<DataRow> rows = [];
    //List<TeamChart> charts = getTeamCharts(matches);
    int i = 1;
    for (var c in charts) {
      rows.add(DataRow(cells: [
        DataCell(Text('$i')),
        DataCell(Row(children: [
          Container(
          width: 30,
          height: 30,
          //color: Colors.grey[300],
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage('$url${c.icon}'), fit: BoxFit.cover))),
          Text('${c.name}')
        ])),
        DataCell(Text('${c.point}')),
        DataCell(Text('${c.played}')),
        DataCell(Text('${c.win}')),
        DataCell(Text('${c.winot}')),
        DataCell(Text('${c.draw}')),
        DataCell(Text('${c.lossot}')),
        DataCell(Text('${c.loss}')), 
        DataCell(Text('${c.goalfor}')),
        DataCell(Text('${c.goalagainst}')),
        DataCell(Text('${c.goaldiff}'))
      ]));
      i++;
    }
    return rows;
  }
  
  TeamChart getTeamChart(List<TeamChart> charts, Club club) {
    TeamChart tc;
    List<TeamChart> arr = charts.where((t) => t.id == club.id).toList();
    if (arr.length == 0) {
      tc = TeamChart();
      tc.id = club.id;
      tc.name = club.name;
      tc.icon = club.icon;
      charts.add(tc);
    } else {
      tc = arr[0];
    }
    return tc;
  }

  List<TeamChart> getTeamCharts(List<Match> matches)  {
    List<TeamChart> charts = [];
    TeamChart htc;
    TeamChart atc;

    for (Match m in matches) {      
      htc = getTeamChart(charts, m.homeclub);
      atc = getTeamChart(charts, m.awayclub);
      if (m.matchstatus == 3) {
        if (m.homescore > m.awayscore) {
          htc.point += 3;
          if (m.isot || m.ispenalty) {
            htc.point -= 1;
            atc.point += 1;
            htc.winot += 1;
            atc.lossot += 1;
          } else {
            htc.win += 1;
            atc.loss += 1;
          }
        }
        if (m.homescore < m.awayscore) {
          atc.point += 3;
          if (m.isot || m.ispenalty) {
            atc.point -= 1;
            htc.point += 1;
            atc.winot += 1;
            htc.lossot += 1;
          } else {
            htc.loss += 1;
            atc.win += 1;
          }
        }
        if (m.homescore == m.awayscore) {
          atc.point += 1;
          htc.point += 1;
          htc.draw += 1;
          atc.draw += 1;
        }
        htc.played += 1;
        htc.goalfor += m.homescore;
        htc.goalagainst += m.awayscore;
        htc.goaldiff += m.homescore - m.awayscore;
        atc.played += 1;
        atc.goalfor += m.awayscore;
        atc.goalagainst += m.homescore;
        atc.goaldiff += m.awayscore - m.homescore;
      }
    }
    charts.sort((a, b) => (b.point.compareTo(a.point)));
    return charts;
  }

}
