import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../model/list_restaurants.dart';

class ComponentWidget {
  static Widget NoInternet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset("assets/no_internet.json", width: 200, height: 200),
          const Text(
            "No Internet Connection",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Text(
            "Please! check your internet connection then make sure turn on WI-Fi or Data Seluler",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }

  static Widget BoxRestaurantApi(
      {Restaurants? data, BuildContext? context, String? route, String? fav}) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context!, route!, arguments: data);
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
                                  "${data?.rate}",
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
                              "${data?.name} , ${data?.city}",
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
                          onPressed: () {
                            // final rest = DbRestaurants(
                            //     id: "${data?.id}",
                            //     name: "${data?.id}",
                            //     desc: "${data?.id}",
                            //     picId: "${data?.id}",
                            //     kota: "${data?.id}",
                            //     rating: "${data?.id}",
                            //     fav: fav.toString());
                            // Provider.of<RestaurantsProvider>(context!,
                            //         listen: false)
                            //     .addRestaurantsDb(rest);
                          },
                          icon: Icon(Icons.favorite_border_outlined))
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
