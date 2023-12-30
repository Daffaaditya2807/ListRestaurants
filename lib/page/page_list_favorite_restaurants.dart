import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_with_api/model/list_restaurants.dart';
import 'package:restaurant_with_api/provider/provider_list_restaurants.dart';

import '../component/widget_build.dart';
import '../database/db_model_restaurants.dart';
import 'page_detail_restaurants.dart';

class PageListFaveRestaurants extends StatefulWidget {
  static String routeName = '/list_favorite';
  @override
  State<PageListFaveRestaurants> createState() =>
      _PageListFaveRestaurantsState();
}

class _PageListFaveRestaurantsState extends State<PageListFaveRestaurants> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("List Restaurants Favorite"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<RestaurantsProvider>(
              builder: (context, state, _) {
                if (state.state == ResulState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.state == ResulState.hasData) {
                  final restaurantsFav = state.dbrest;

                  print("kesini ka?");
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: restaurantsFav.length,
                    itemBuilder: (context, index) {
                      final itemRestaurants = restaurantsFav[index];
                      bool isFav =
                          state.favorites[restaurantsFav[index].id] ?? false;
                      return BoxRestaurantApiTest(
                          data: itemRestaurants,
                          context: context,
                          isFav: isFav,
                          restt: state,
                          route: PageDetailRestaurants.routeName);
                    },
                  );
                } else if (state.state == ResulState.noData) {
                  return Center(
                    child: Material(
                      child: Text(state.message),
                    ),
                  );
                } else if (state.state == ResulState.error) {
                  print(state.message);
                  if (state.message == '404') {
                    return ComponentWidget.NoInternet();
                  } else {
                    return Center(
                      child: Material(
                        child: Text(state.message),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: Material(
                      child: Text(''),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget BoxRestaurantApiTest(
      {DbRestaurants? data,
      BuildContext? context,
      String? route,
      bool? isFav,
      RestaurantsProvider? restt}) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: GestureDetector(
            onTap: () async {
              final restaurants = Restaurants(
                  id: data!.id,
                  name: data.name,
                  desc: data.desc,
                  picId: data.picId,
                  city: data.kota,
                  rate: data.rating);
              bool result = await Navigator.push(
                  context!,
                  MaterialPageRoute(
                    builder: (context) =>
                        PageDetailRestaurants(restaurants: restaurants),
                  ));

              if (result == true) {
                restt!.getAllRestaurantsdb();
                restt.loadFavorite();
              }
            },
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 140,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://restaurant-api.dicoding.dev/images/medium/${data?.picId}"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          left: 15,
                          child: Container(
                            width: 80,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber.shade700,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "${data?.rating}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              "${data?.name} , ${data?.kota}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              width: 200,
                              child: Text("${data?.desc}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () async {
                            if (isFav) {
                              await restt?.deleteRestaurantsDb("${data?.id}");
                              restt?.updateFavoriteStatus("${data?.id}", false);
                            } else {
                              final rest = DbRestaurants(
                                  id: data!.id.toString(),
                                  name: data.name.toString(),
                                  desc: data.desc.toString(),
                                  picId: data.picId.toString(),
                                  kota: data.kota.toString(),
                                  rating: data.rating.toString(),
                                  fav: "True");
                              await restt!.addRestaurantsDb(rest);
                              restt.updateFavoriteStatus("${data.id}", true);
                            }
                          },
                          icon: Icon(
                            isFav! ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : null,
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
