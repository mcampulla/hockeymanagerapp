import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/manager.service.dart';
import 'package:flutter_application_1/models/setuplocator.dart';
import 'package:flutter_application_1/models/tournament.dart';
import 'package:flutter_application_1/models/year.dart';
import 'package:flutter_application_1/screens/seasondetailscreen.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Year>> futureYears;
  late Future<List<Tournament>> futureTournaments;
  int currentYear = 20038;
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
        ),
        body: 
          Container(decoration:
            BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://scontent.fqpa3-2.fna.fbcdn.net/v/t1.6435-9/43397684_2378975292142162_2317381267055706112_n.jpg?_nc_cat=103&ccb=1-5&_nc_sid=174925&_nc_ohc=Ezk6rzNdd9EAX8yy7qj&_nc_ht=scontent.fqpa3-2.fna&oh=3a5c02f72cac723ed7666fb1c3815b12&oe=61BE249F"),
                fit: BoxFit.contain,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
              children: [
                FutureBuilder<List<Year>> (
                    future: futureYears,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        //List<Year> years = snapshot.data as List<Year>;
                        return Center(child: DropdownButton<int>(
                          value: currentYear,
                          items: snapshot.data?.map((Year value) {
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
                              currentYear = shape ?? 0;
                              futureTournaments = manager.getTournaments(currentYear);
                            });
                          }));
                      }
                      return CircularProgressIndicator();
                    },
                ),
                Expanded(child: TournamentList(futureTournaments)),
                Text(currentYear.toString()),
                // DropdownButton<int>(
                //   value: currentYear,
                //   items: years.map((Year value) {
                //     return new DropdownMenuItem<int>(
                //       value: value.id,
                //       child: Text(
                //         value.name,
                //         style: TextStyle(fontSize: 24.0),
                //       ),
                //     );
                //   }).toList(),
                //   onChanged: (shape) {
                //     setState(() {
                //       currentYear = shape ?? 0;
                //     });
                //   }),
                // Expanded(
                //   child: Center(
                //     child: FutureBuilder<Year>(
                //       future: futureYear,
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData) {
                //           return Text(snapshot.data!.name);
                //         } else if (snapshot.hasError) {
                //           return Text("${snapshot.error}");
                //         }
                //         return CircularProgressIndicator();
                //       },
                //   ))),
                // Expanded(child: TournamentList(futureTournaments)),
              ]
            )
          ));
  }

  List<Widget> createSquares(int id) {


    List<Widget> squares = [];
    // while (i < numSquares) {
    //   Expanded square = Expanded(flex: i, child: Container(
    //       color: colors[i], child: Text(i.toString())));
    //   i++;
    //   squares.add(square);
    // }
    return squares;
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
                          fontWeight: FontWeight.bold,
                          color: Colors.white70
                      )))
                    ),
                    onTap: () => Navigator.push(context,
                       MaterialPageRoute(builder: (context) => SeasonDetailScreen(item.id))
                    )                  
                  );
                  // return Row(children: [
                  //   Center(child: Text(item.name)),
                  //   ElevatedButton(
                  //     // Within the `FirstScreen` widget
                  //     onPressed: () {
                  //       // Navigate to the second screen using a named route.
                  //       // Navigator.push(context,
                  //       //   MaterialPageRoute(builder: (context) => SeasonDetailScreen(item.id))
                  //       // );
                  //     },
                  //     child: Text(item.id.toString()),
                  //   )
                  // ]);
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class TournamentList2 extends StatelessWidget {
  final Future futureYears;

  @override
  TournamentList2(this.futureYears);

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
                  return Row(children: [
                    Center(child: Text(item.name)),
                    ElevatedButton(
                      // Within the `FirstScreen` widget
                      onPressed: () {
                        // Navigate to the second screen using a named route.
                        // Navigator.push(context,
                        //   MaterialPageRoute(builder: (context) => SeasonDetailScreen(item.id))
                        // );
                      },
                      child: Text(item.id.toString()),
                    )
                  ]);
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     //final wordPair = WordPair.random();
//     return Scaffold(
//         appBar: AppBar(title: Text("Home"),),
//         body:Center(
//           child: Column(
//             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             //crossAxisAlignment: CrossAxisAlignment.center, 
//             children: [
            
//             ElevatedButton(
//               // Within the `FirstScreen` widget
//               onPressed: () {
//                 // Navigate to the second screen using a named route.
//                 Navigator.pushNamed(context, '/playerlist');
//               },
//               child: Text('Player list1'),
//             ),
//             ElevatedButton(
//               // Within the `FirstScreen` widget
//               onPressed: () {
//                 // Navigate to the second screen using a named route.
//                 Navigator.pushNamed(context, '/seasonlist');
//               },
//               child: Text('Season list'),
//             ),
//           ]
//     )));
//   }
// }
