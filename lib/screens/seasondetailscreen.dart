import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/manager.service.dart';
import 'package:flutter_application_1/models/setuplocator.dart';
import 'package:flutter_application_1/models/tournament.dart';
import 'package:flutter_application_1/models/match.dart';
import 'package:intl/intl.dart';

class SeasonDetailScreen extends StatefulWidget {
  final int id;
  SeasonDetailScreen(this.id);

  @override
  _SeasonDetailScreenState createState() => _SeasonDetailScreenState();
}

class _SeasonDetailScreenState extends State<SeasonDetailScreen> {
  late Future<Tournament> futureTournament;
  late Future<List<Match>> futureMatches;

  @override
  void initState() {
    super.initState();
    var manager = locator<ManagerService>();
    futureTournament = manager.getTournament(widget.id);
    futureMatches = manager.getMatches(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final sizeY = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Partite"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 1,
              child: Center(
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
              ))),
          Expanded(
              flex: 18,
              child: Container(
                  //height: sizeY-300,
                  child: MatchList(futureMatches))),
          Expanded(
              flex: 1,
              child: ElevatedButton(
                // Within the `FirstScreen` widget
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  Navigator.pop(context);
                },
                child: Text('Back'),
              ))
        ],
      ),
    );
  }
}

class MatchList extends StatelessWidget {
  final Future items;

  @override
  MatchList(this.items);

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
                  return Container(
                      margin: EdgeInsets.all(5.0),
                      height: 100,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(240, 120, 120, 120)),
                      child: Center(
                              child: MatchItem(item)
                          ));
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class MatchItem extends StatelessWidget {
  final Match item;

  @override
  MatchItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MatchItemClub(item.homeclub.icon, item.homeclub.tag),
        MatchItemScore(item),
        MatchItemClub(item.awayclub.icon, item.awayclub.tag),
      ]
    );
  }
}

class MatchItemClub extends StatelessWidget {
  final String icon;
  final String tag;

  @override
  MatchItemClub(this.icon, this.tag);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          //color: Colors.grey[300],
          decoration: BoxDecoration(image: 
            DecorationImage(image: NetworkImage('https://hockey-manager-api.azurewebsites.net/$icon'),
            fit: BoxFit.cover))
        ),
        Text(tag)
      ]
    );
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$hs - $as', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),),
        Text(formatter.format(item.matchdate))        
      ]
    );
  }
}