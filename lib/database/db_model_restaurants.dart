class DbRestaurants {
  late String id;
  late String name;
  late String desc;
  late String picId;
  late String kota;
  late String rating;
  late String fav;

  DbRestaurants(
      {required this.id,
      required this.name,
      required this.desc,
      required this.picId,
      required this.kota,
      required this.rating,
      required this.fav});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'picId': picId,
      'kota': kota,
      'rating': rating,
      'fav': fav
    };
  }

  DbRestaurants.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    desc = map['desc'];
    picId = map['picId'];
    kota = map['kota'];
    rating = map['rating'];
    fav = map['fav'];
  }
}
