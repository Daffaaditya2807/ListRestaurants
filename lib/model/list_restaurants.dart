class ListRestaurants {
  String error;

  List<Restaurants> restaurants;

  ListRestaurants({required this.error, required this.restaurants});

  factory ListRestaurants.fromJson(Map<String, dynamic> json) =>
      ListRestaurants(
          error: json['error'].toString(),
          restaurants: List<Restaurants>.from(
              json['restaurants'].map((x) => Restaurants.fromJson(x))));

  Map<String, dynamic> toJson() => {"error": error, "restaurants": restaurants};
}

class Restaurants {
  String id;
  String name;
  String desc;
  String picId;
  String city;
  String rate;

  Restaurants(
      {required this.id,
      required this.name,
      required this.desc,
      required this.picId,
      required this.city,
      required this.rate});

  factory Restaurants.fromJson(Map<String, dynamic> json) => Restaurants(
      id: json['id'],
      name: json['name'],
      desc: json['description'],
      picId: json['pictureId'],
      city: json['city'],
      rate: json['rating'].toString());

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": desc,
        "pictureId": picId,
        "city": city,
        "rating": rate
      };
}
