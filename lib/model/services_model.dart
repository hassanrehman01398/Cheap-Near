import 'package:cheapnear/model/user.dart';

class ServicesModel {
  String id;
  String image;
  String name;
  String price;
  String lat;
  String long;
  String type;
  String description;
  String createdAt;
  String location;
  UserModel user;
  ServicesModel( this.image, this.name, this.price, this.lat,this.long,
      this.type, this.description, this.user,this.location);

  toJson() {
    return {
      "id": id,
      "description": description,
      "image": image,
      "user": user == null ? null : user.toJson(),
      "name": name,
      "type": type,
      "price": price,
      "createdAt": createdAt,
      "lat": lat,
      "long": long,
      "location":location
    };
  }

  ServicesModel.fromJson(Map<dynamic, dynamic> map) {
    id = map['id'];
    description = map['description'];
    price = map["price"];
    type = map["type"];
    image = map['image'];
    createdAt = map['createdAt'];
    name = map["name"];
    user = UserModel.fromJson(map['user']);
    createdAt = map["createdAt"];
    lat = map["lat"].toString();
    long = map["long"].toString();
    location=map["location"];
  }
}
