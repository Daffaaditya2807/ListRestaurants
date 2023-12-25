import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_with_api/page/page_cari_list_restaurants.dart';
import 'package:restaurant_with_api/provider/connectionprovider.dart';

import '../component/widget_build.dart';
import 'page_detail_restaurants.dart';

class PageListRestaurants extends StatefulWidget {
  static String routeName = '/list_restaurants';
  @override
  State<PageListRestaurants> createState() => _PageListRestaurantsState();
}

class _PageListRestaurantsState extends State<PageListRestaurants> {
  String? _currentAddress;
  Position? _currentPosition;

  // //Koneksi
  // ConnectivityResult _connectionStatus = ConnectivityResult.none;
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // //Handle Koneksi
  // Future<void> initConnectivity() async {
  //   late ConnectivityResult result;
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     developer.log('Couldn\'t check connectivity status', error: e);
  //     return;
  //   }
  //   if (!mounted) {
  //     return Future.value(null);
  //   }
  //   return _updateConnectionStatus(result);
  // }

  // //update Koneksi
  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   setState(() {
  //     _connectionStatus = result;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initConnectivity();
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _determinePosition();
    _getCurrentPosition();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.subLocality}';
      });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  final List<String> p = [
    'assets/banner/banner1.jpg',
    'assets/banner/banner2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 300,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    color: Colors.green,
                    child: CarouselSlider(
                      options: CarouselOptions(
                          height: 250,
                          viewportFraction: 1.0,
                          autoPlay: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.scale),
                      items: p
                          .map((item) => Container(
                                width: double.infinity,
                                child: Image.asset(
                                  item,
                                  fit: BoxFit.cover,
                                  scale: 20,
                                ),
                              ))
                          .toList(),
                    )),
                Positioned(
                  top: 10,
                  left: 5,
                  child: Row(
                    children: [
                      IconButton.filled(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_back),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.white)),
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.fmd_good_rounded,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Text("${_currentAddress ?? "Mencari Alamat..."}"),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 25,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)),
                      child: TextField(
                        onTap: () {
                          Navigator.pushNamed(
                              context, PageCariListRestaurants.routeName);
                        },
                        enabled: true,
                        readOnly: true,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: "Cari Restaurants Favoritemu!",
                            hintStyle: TextStyle(fontSize: 12),
                            suffixIcon: Icon(Icons.fastfood_sharp),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/badge.png"),
                    Text("Murah", style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/loved.png"),
                    Text(
                      "Favorite",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/maps.png"),
                    Text("Terlaris",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Khusus Buat Kamu",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Promo spesial untuk dipakai waktu checkout",
              style: TextStyle(fontSize: 12),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 120,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 2,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 280,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(250, 222, 222, 1)),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 120,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(249, 186, 186, 1),
                              image: DecorationImage(
                                  image: AssetImage("assets/disc.png")),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Special Discount!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromRGBO(204, 121, 121, 1)),
                              ),
                              Container(
                                width: 150,
                                child: Text(
                                  "Diskon Makanan Murah sampai 20% tiap beli 20rb",
                                  style: TextStyle(fontSize: 10.0),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Restaurants Yang Cocok Buat Kamu",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Makanan Enak , Minuman Enak dan Murah pasti ada!",
              style: TextStyle(fontSize: 12),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Consumer<RestaurantsProvider>(
            builder: (context, state, _) {
              if (state.state == ResulState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.state == ResulState.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.result.restaurants.length,
                  itemBuilder: (context, index) {
                    return ComponentWidget.BoxRestaurantApi(
                        data: state.result.restaurants[index],
                        context: context,
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
                return Center(
                  child: Material(
                    child: Text(state.message),
                  ),
                );
              } else {
                return Center(
                  child: Material(
                    child: Text(''),
                  ),
                );
              }
            },
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    )));
  }
}
