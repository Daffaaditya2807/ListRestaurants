import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_with_api/component/widget_build.dart';
import 'package:restaurant_with_api/provider/connectionprovider.dart';

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
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double topPadding = MediaQuery.of(context).padding.top;
    double appBarHeight = kToolbarHeight;
    double heightSearch = 50.0;
    double bodyHeight = screenHeight - topPadding - appBarHeight - heightSearch;

    print(screenHeight);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Cari Restaurants"),
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
                      if (state.state == ResulState.first) {
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
                      if (state.state == ResulState.loading) {
                        print(state.state);
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.state == ResulState.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.searchResults?.restaurants.length,
                          itemBuilder: (context, index) {
                            return ComponentWidget.BoxRestaurantApi(
                                data: state.searchResults?.restaurants[index],
                                context: context,
                                route: PageDetailRestaurants.routeName);
                          },
                        );
                      } else if (state.state == ResulState.noData) {
                        return SizedBox(
                          height: bodyHeight,
                          child: Center(
                            child: Text("Data Restaurants Tidak Ditemukan"),
                          ),
                        );
                      } else if (state.state == ResulState.error) {
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
}
