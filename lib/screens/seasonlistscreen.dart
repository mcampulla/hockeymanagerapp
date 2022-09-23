import 'package:flutter/material.dart';
import 'package:ghosts/models/manager.service.dart';
import 'package:ghosts/models/settings.dart';
import 'package:ghosts/models/setuplocator.dart';
import 'package:ghosts/models/tournament.dart';
import 'package:ghosts/models/year.dart';
import 'package:ghosts/screens/seasondetailscreen.dart';
import 'package:ghosts/screens/settingscreen.dart';

class SeasonListScreen extends StatefulWidget {
  SeasonListScreen({Key? key}) : super(key: key);

  @override
  _SeasonListState createState() => _SeasonListState();
}

class _SeasonListState extends State<SeasonListScreen> {
  late Future<List<Year>> futureYears;
  late Future<List<Tournament>> futureTournaments;
  int currentYear = Settings.favyear;
  var manager;

  @override
  void initState() {
    super.initState();
    manager = locator<ManagerService>();
    futureYears = manager.getYears();
    futureTournaments = manager.getTournaments(currentYear);
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
        appBar: AppBar(
          title: Text("Tornei"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
              },
            )
        ],      
        ),
        body: 
          Container(
            // decoration:
            // BoxDecoration(
            //   image: DecorationImage(
            //     image: NetworkImage("https://scontent.fqpa3-2.fna.fbcdn.net/v/t1.6435-9/43397684_2378975292142162_2317381267055706112_n.jpg?_nc_cat=103&ccb=1-5&_nc_sid=174925&_nc_ohc=Ezk6rzNdd9EAX8yy7qj&_nc_ht=scontent.fqpa3-2.fna&oh=3a5c02f72cac723ed7666fb1c3815b12&oe=61BE249F"),
            //     fit: BoxFit.contain,
            //   ),
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
              children: [
                FutureBuilder<List<Year>> (
                    future: futureYears,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        //List<Year> years = snapshot.data as List<Year>;
                        return Center(child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        Text('Stagione:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        Center(child: DropdownButton<int>(
                          value: currentYear,
                          items: snapshot.data?.map((Year value) {
                            return new DropdownMenuItem<int>(
                              value: value.id,
                              child: Text(
                                value.name,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            );
                          }).toList(),
                          onChanged: (shape) {                            
                            print(shape);
                            setState(() {
                              currentYear = shape ?? 0;
                              futureTournaments = manager.getTournaments(currentYear);
                            });
                          }))
                        ])); 
                      }
                      return CircularProgressIndicator();
                    },
                ),
                Expanded(child: TournamentList(futureTournaments)),
                //Text(currentYear.toString()),
              ]
            )
          ));
  }
}

class TournamentList extends StatelessWidget {
  final Future futureYears;

  @override
  TournamentList(this.futureYears);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureYears,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data.length == 0)
              return Text("no data");
            else
              return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = snapshot.data[index];
                  return GestureDetector(
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      height: 100,
                      decoration: BoxDecoration(color: Color.fromARGB(240, 120, 120, 120)),
                      child: Center(child: Text(item.name, 
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70
                      )))
                    ),
                    onTap: () => Navigator.push(context,
                       MaterialPageRoute(builder: (context) => SeasonDetailScreen(item.id, 0))
                    )                  
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}