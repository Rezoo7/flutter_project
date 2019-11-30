import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_app/venue.dart';

class detailsVenue extends StatelessWidget{

  Venue item;

  detailsVenue(Venue item){
    this.item = item;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Details venue',
      theme: ThemeData( // Add the 3 lines from here...
        primaryColor: Colors.amberAccent[700],
      ),
      home: Scaffold(
        body: Details(this.item),
      ),
    );
  }
}

class Details extends StatefulWidget {

  Venue v;

  Details(Venue venue){
    this.v = venue;
  }
  @override
  Screen createState() => Screen(this.v);
}


class Screen extends State<Details> {

  final _formKey = GlobalKey<FormState>();
  Venue v;

  Screen(Venue venue){
    this.v = venue;
  }

  Widget equalNull(BuildContext context, Object obj, String text) {
    if(Object != null){
      return Text(text+" : "+obj);
    }else{
      return Text(text+" : Non référencée !");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text(v.name,
        style: TextStyle(
            color: Colors.black,
        ),),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(

        child: Column(
          children: <Widget>[
            Text(
              v.name??'Aucun Titre',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w200,
                    fontStyle: FontStyle.italic,
                    fontSize: 28.0
                ),
              ),
            //equalNull(context, i.cat, "Categorie"),
            Text(v.phone??'Numéro Inconnu',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                  fontSize: 20.0
              ),
            ),
            Text(
              v.address??'Pas d\'adresse renseignée',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                  fontSize: 14.0
              )
            ),
            SizedBox(height: 18.0,),
            Text(v.description??'Pas de Description',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                  fontSize: 20.0
              ),),
            SizedBox(height: 18.0),
            Image.network(
              v.photos[0],height: 150.0,
              width: 400.0,
            ),
            SizedBox(height: 15.0,),
            Text(
              'Commentaire :',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15.0
              ),
            ),
            Text(
                v.commentsBis??'Aucun Commentaire',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                  fontSize: 20.0
              ),
            ),
            //Padding(
            //padding: const EdgeInsets.symmetric(vertical: 16.0),

            //),
          ],

        ),

      ),
    );
  }
}

