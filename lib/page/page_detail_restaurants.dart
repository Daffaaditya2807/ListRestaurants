import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_with_api/api/api_add_reviews.dart';
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
  bool addreviews = false;

  TextEditingController _nama = TextEditingController();
  TextEditingController _comment = TextEditingController();

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    restaurant = ApiDetailRestaurants()
        .fetchRestaurant(idRestaurants: widget.restaurants.id);
    print("id Detail : ${widget.restaurants.id}");
  }

  //Handle Koneksi
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  //update Koneksi
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  // update comment
  void updateRestaurantData() async {
    DetailRestaurants updatedData = await ApiDetailRestaurants()
        .fetchRestaurant(idRestaurants: widget.restaurants.id);

    setState(() {
      restaurant = Future.value(updatedData);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Connection Status: ${_connectionStatus.toString()}');
    String koneksi = _connectionStatus.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurant Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: koneksi != "ConnectivityResult.none"
          ? FutureBuilder<DetailRestaurants>(
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
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
                                  padding: const EdgeInsets.only(
                                      right: 10.0, top: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                          "${snapshot.data!.categories[index].name}"),
                                    )),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Description",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          Text(
                            "${snapshot.data!.description}",
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 14.0),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          buildMenuList(snapshot.data!.menus.foods, 'Foods',
                              "assets/foods.jpg"),
                          const SizedBox(
                            height: 10,
                          ),
                          buildMenuList(snapshot.data!.menus.drinks, 'Drinks',
                              "assets/drinks.png"),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Text("Add Reviews"),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (addreviews == false) {
                                                addreviews = true;
                                                print(
                                                    "sini true ${addreviews}");
                                              } else {
                                                addreviews = false;
                                                print(
                                                    "sini false ${addreviews}");
                                              }
                                            });
                                          },
                                          splashRadius: 5,
                                          icon: addreviews == false
                                              ? Icon(Icons.arrow_drop_down)
                                              : Icon(Icons.arrow_drop_up))
                                    ],
                                  ),
                                  AnimatedCrossFade(
                                    duration: const Duration(milliseconds: 500),
                                    secondCurve: Curves.bounceInOut,
                                    firstChild: Container(
                                        height:
                                            0), // Widget saat addreviews false
                                    secondChild: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Form(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InputReviews(
                                                controller: _nama,
                                                label: "Name"),
                                            InputReviews(
                                                controller: _comment,
                                                label: "Reviews"),
                                            ElevatedButton(
                                                onPressed: () {
                                                  ApiAddReviews.InsertReviews(
                                                          id: widget
                                                              .restaurants.id
                                                              .toString(),
                                                          name: _nama.text,
                                                          reviews:
                                                              _comment.text)
                                                      .then((value) => {
                                                            print(
                                                                "${value.message}")
                                                          });

                                                  updateRestaurantData();
                                                  _comment.clear();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    minimumSize:
                                                        Size.fromHeight(50),
                                                    backgroundColor: Colors
                                                        .white,
                                                    foregroundColor: Colors
                                                        .blue.shade200,
                                                    side: const BorderSide(
                                                        color: Colors.grey),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10))),
                                                child: const Text(
                                                  "Send Reviews",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))
                                          ],
                                        )),
                                      ),
                                      // Anda bisa menambahkan child jika perlu
                                    ), // Widget saat addreviews true
                                    crossFadeState: addreviews
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          buildCustomerReviews(snapshot.data!.customerReviews),
                          const SizedBox(
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
                return const Center(child: CircularProgressIndicator());
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset("assets/no_internet.json",
                      width: 200, height: 200),
                  Text(
                    "No Internet Connection",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    "Please! check your internet connection then make sure turn on WI-Fi or Data Seluler",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
    );
  }

  Widget buildMenuList(List<MenuItem> items, String title, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
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
                              borderRadius: const BorderRadius.only(
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
                        const Padding(
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
        const Text(
          "Customer Review",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        const SizedBox(
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
                    leading: const CircleAvatar(
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
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Divider(
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

  Widget InputReviews({TextEditingController? controller, String? label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        style: const TextStyle(fontSize: 12),
        cursorColor: Colors.grey.shade400,
        controller: controller,
        decoration: InputDecoration(
            label: Text("${label}"),
            prefixIcon: Icon(Icons.person),
            labelStyle: TextStyle(fontSize: 12, color: Colors.black),
            contentPadding: EdgeInsets.all(10),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey))),
      ),
    );
  }
}
