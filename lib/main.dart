import 'dart:convert';

import 'package:flutter/material.dart';
import 'env.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_project_app/venue.dart';
import 'detailsVenue.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projet',
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
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text(
            widget.title,
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.amberAccent[700],
      ),
      body:
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "Lieux : ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 23.0
                ),
              ),
              SizedBox(width: 55.0),
              new Flexible(
                child: new TextField(
                  controller: localisationController,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 20.0
                  ),
                  decoration: InputDecoration(
                    hintText: 'Entrez une Localisation',
                    hintStyle: TextStyle(
                     color: Colors.white
                    ),
                    border: new UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    )
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
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 23.0
                ),
              ),
              SizedBox(width: 5.0),
              new Flexible(
                child: new TextField(
                  controller: searchController,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 20.0
                  ),
                  decoration: InputDecoration(
                    hintText: 'Bars, Restaurants... ',
                    hintStyle: TextStyle(
                        color: Colors.white
                    ),
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

class Results extends StatefulWidget{
  final String localisation;
  final String search;

  Results({Key key, @required this.localisation,this.search});
  @override
  _Results createState() =>  _Results(localisation: localisation,search: search);
}


class _Results extends State<Results> {
  final String localisation;
  final String search;
  final List<Venue> venues = <Venue>[];

  _Results({Key key, @required this.localisation,this.search});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text("Resultats",
         style: TextStyle(
           color: Colors.black,
         )
        ),
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
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0,
                        color: Colors.white
                      ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                      this.localisation,
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 20.0,
                        color: Colors.white
                    ),
                  )
                ],
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Text(
                      "Recherche : ",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                      color: Colors.white ,
                    )
                  ),
                  SizedBox(width: 10.0),
                  Text(
                      this.search,
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 20.0,
                        color: Colors.white
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 25.0,),
          FlatButton.icon(
            color: Colors.grey[400] ,
            icon :Icon(Icons.search),
            label: Text("Rechercher"),
            onPressed: () {
              fetchPost(localisation, search).then((result) {
                venues.clear();
                setState(() {
                  venues.addAll(result.listeReponses);
                });
              });
            },
          ),
          Expanded(
          child: SizedBox(
            height: 200,
            child: new ListView.builder(
                itemCount: venues.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child : Container(
                      height: 50,
                      margin: EdgeInsets.all(5.0),
                    //color: Colors.amber[500],
                      child: (Text(
                          venues[index].name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w200,
                            fontSize: 20.0
                          ),
                      )),
                    ),

                    onTap: () => {
                      fetchPostDetails(venues[index]).then((result){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Details(result.itemReponse)));
                      }),
                    }
                  );
                }
            ),

          ),
          ),
          SizedBox(height: 38.0),
          Center(
            child:
            RaisedButton(
              color: Colors.grey[400],
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

  Future<Reponses> fetchPost(final String lieu,final String act) async {
    String url='https://api.foursquare.com/v2/venues/search?near='+lieu+'&query='+act+'&client_id='+client_id+'&client_secret='+client_secret+'&v=20180323';
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("res: "+ ""+Reponses.fromJson(json.decode(response.body)).toString());

      return Reponses.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load activities');
    }
  }

  Widget listViewResult(BuildContext context){
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: venues.length,
      itemBuilder: (BuildContext context, int index){
        return InkWell(
          onTap: () {
            print(venues[index].name);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 5.0),
            child: Text(venues[index].name),
          ),
        );
      },
    );
  }
}

class Reponses {
  final List<Venue> listeReponses;

  Reponses({this.listeReponses});

  factory Reponses.fromJson(Map<String, dynamic> json) {
    List<Venue> tes = new List<Venue>();
    for (var items in json["response"]["venues"]) {
      print("ici: "+items["name"]);
      Venue itemReponse = new Venue(items["id"], items["name"]);
      itemReponse.setLatitude(items["location"]["lat"].toString());
      itemReponse.setLongitude(items["location"]["lng"].toString());
      itemReponse.setAddress(items["location"]["address"].toString());
      print(itemReponse.address);
      if (items["categories"] == []) {
        var obj = items["categories"][0]["icon"];
        itemReponse.setIcon(obj["prefix"].toString()+""+obj["suffix"].toString());
      }
      print(itemReponse.toString());
      tes.add(itemReponse);
    }
    return Reponses(listeReponses: tes);
  }
}

class ReponsesDetails {
  Venue itemReponse;

  ReponsesDetails({this.itemReponse});

  factory ReponsesDetails.fromJson(Map<String, dynamic> json) {
    Venue itemR = new Venue(json["response"]["venue"]["id"], json["response"]["venue"]["name"]);
    if(json["response"]["venue"]["contact"]["formattedPhone"] != null){
      itemR.phone = (json["response"]["venue"]["contact"]["formattedPhone"]);
    }else{
      itemR.description = null;
    }
    itemR.setLatitude(json["response"]["venue"]["location"]["lat"].toString());
    itemR.setLongitude(json["response"]["venue"]["location"]["lng"].toString());
    if(json["response"]["venue"]["description"] != null){
      itemR.setDescription(json["response"]["venue"]["description"]);
    }else{
      itemR.description = null;
    }
    if(json["response"]["venue"]["tips"]["groups"][0]["items"].toString().length > 2){
      itemR.commentsBis = (json["response"]["venue"]["tips"]["groups"][0]["items"][0]["text"]);
    } else {
      itemR.commentsBis = null;
    }
    if(json["response"]["venue"]["bestPhoto"] != null){
      itemR.photos.add(
          json["response"]["venue"]["bestPhoto"]["prefix"]+
              json["response"]["venue"]["bestPhoto"]["width"].toString()+
              "x"+
              json["response"]["venue"]["bestPhoto"]["height"].toString()+
              json["response"]["venue"]["bestPhoto"]["suffix"]

      );
    }else{
      itemR.photos.add(
          "https://www.prendsmaplace.fr/wp-content/themes/prendsmaplace/images/defaut_image.gif"
      );
    }
    if(json["response"]["venue"]["categories"].toString().length > 2) {
      itemR.cat = json["response"]["venue"]["categories"][0]["name"];
    }else{
      itemR.cat = null;
    }

    return ReponsesDetails(itemReponse: itemR);
  }
}

Future<ReponsesDetails> fetchPostDetails(final Venue itemrep) async {
  String url='https://api.foursquare.com/v2/venues/'+itemrep.id+'?client_id='+client_id+'&client_secret='+client_secret+'&v=20180323';
  print("url: "+url);
  final response = await http.get(url);
  if (response.statusCode == 200) {
    print('code 200');
    print("res: "+ ""+ReponsesDetails.fromJson(json.decode(response.body)).toString());

    return ReponsesDetails.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load activities');
  }
}

