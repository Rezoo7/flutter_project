import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Accueil Recherche '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController localisationController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.amberAccent[700],
      ),
      body:
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "Lieux : ",
              ),
              SizedBox(width: 35.0),
              new Flexible(
                child: new TextField(
                  controller: localisationController,
                  decoration: InputDecoration(
                    hintText: 'Entrez une Localisation',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0,),
          Row(
            children: <Widget>[
              Text(
                "Recherche : ",
              ),
              SizedBox(width: 5.0),
              new Flexible(
                child: new TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Bars, Restaurants... ',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 28.0,),
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text('Resultats'),
                onPressed: () {
                  _sendLocalisationToResult(context);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
  void _sendLocalisationToResult(BuildContext context) {
    String loc = localisationController.text;
    String sch = searchController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Results(localisation: loc,search: sch),
        ));
  }
}


class Results extends StatelessWidget {
  final String localisation;
  final String search;

  Results({Key key, @required this.localisation,this.search}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultats"),
        backgroundColor: Colors.amberAccent[700],
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                      "Localisation : ",
                      style: titleWeight(20.0),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                      this.localisation,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0
                    ),
                  )
                ],
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Text(
                      "Recherche : ",
                    style: titleWeight(20.0) ,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                      this.search,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 38.0),
          Center(
            child:
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Retour '),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle titleWeight(double size){
    return new TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w200,
    );
  }
}

