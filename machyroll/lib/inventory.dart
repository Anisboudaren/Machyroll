import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:machyroll/Figuier_Page.dart';

// ignore: camel_case_types
class inventory extends StatefulWidget {
  const inventory({Key? key}) : super(key: key);

  @override
  State<inventory> createState() => _inventoryState();
}

// ignore: camel_case_types
class _inventoryState extends State<inventory> {
  bool _isSearching = false;

  TextStyle linkStyle = const TextStyle(color: Colors.grey, fontSize: 20.0);
  List<dynamic> itemsData = [];
  List<dynamic> itemsIds = [];
  //fetch data
  Future getItemsIds() async {
    itemsData = [];
    itemsIds = [];
    await FirebaseFirestore.instance
        .collection("figures")
        .get()
        .then((snapshot) => {
              snapshot.docs.forEach((doc) {
                print(doc.reference.id);
                print(snapshot.docs.length);
                itemsData.add(doc.data());
                itemsIds.add(doc.reference.id);
              })
            });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/pics/bg_alone.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: const Color.fromARGB(255, 25, 24, 28),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 25, 24, 28),
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 25, 24, 28)),
                    ),
                    child: const Icon(
                      Icons.sort_rounded,
                      color: Colors.white,
                      size: 35,
                    )),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _isSearching
                          ? MediaQuery.of(context).size.width * 0.6
                          : 0,
                      child: _isSearching
                          ? TextField(
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(color: Colors.white),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 25, 24, 28)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 25, 24, 28)),
                                ),
                              ),
                              onChanged: (value) {
                                // Perform search operation here
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
          body: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              // ignore: prefer_const_constructors
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: FutureBuilder(
                      future: getItemsIds(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                            itemCount: itemsIds.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FiguierPage(
                                                  itemsIds[index])));
                                    },
                                    child: itemDisplay(
                                        //dakhal les information manually hnaya b tartib t3 al function li mn ta7t b3d
                                        itemsData[index]["title"],
                                        itemsData[index]["description"],
                                        itemsData[index]["imageUrl"],
                                        itemsData[index]["price"].toDouble(),
                                        itemsData[index]["sold"].toDouble(),
                                        itemsData[index]["state"]),
                                  ),
                                  const SizedBox(
                                    height: 0,
                                  )
                                ],
                              );
                            });
                      }))
            ]),
          ),
        ),
      ],
    );
  }
}

Widget itemDisplay(String title, String description, String imageUrl,
    double price, double sold, String state) {
  return Container(
    color: const Color.fromARGB(0, 255, 255, 255),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 130,
                height: 130,
                child: Image.network(imageUrl),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            const TextStyle(fontSize: 17, color: Colors.white),
                      ),
                      Text(
                        description,
                        style:
                            const TextStyle(fontSize: 17, color: Colors.white),
                      ),
                      RatingBar.builder(
                        initialRating: 3.5,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20.0,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      Row(
                        children: [
                          Text(price.toString(),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.green)),
                          const SizedBox(width: 10),
                          Text(sold.toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 2.0)),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 163, 59),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            child: Text(
                              state,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 237, 222, 222),
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            color: Colors.white,
          )
        ],
      ),
    ),
  );
}
