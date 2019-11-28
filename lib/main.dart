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
      home: MyHomePage(title: 'Home Page'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                  decoration: InputDecoration(
                    hintText: 'Entrez une Localisation ',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            children: <Widget>[
              Text(
                "Recherche : ",
              ),
              SizedBox(width: 5.0),
              new Flexible(
                child: new TextField(
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}


class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

