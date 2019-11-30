class Venue {
  String id;
  String name;
  String description;
  List<String> photos = new List();
  List<String> comments = new List();
  String commentsBis;
  String latitude;
  String longitude;
  String address;
  String city;
  String region;
  String country;
  String cat;
  String url_icon;
  String phone;

  @override
  String toString() {
    return 'ItemReponse{id: $id, name: $name, description: $description, photos: $photos, comments: $comments, commentsBis: $commentsBis, latitude: $latitude, longitude: $longitude, city: $city, region: $region, country: $country, cat: $cat}';
  }

  Venue(String id, String name){
    this.id= id;
    this.name= name;
  }

  Venue.toString(){
    print("id : "+this.id + ", name : "+this.name);
  }

  setDescription(String desc){
    this.description = desc;
  }

  setIcon(String url){
    this.url_icon = url;
  }

  setAddress(String add){
    this.address = add;
  }

  setComments(List<String> comm){
    this.comments = comm;
  }
  setPhotos(List<String> ph){
    this.photos = ph;
  }
  setLatitude(String lat){
    this.latitude = lat;
  }
  setLongitude(String long){
    this.longitude = long;
  }

}