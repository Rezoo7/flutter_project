import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      home: MyHomePage(title: 'Accueil Recherche'),
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
  TextEditingController locationController = TextEditingController();
  TextEditingController activityController = TextEditingController();

  Future<Activities> activities;

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
              SizedBox(width: 5.0),
              new Flexible(
                child: new TextField(
                  controller: locationController,
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
                "Activité : ",
              ),
              SizedBox(width: 5.0),
              new Flexible(
                child: new TextField(
                  controller: activityController,
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
                  //_sendLocalisationToResult(context);
                  activities = fetchActivities(); // (Je sais pas si ya ce qu'il faut dans activities)
                  // TODO display all activity results from activities in a list view (with icon and name)
                },
              ),
              RaisedButton(
                child: Text('Toast'),
                onPressed: () {

                },
              )
            ],
          ),
        ],
      ),
    );
  }

  void makeToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        //backgroundColor: Colors.red,
        //textColor: Colors.white,
        fontSize: 16.0
    );
  }
  
  // Open new page to display inputs -> deprecated
  /*void _sendLocalisationToResult(BuildContext context) {
    String loc = locationController.text;
    String sch = activityController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Results(localisation: loc,search: sch),
        ));
  }*/

  Future<Activities> fetchActivities() async {
    final response = await http.get('https://api.foursquare.com/v2/venues/explore?client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&v=20180323&limit=5&near=${locationController.text}&query=${activityController.text}');

    if (response.statusCode == 200) {
      return activitiesFromJson(response.body);
    } else {
      throw Exception('Failed to load activities');
    }
  }
}

/*class Results extends StatelessWidget {
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
}*/






// To parse this JSON data, do
//
//     final activities = activitiesFromJson(jsonString);


Activities activitiesFromJson(String str) => Activities.fromJson(json.decode(str));

String activitiesToJson(Activities data) => json.encode(data.toJson());

class Activities {
  Meta meta;
  Response response;

  Activities({
    this.meta,
    this.response,
  });

  factory Activities.fromJson(Map<String, dynamic> json) => Activities(
    meta: Meta.fromJson(json["meta"]),
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta.toJson(),
    "response": response.toJson(),
  };
}

class Meta {
  int code;
  String requestId;

