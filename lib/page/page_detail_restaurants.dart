import 'package:flutter/material.dart';
import 'package:restaurant_with_api/api/api_detail_restaurants.dart';
import 'package:restaurant_with_api/model/list_restaurants.dart';

import '../model/detail_restaurants.dart';

class PageDetailRestaurants extends StatefulWidget {
  static String routeName = '/detail_list_restaurants';
  final Restaurants restaurants;
  const PageDetailRestaurants({Key? key, required this.restaurants})
      : super(key: key);

  @override
  State<PageDetailRestaurants> createState() => _DetailRestaurantsState();
}

class _DetailRestaurantsState extends State<PageDetailRestaurants> {
  late Future<DetailRestaurants> restaurant;

  @override
  void initState() {
    super.initState();
    restaurant = ApiDetailRestaurants()
        .fetchRestaurant(idRestaurants: widget.restaurants.id);
    print("id Detail : ${widget.restaurants.id}");
  }

  Widget buildMenuList(List<MenuItem> items, String title, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Foods",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        SizedBox(
          width: double.infinity,
          height: 150,
          child: ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                child: Container(
                  width: 180,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                  image: AssetImage("${imagePath}"),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                          child: Text(
                            "${items[index].name}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text("Rp. 10.000"),
                        )
                      ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildCustomerReviews(List<CustomerReview> reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customer Review",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        SizedBox(
          height: 10,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/person.png"),
                      backgroundColor: Colors.white,
                    ),
                    title: Text("${reviews[index].name}"),
                    subtitle: Text("${reviews[index].date}"),
                    contentPadding: EdgeInsets.all(1.0),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${reviews[index].review}"),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    thickness: 0.5,
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Restaurant Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<DetailRestaurants>(
        future: restaurant,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://restaurant-api.dicoding.dev/images/large/${snapshot.data!.pictureId}"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${snapshot.data!.name}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text(
                          "${snapshot.data!.city} | rate: ${snapshot.data!.rating.toString()}",
                          style: TextStyle(fontSize: 14.0),
                        )
                      ],
                    ),
                    Text(
                      "${snapshot.data!.address}",
                      style: TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Categori Restaurants",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ListView.builder(
                        itemCount: snapshot.data!.categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, top: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                    "${snapshot.data!.categories[index].name}"),
                              )),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Description",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(
                      "${snapshot.data!.description}",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildMenuList(snapshot.data!.menus.foods, 'Foods',
                        "assets/foods.jpg"),
                    SizedBox(
                      height: 10,
                    ),
                    buildMenuList(snapshot.data!.menus.drinks, 'Drinks',
                        "assets/drinks.png"),
                    SizedBox(
                      height: 10,
                    ),
                    buildCustomerReviews(snapshot.data!.customerReviews),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
            // You can expand this to display more details as required.
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
