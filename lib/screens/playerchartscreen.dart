import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/setuplocator.dart';
import 'package:flutter_application_1/models/manager.service.dart';
import 'package:flutter_application_1/models/player.dart';
import 'package:flutter_application_1/models/match.dart';
import 'package:flutter_application_1/models/chart.dart';

class PlayerChartScreen extends StatefulWidget {
  final int id;
  PlayerChartScreen(this.id);

  @override
  _PlayerChartScreenState createState() => _PlayerChartScreenState();
}

class _PlayerChartScreenState extends State<PlayerChartScreen> {
  List<MatchStat> stats = [];
  List<PlayerChart> charts = [];
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  var manager;

  @override
  void initState() {
    super.initState();
    manager = locator<ManagerService>();
    manager.getMatchStatsByPhase(widget.id).then((data) {
      setState(() {
        stats = data;
        charts = getPlayerCharts(stats);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("PlayerChartScreen"),
        ),
        body: ListView(
          children: [
            _createDataTable()
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
      DataColumn(label: Text('Player')),
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
        DataCell(Text('${c.name}')),
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
