import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_with_api/component/widget_build.dart';

import '../database/db_model_restaurants.dart';
import '../model/list_restaurants.dart';
import '../provider/provider_search_restaurants.dart';
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

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<CariRestaurantsProvider>(context, listen: false);
    provider.getAllRestaurantsdb();
    provider.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double topPadding = MediaQuery.of(context).padding.top;
    double appBarHeight = kToolbarHeight;
    double heightSearch = 50.0;
    double bodyHeight = screenHeight - topPadding - appBarHeight - heightSearch;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Cari Restaurants"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
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
                  Provider.of<CariRestaurantsProvider>(context, listen: false)
                      .searchRestaurants(_controllerCari.text);
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(color: Colors.black38, width: 1.5)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.grey))),
              ),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<CariRestaurantsProvider>(
                    builder: (context, state, _) {
                      if (state.state == ResultsCari.first) {
                        return SizedBox(
                          height: bodyHeight,
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                "Silakan Cari Restaurants berdasarkan nama, categori kampus dan nama makanan",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }
                      if (state.state == ResultsCari.loading) {
                        print(state.state);
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.state == ResultsCari.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.searchResults?.restaurants.length,
                          itemBuilder: (context, index) {
                            bool isFav = state.favorites[state
                                    .searchResults?.restaurants[index].id] ??
                                false;
                            return BoxRestaurantApiTest(
                                data: state.searchResults?.restaurants[index],
                                isFav: isFav,
                                restt: state,
                                context: context,
                                route: PageDetailRestaurants.routeName);
                          },
                        );
                      } else if (state.state == ResultsCari.noData) {
                        return SizedBox(
                          height: bodyHeight,
                          child: Center(
                            child: Text("Data Restaurants Tidak Ditemukan"),
                          ),
                        );
                      } else if (state.state == ResultsCari.error) {
                        if (state.message == '404') {
                          return SizedBox(
                              height: bodyHeight,
                              child:
                                  Center(child: ComponentWidget.NoInternet()));
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
                  )
          ],
        ),
      )),
    );
  }

  Widget BoxRestaurantApiTest(
      {Restaurants? data,
      BuildContext? context,
      String? route,
      bool? isFav,
      CariRestaurantsProvider? restt}) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: GestureDetector(
            onTap: () async {
              // Navigator.pushNamed(context!, route!, arguments: data);
              bool result = await PersistentNavBarNavigator.pushNewScreen(
                context!,
                screen: PageDetailRestaurants(restaurants: data!),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );

              if (result == true) {
                restt!.getAllRestaurantsdb();
                restt.loadFavorites();
                print("Load at this");
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
                                  kota: data.city.toString(),
                                  rating: data.rate.toString(),
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