  Meta({
    this.code,
    this.requestId,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    code: json["code"],
    requestId: json["requestId"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "requestId": requestId,
  };
}

class Response {
  SuggestedFilters suggestedFilters;
  Geocode geocode;
  String headerLocation;
  String headerFullLocation;
  String headerLocationGranularity;
  String query;
  int totalResults;
  Bounds suggestedBounds;
  List<Group> groups;

  Response({
    this.suggestedFilters,
    this.geocode,
    this.headerLocation,
    this.headerFullLocation,
    this.headerLocationGranularity,
    this.query,
    this.totalResults,
    this.suggestedBounds,
    this.groups,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    suggestedFilters: SuggestedFilters.fromJson(json["suggestedFilters"]),
    geocode: Geocode.fromJson(json["geocode"]),
    headerLocation: json["headerLocation"],
    headerFullLocation: json["headerFullLocation"],
    headerLocationGranularity: json["headerLocationGranularity"],
    query: json["query"],
    totalResults: json["totalResults"],
    suggestedBounds: Bounds.fromJson(json["suggestedBounds"]),
    groups: List<Group>.from(json["groups"].map((x) => Group.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "suggestedFilters": suggestedFilters.toJson(),
    "geocode": geocode.toJson(),
    "headerLocation": headerLocation,
    "headerFullLocation": headerFullLocation,
    "headerLocationGranularity": headerLocationGranularity,
    "query": query,
    "totalResults": totalResults,
    "suggestedBounds": suggestedBounds.toJson(),
    "groups": List<dynamic>.from(groups.map((x) => x.toJson())),
  };
}

class Geocode {
  String what;
  String where;
  CircleCenter center;
  String displayString;
  String cc;
  Geometry geometry;
  String slug;
  String longId;

  Geocode({
    this.what,
    this.where,
    this.center,
    this.displayString,
    this.cc,
    this.geometry,
    this.slug,
    this.longId,
  });

  factory Geocode.fromJson(Map<String, dynamic> json) => Geocode(
    what: json["what"],
    where: json["where"],
    center: CircleCenter.fromJson(json["center"]),
    displayString: json["displayString"],
    cc: json["cc"],
    geometry: Geometry.fromJson(json["geometry"]),
    slug: json["slug"],
    longId: json["longId"],
  );

  Map<String, dynamic> toJson() => {
    "what": what,
    "where": where,
    "center": center.toJson(),
    "displayString": displayString,
    "cc": cc,
    "geometry": geometry.toJson(),
    "slug": slug,
    "longId": longId,
  };
}

class CircleCenter {
  double lat;
  double lng;

  CircleCenter({
    this.lat,
    this.lng,
  });

  factory CircleCenter.fromJson(Map<String, dynamic> json) => CircleCenter(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Geometry {
  Bounds bounds;

  Geometry({
    this.bounds,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    bounds: Bounds.fromJson(json["bounds"]),
  );

  Map<String, dynamic> toJson() => {
    "bounds": bounds.toJson(),
  };
}

class Bounds {
  CircleCenter ne;
  CircleCenter sw;

  Bounds({
    this.ne,
    this.sw,
  });

  factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
    ne: CircleCenter.fromJson(json["ne"]),
    sw: CircleCenter.fromJson(json["sw"]),
  );

  Map<String, dynamic> toJson() => {
    "ne": ne.toJson(),
    "sw": sw.toJson(),
  };
}

class Group {
  String type;
  String name;
  List<GroupItem> items;

  Group({
    this.type,
    this.name,
    this.items,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    type: json["type"],
    name: json["name"],
    items: List<GroupItem>.from(json["items"].map((x) => GroupItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "name": name,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class GroupItem {
  Reasons reasons;
  Venue venue;
  String referralId;
  Flags flags;

  GroupItem({
    this.reasons,
    this.venue,
    this.referralId,
    this.flags,
  });

  factory GroupItem.fromJson(Map<String, dynamic> json) => GroupItem(
    reasons: Reasons.fromJson(json["reasons"]),
    venue: Venue.fromJson(json["venue"]),
    referralId: json["referralId"],
    flags: json["flags"] == null ? null : Flags.fromJson(json["flags"]),
  );

  Map<String, dynamic> toJson() => {
    "reasons": reasons.toJson(),
    "venue": venue.toJson(),
    "referralId": referralId,
    "flags": flags == null ? null : flags.toJson(),
  };
}

class Flags {
  bool outsideRadius;

  Flags({
    this.outsideRadius,
  });

  factory Flags.fromJson(Map<String, dynamic> json) => Flags(
    outsideRadius: json["outsideRadius"],
  );

  Map<String, dynamic> toJson() => {
    "outsideRadius": outsideRadius,
  };
}

class Reasons {
  int count;
  List<ReasonsItem> items;

  Reasons({
    this.count,
    this.items,
  });

  factory Reasons.fromJson(Map<String, dynamic> json) => Reasons(
    count: json["count"],
    items: List<ReasonsItem>.from(json["items"].map((x) => ReasonsItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class ReasonsItem {
  String summary;
  String type;
  String reasonName;

  ReasonsItem({
    this.summary,
    this.type,
    this.reasonName,
  });

  factory ReasonsItem.fromJson(Map<String, dynamic> json) => ReasonsItem(
    summary: json["summary"],
    type: json["type"],
    reasonName: json["reasonName"],
  );

  Map<String, dynamic> toJson() => {
    "summary": summary,
    "type": type,
    "reasonName": reasonName,
  };
}

class Venue {
  String id;
  String name;
  Contact contact;
  Location location;
  List<Category> categories;
  bool verified;
  Stats stats;
  BeenHere beenHere;
  Photos photos;
  HereNow hereNow;

  Venue({
    this.id,
    this.name,
    this.contact,
    this.location,
    this.categories,
    this.verified,
    this.stats,
    this.beenHere,
    this.photos,
    this.hereNow,
  });

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
    id: json["id"],
    name: json["name"],
    contact: Contact.fromJson(json["contact"]),
    location: Location.fromJson(json["location"]),
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    verified: json["verified"],
    stats: Stats.fromJson(json["stats"]),
    beenHere: BeenHere.fromJson(json["beenHere"]),
    photos: Photos.fromJson(json["photos"]),
    hereNow: HereNow.fromJson(json["hereNow"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "contact": contact.toJson(),
    "location": location.toJson(),
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "verified": verified,
    "stats": stats.toJson(),
    "beenHere": beenHere.toJson(),
    "photos": photos.toJson(),
    "hereNow": hereNow.toJson(),
  };
}

class BeenHere {
  int count;
  int lastCheckinExpiredAt;
  bool marked;
  int unconfirmedCount;

  BeenHere({
    this.count,
    this.lastCheckinExpiredAt,
    this.marked,
    this.unconfirmedCount,
  });

  factory BeenHere.fromJson(Map<String, dynamic> json) => BeenHere(
    count: json["count"],
    lastCheckinExpiredAt: json["lastCheckinExpiredAt"],
    marked: json["marked"],
    unconfirmedCount: json["unconfirmedCount"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "lastCheckinExpiredAt": lastCheckinExpiredAt,
    "marked": marked,
    "unconfirmedCount": unconfirmedCount,
  };
}

class Category {
  String id;
  String name;
  String pluralName;
  String shortName;
  Icon icon;
  bool primary;

  Category({
    this.id,
    this.name,
    this.pluralName,
    this.shortName,
    this.icon,
    this.primary,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    pluralName: json["pluralName"],
    shortName: json["shortName"],
    icon: Icon.fromJson(json["icon"]),
    primary: json["primary"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "pluralName": pluralName,
    "shortName": shortName,
    "icon": icon.toJson(),
    "primary": primary,
  };
}

class Icon {
  String prefix;
  String suffix;

  Icon({
    this.prefix,
    this.suffix,
  });

  factory Icon.fromJson(Map<String, dynamic> json) => Icon(
    prefix: json["prefix"],
    suffix: json["suffix"],
  );

  Map<String, dynamic> toJson() => {
    "prefix": prefix,
    "suffix": suffix,
  };
}

class Contact {
  Contact();

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
  );

  Map<String, dynamic> toJson() => {
  };
}

class HereNow {
  int count;
  String summary;
  List<dynamic> groups;

  HereNow({
    this.count,
    this.summary,
    this.groups,
  });

  factory HereNow.fromJson(Map<String, dynamic> json) => HereNow(
    count: json["count"],
    summary: json["summary"],
    groups: List<dynamic>.from(json["groups"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "summary": summary,
    "groups": List<dynamic>.from(groups.map((x) => x)),
  };
}

class Location {
  String address;
  double lat;
  double lng;
  List<LabeledLatLng> labeledLatLngs;
  String postalCode;
  String cc;
  String city;
  String state;
  String country;
  List<String> formattedAddress;

  Location({
    this.address,
    this.lat,
    this.lng,
    this.labeledLatLngs,
    this.postalCode,
    this.cc,
    this.city,
    this.state,
    this.country,
    this.formattedAddress,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    address: json["address"] == null ? null : json["address"],
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
    labeledLatLngs: List<LabeledLatLng>.from(json["labeledLatLngs"].map((x) => LabeledLatLng.fromJson(x))),
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    cc: json["cc"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    formattedAddress: List<String>.from(json["formattedAddress"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "address": address == null ? null : address,
    "lat": lat,
    "lng": lng,
    "labeledLatLngs": List<dynamic>.from(labeledLatLngs.map((x) => x.toJson())),
    "postalCode": postalCode == null ? null : postalCode,
    "cc": cc,
    "city": city,
    "state": state,
    "country": country,
    "formattedAddress": List<dynamic>.from(formattedAddress.map((x) => x)),
  };
}

class LabeledLatLng {
  String label;
  double lat;
  double lng;

  LabeledLatLng({
    this.label,
    this.lat,
    this.lng,
  });

  factory LabeledLatLng.fromJson(Map<String, dynamic> json) => LabeledLatLng(
    label: json["label"],
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "lat": lat,
    "lng": lng,
  };
}

class Photos {
  int count;
  List<dynamic> groups;

  Photos({
    this.count,
    this.groups,
  });

  factory Photos.fromJson(Map<String, dynamic> json) => Photos(
    count: json["count"],
    groups: List<dynamic>.from(json["groups"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "groups": List<dynamic>.from(groups.map((x) => x)),
  };
}

class Stats {
  int tipCount;
  int usersCount;
  int checkinsCount;
  int visitsCount;

  Stats({
    this.tipCount,
    this.usersCount,
    this.checkinsCount,
    this.visitsCount,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    tipCount: json["tipCount"],
    usersCount: json["usersCount"],
    checkinsCount: json["checkinsCount"],
    visitsCount: json["visitsCount"],
  );

  Map<String, dynamic> toJson() => {
    "tipCount": tipCount,
    "usersCount": usersCount,
    "checkinsCount": checkinsCount,
    "visitsCount": visitsCount,
  };
}

class SuggestedFilters {
  String header;
  List<Filter> filters;

  SuggestedFilters({
    this.header,
    this.filters,
  });

  factory SuggestedFilters.fromJson(Map<String, dynamic> json) => SuggestedFilters(
    header: json["header"],
    filters: List<Filter>.from(json["filters"].map((x) => Filter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "header": header,
    "filters": List<dynamic>.from(filters.map((x) => x.toJson())),
  };
}

class Filter {
  String name;
  String key;

  Filter({
    this.name,
    this.key,
  });

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
    name: json["name"],
    key: json["key"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "key": key,
  };
}