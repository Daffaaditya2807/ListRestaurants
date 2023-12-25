import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_with_api/component/widget_build.dart';
import 'package:restaurant_with_api/model/list_restaurants.dart';

import '../model/detail_restaurants.dart';
import '../provider/connectionprovider.dart';

class PageDetailRestaurants extends StatefulWidget {
  static String routeName = '/detail_list_restaurants';
  final Restaurants restaurants;

  const PageDetailRestaurants({Key? key, required this.restaurants})
      : super(key: key);

  @override
  State<PageDetailRestaurants> createState() => _DetailRestaurantsState();
}

class _DetailRestaurantsState extends State<PageDetailRestaurants> {
  bool addreviews = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nama = TextEditingController();
  TextEditingController _comment = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<DetailRestaurantProvider>(context, listen: false);
      provider.fetchDetailRestaurant(widget.restaurants.id);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviewProvider =
        Provider.of<ReviewsAddProviders>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurant Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<DetailRestaurantProvider>(
        builder: (context, state, _) {
          if (state.state == ResulState.loading) {
            print("object");
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.state == ResulState.hasData) {
            print("sini ka");
            return BuildDetailRestaurants(
              restaurants: state.detail,
              pressed: () {
                if (_formKey.currentState!.validate()) {
                  reviewProvider
                      .addReview(
                          widget.restaurants.id, _nama.text, _comment.text)
                      .then((value) {
                    final snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Succes',
                        message: ' Send Reviews success',

                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                        contentType: ContentType.success,
                      ),
                    );
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                    _comment.clear();
                  });
                }
              },
            );
          } else if (state.state == ResulState.noData) {
            return Center(
              child: Material(
                child: Text(state.message),
              ),
            );
          } else if (state.state == ResulState.error) {
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
    );
  }

  Widget BuildDetailRestaurants(
      {DetailRestaurants? restaurants, VoidCallback? pressed}) {
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
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://restaurant-api.dicoding.dev/images/large/${restaurants!.pictureId}"),
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
                  "${restaurants.name}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Text(
                  "${restaurants.city} | rate: ${restaurants.rating.toString()}",
                  style: TextStyle(fontSize: 14.0),
                )
              ],
            ),
            Text(
              "${restaurants.address}",
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Categori Restaurants",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ListView.builder(
                itemCount: restaurants.categories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("${restaurants.categories[index].name}"),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            Text(
              "${restaurants.description}",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(
              height: 10,
            ),
            buildMenuList(restaurants.menus.foods, 'Foods', "assets/foods.jpg"),
            const SizedBox(
              height: 10,
            ),
            buildMenuList(
                restaurants.menus.drinks, 'Drinks', "assets/drinks.png"),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text("Add Reviews"),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (addreviews == false) {
                                  addreviews = true;
                                  print("sini true ${addreviews}");
                                } else {
                                  addreviews = false;
                                  print("sini false ${addreviews}");
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
                      firstChild:
                          Container(height: 0), // Widget saat addreviews false
                      secondChild: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InputReviews(
                                      controller: _nama,
                                      icons: Icons.person,
                                      label: "Name"),
                                  InputReviews(
                                      controller: _comment,
                                      icons: Icons.comment,
                                      label: "Reviews"),
                                  ElevatedButton(
                                      onPressed: pressed,
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: Size.fromHeight(50),
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.blue.shade200,
                                          side: const BorderSide(
                                              color: Colors.grey),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      child: const Text(
                                        "Send Reviews",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
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
            buildCustomerReviews(restaurants.customerReviews),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton({VoidCallback? pressed}) {
    return ElevatedButton(
        onPressed: pressed,
        style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue.shade200,
            side: const BorderSide(color: Colors.grey),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: const Text(
          "Send Reviews",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ));
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

  Widget InputReviews(
      {TextEditingController? controller, String? label, IconData? icons}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        style: const TextStyle(fontSize: 12),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        cursorColor: Colors.grey.shade400,
        controller: controller,
        onChanged: (value) {
          print(value);
        },
        decoration: InputDecoration(
            label: Text("${label}"),
            prefixIcon: Icon(icons),
            labelStyle: TextStyle(fontSize: 12, color: Colors.black),
            contentPadding: EdgeInsets.all(10),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            errorBorder: controller!.text.isEmpty
                ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                : OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey))),
      ),
    );
  }
}
