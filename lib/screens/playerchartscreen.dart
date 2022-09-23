import 'package:flutter/material.dart';
import 'package:ghosts/models/setuplocator.dart';
import 'package:ghosts/models/manager.service.dart';
import 'package:ghosts/models/player.dart';
import 'package:ghosts/models/match.dart';
import 'package:ghosts/models/chart.dart';
import 'package:ghosts/models/tournament.dart';
import 'package:ghosts/screens/playerdetailscreen.dart';
import 'package:ghosts/screens/playerstatscreen.dart';
import 'package:ghosts/screens/seasondetailscreen.dart';
import 'package:ghosts/screens/teamchartscreen.dart';

class PlayerChartScreen extends StatefulWidget {
  final int tournamentid;
  final int id;
  PlayerChartScreen(this.tournamentid, this.id);

  @override
  _PlayerChartScreenState createState() => _PlayerChartScreenState();
}

class _PlayerChartScreenState extends State<PlayerChartScreen> {
  Tournament tournament = Tournament();
  List<MatchStat> stats = [];
  List<PlayerChart> charts = [];
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
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
        manager.getMatchStatsByPhase(currentPhase).then((data) {
          setState(() {
            stats = data;
            charts = getPlayerCharts(stats);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Classifica giocatori"),
        ),
         bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.calendar_view_month_outlined), label: 'Stagione'),
            BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Classifica'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Giocatori'),
            BottomNavigationBarItem(icon: Icon(Icons.add_chart_outlined), label: 'Statistiche')
          ],
          currentIndex: 2,
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeamChartScreen(widget.tournamentid, currentPhase)));
                break;
              case 2:
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlayerChartScreen(widget.id)));
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
      DataColumn(label: Text('Giocatore')),
      _createColumn('P'),
      _createColumn('G'),
      _createColumn('A'),
      _createColumn('SI'),
      _createColumn('SO'),
      _createColumn('FW'),
      _createColumn('FL'),
      _createColumn('PW'),
      _createColumn('PL'),
      _createColumn('PE'),
      _createColumn('P+'),
      _createColumn('+'),
      _createColumn('-')     
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
              charts.sort((a, b) => b.goal.compareTo(a.goal)*(_isSortAsc ? 1 : -1));  
              break;
            case 'A':
              charts.sort((a, b) => b.assist.compareTo(a.assist)*(_isSortAsc ? 1 : -1));  
              break;
            case 'SI':
              charts.sort((a, b) => b.shootin.compareTo(a.shootin)*(_isSortAsc ? 1 : -1));  
              break;
            case 'SO':
              charts.sort((a, b) => b.shootout.compareTo(a.shootout)*(_isSortAsc ? 1 : -1));  
              break;
            case 'FW':
              charts.sort((a, b) => b.faceoffwon.compareTo(a.faceoffwon)*(_isSortAsc ? 1 : -1));  
              break;
            case 'FL':
              charts.sort((a, b) => b.faceofflost.compareTo(a.faceofflost)*(_isSortAsc ? 1 : -1));  
              break;
            case 'PW':
              charts.sort((a, b) => b.puckwon.compareTo(a.puckwon)*(_isSortAsc ? 1 : -1));  
              break;
            case 'PL':
              charts.sort((a, b) => b.pucklost.compareTo(a.pucklost)*(_isSortAsc ? 1 : -1));  
              break;
            case 'PE':
              charts.sort((a, b) => b.penalty.compareTo(a.penalty)*(_isSortAsc ? 1 : -1));  
              break;
            case 'P+':
              charts.sort((a, b) => b.penaltywon.compareTo(a.penaltywon)*(_isSortAsc ? 1 : -1));  
              break;
            case '+':
              charts.sort((a, b) => b.plus.compareTo(a.plus)*(_isSortAsc ? 1 : -1));  
              break;
            case '-':
              charts.sort((a, b) => b.minus.compareTo(a.minus)*(_isSortAsc ? 1 : -1));  
              break;
            default:
          }
          _isSortAsc = !_isSortAsc;
        });
      });
  }

  List<DataRow> _createRows() {
    List<DataRow> rows = [];
    for (var c in charts) {
      rows.add(DataRow(cells: [
        DataCell(GestureDetector(
          child: Text('${c.name.toUpperCase()}')),
          onTap: () => Navigator.push(context, 
            MaterialPageRoute(builder: (context) => PlayerDetailScreen(currentPhase, c.id))
        )),
        DataCell(Text('${c.point}')),
        DataCell(Text('${c.goal}')),
        DataCell(Text('${c.assist}')),
        DataCell(Text('${c.shootin}')),
        DataCell(Text('${c.shootout}')),
        DataCell(Text('${c.faceoffwon}')),
        DataCell(Text('${c.faceofflost}')),
        DataCell(Text('${c.puckwon}')), 
        DataCell(Text('${c.pucklost}')),
        DataCell(Text('${c.penalty}')),
        DataCell(Text('${c.penaltywon}')),
        DataCell(Text('${c.plus}')),
        DataCell(Text('${c.minus}'))
      ]));
    }
    return rows;
  }
  
  PlayerChart getPlayerChart(List<PlayerChart> charts, Player player) {
    PlayerChart pc;
    List<PlayerChart> arr = charts.where((t) => t.id == player.id).toList();
    if (arr.length == 0) {
      pc = PlayerChart();
      pc.id = player.id;
      pc.name = '${player.lastname} ${player.firstname}';
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
