import 'package:flutter/material.dart';
import 'package:ghosts/models/setuplocator.dart';
import 'package:ghosts/models/manager.service.dart';
import 'package:ghosts/models/match.dart';
import 'package:ghosts/models/chart.dart';
import 'package:ghosts/widget/match.dart';
import 'package:ghosts/widget/player.dart';

class PlayerDetailScreen extends StatefulWidget {
  final int tournamentid;
  final int id;
  PlayerDetailScreen(this.tournamentid, this.id);

  @override
  _PlayerDetailScreenState createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> {
  List<MatchStat> stats = [];
  PlayerChart chart = PlayerChart();
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  var manager;

  @override
  void initState() {
    super.initState();
    manager = locator<ManagerService>();
    manager.getMatchStatsByPhase(widget.tournamentid).then((data) {
      setState(() {
        stats = data.where((t) => t.playerid == widget.id).toList();
        chart = getPlayerChart(stats);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dettaglio giocatore"),
        ),
        body: ListView(
          children: [
            PlayerItem(chart),
            _createDataTable()
          ],
        ),);
  }

  Widget _createDataTable() {
    return SingleChildScrollView(scrollDirection: Axis.horizontal,
      child: DataTable(
        dataRowHeight: 70,
        columns: _createColumns(), 
        rows: _createRows(),
        sortColumnIndex: _currentSortColumn,
        sortAscending: _isSortAsc,
      ));
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Partita')),
      DataColumn(label: Text('Data')),
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
              stats.sort((a, b) => (b.goal+b.assist).compareTo(a.goal+a.assist)*(_isSortAsc ? 1 : -1));  
              break;
            case 'G':
              stats.sort((a, b) => b.goal.compareTo(a.goal)*(_isSortAsc ? 1 : -1));  
              break;
            case 'A':
              stats.sort((a, b) => b.assist.compareTo(a.assist)*(_isSortAsc ? 1 : -1));  
              break;
            case 'SI':
              stats.sort((a, b) => b.shootin.compareTo(a.shootin)*(_isSortAsc ? 1 : -1));  
              break;
            case 'SO':
              stats.sort((a, b) => b.shootout.compareTo(a.shootout)*(_isSortAsc ? 1 : -1));  
              break;
            case 'FW':
              stats.sort((a, b) => b.faceoffwon.compareTo(a.faceoffwon)*(_isSortAsc ? 1 : -1));  
              break;
            case 'FL':
              stats.sort((a, b) => b.faceofflost.compareTo(a.faceofflost)*(_isSortAsc ? 1 : -1));  
              break;
            case 'PW':
              stats.sort((a, b) => b.puckwon.compareTo(a.puckwon)*(_isSortAsc ? 1 : -1));  
              break;
            case 'PL':
              stats.sort((a, b) => b.pucklost.compareTo(a.pucklost)*(_isSortAsc ? 1 : -1));  
              break;
            case 'PE':
              stats.sort((a, b) => b.penalty.compareTo(a.penalty)*(_isSortAsc ? 1 : -1));  
              break;
            case 'P+':
              stats.sort((a, b) => b.penaltywon.compareTo(a.penaltywon)*(_isSortAsc ? 1 : -1));  
              break;
            case '+':
              stats.sort((a, b) => b.plus.compareTo(a.plus)*(_isSortAsc ? 1 : -1));  
              break;
            case '-':
              stats.sort((a, b) => b.minus.compareTo(a.minus)*(_isSortAsc ? 1 : -1));  
              break;
            default:
          }
          _isSortAsc = !_isSortAsc;
        });
      });
  }

  List<DataRow> _createRows() {
    List<DataRow> rows = [];
    stats.sort((a, b) => b.match.matchdate.compareTo(a.match.matchdate));
    for (var c in stats) {
      rows.add(DataRow(cells: [
        DataCell(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [MatchItem(c.match, true)])),
        DataCell(MatchItemDate(c.match)),
        DataCell(Text('${c.goal+c.assist}')),
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
  
  PlayerChart getPlayerChart(List<MatchStat> stats)  {
    PlayerChart pc = PlayerChart() ;

    for (MatchStat m in stats) {  
      pc.id = m.player.id;
      pc.name = '${m.player.lastname} ${m.player.firstname}';
      pc.icon = m.player.photo;
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
    return pc;
  }
}
