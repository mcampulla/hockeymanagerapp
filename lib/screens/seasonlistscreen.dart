import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/manager.service.dart';
import 'package:flutter_application_1/models/setuplocator.dart';
import 'package:flutter_application_1/models/year.dart';
import 'package:flutter_application_1/screens/seasondetailscreen.dart';
import 'package:http/http.dart' as http;

class SeasonListScreen extends StatefulWidget {
  SeasonListScreen({Key? key}) : super(key: key);

  @override
  _SeasonListScreenState createState() => _SeasonListScreenState();
}

class _SeasonListScreenState extends State<SeasonListScreen> {
  late Future<Year> futureYear;
  late Future futureYears;

  @override
  void initState() {
    super.initState();
    var manager = locator<ManagerService>();
    futureYear = manager.getYear(2);
    futureYears = manager.getYears();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Seasons3"),
        ),
        body:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
              children: [
                ElevatedButton(
                      // Within the `FirstScreen` widget
                      onPressed: () {
                        // Navigate to the second screen using a named route.
                        showAlertDialog(context);
                      },
                      child: Text("Alert"),
                    ),
                Expanded(
                  child: Center(
                    child: FutureBuilder<Year>(
                      future: futureYear,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!.name);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      },
                  ))),
                Expanded(child: SeasonList(futureYears)),
              ]
            )
          );
  }

  // Future<Year> fetchYear(int id) async {
  //   final response = await http.get(
  //       Uri.https('hockey-manager-api.azurewebsites.net', 'odata/years/$id'));

  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     //var value =
  //     return Year.fromJson(jsonDecode(response.body)['value'][0]);
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load album');
  //   }
  // }

  // Future fetchYears() async {
  //   final response = await http
  //       .get(Uri.https('hockey-manager-api.azurewebsites.net', 'odata/years'));

  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     //var value =
  //     var value =
  //         jsonDecode(response.body)['value'].map((i) => Year.fromJson(i));
  //     return value.toList();
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load album');
  //   }
  // }
}

class SeasonList extends StatelessWidget {
  final Future futureYears;

  @override
  SeasonList(this.futureYears);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureYears,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data[0].name);
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
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SeasonDetailScreen(item.id))
                        );
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

showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () { 
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("My title"),
    content: Text("This is my message."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
