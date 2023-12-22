class ListRestaurants {
  String error;
  String message;
  String total;
  List<Restaurants> restaurants;

  ListRestaurants(
      {required this.error,
      required this.message,
      required this.total,
      required this.restaurants});

  factory ListRestaurants.fromJson(Map<String, dynamic> json) =>
      ListRestaurants(
          error: json['error'].toString(),
          message: json['message'],
          total: json['count'].toString(),
          restaurants: List<Restaurants>.from(
              json['restaurants'].map((x) => Restaurants.fromJson(x))));
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
}
