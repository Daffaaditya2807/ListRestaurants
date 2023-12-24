import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_with_api/api/api_search_list_restaurants.dart';
import 'package:restaurant_with_api/model/list_restaurants.dart';

import 'page_detail_restaurants.dart';

class PageCariListRestaurants extends StatefulWidget {
  static String routeName = '/page_search_list_restaurants';
  @override
  State<PageCariListRestaurants> createState() =>
      _PageCariListRestaurantsState();
}

class _PageCariListRestaurantsState extends State<PageCariListRestaurants> {
  TextEditingController _controllerCari = TextEditingController();
  bool _isLoading = false;
  ListRestaurants? _listRestaurants;
  final ApiSearchListRestaurants _searchListRestaurants =
      ApiSearchListRestaurants();

  //Koneksi
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _search({String? key}) async {
    setState(() {
      _isLoading = true;
    });
    final result = await _searchListRestaurants.fetctDataRestaurant(key: key);
    setState(() {
      _listRestaurants = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double topPadding = MediaQuery.of(context).padding.top;
    double appBarHeight = kToolbarHeight;
    double heightSearch = 50.0;
    double bodyHeight = screenHeight - topPadding - appBarHeight - heightSearch;

    print('Connection Status: ${_connectionStatus.toString()}');
    String koneksi = _connectionStatus.toString();

    print(screenHeight);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Cari Restaurants"),
      ),
      body: SafeArea(
          child: koneksi != "ConnectivityResult.none"
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          controller: _controllerCari,
                          style: TextStyle(fontSize: 12.0),
                          autofocus: true,
                          cursorColor: Colors.grey,
                          onSubmitted: (value) {
                            _search(key: _controllerCari.text);
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                size: 20.0,
                              ),
                              hintText: "Cari Restaurants Favoritemu!",
                              hintStyle: TextStyle(fontSize: 12),
                              suffixIcon: Icon(
                                Icons.fastfood_sharp,
                                size: 20.0,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                      color: Colors.black38, width: 1.5)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.grey))),
                        ),
                      ),
                      _isLoading
                          ? SizedBox(
                              height: bodyHeight,
                              child: Center(child: CircularProgressIndicator()))
                          : _listRestaurants == null
                              ? SizedBox(
                                  height: bodyHeight,
                                  child: const Center(
                                      child: Text(
                                    "Silakan Cari Restaurants \nBerdasarkan Nama atau Kategori",
                                    textAlign: TextAlign.center,
                                  )))
                              : _listRestaurants!.restaurants.length != 0
                                  ? ListView.builder(
                                      itemCount:
                                          _listRestaurants!.restaurants.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final restaurantsSearch =
                                            _listRestaurants!
                                                .restaurants[index];
                                        // print("$restaurantsSearch");
                                        return BoxRestaurantApi(
                                            data: restaurantsSearch,
                                            context: context,
                                            route: PageDetailRestaurants
                                                .routeName);
                                      },
                                    )
                                  : SizedBox(
                                      height: bodyHeight,
                                      child: const Center(
                                          child: Text(
                                              "Restaurants Tidak Tersedia")))
                    ],
                  ),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        "Please! check your internet connection then make sure turn on WI-Fi or Data Seluler",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                )),
    );
  }

  Widget BoxRestaurantApi(
      {Restaurants? data, BuildContext? context, String? route}) {
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
            ),
          ),
        ),
      ],
    );
  }
}
