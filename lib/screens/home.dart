import 'dart:convert';
import 'dart:ui';

import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safarnama/controller/dataController.dart';
import 'package:safarnama/screens/login.dart';
import 'package:safarnama/screens/similar.dart';
import 'package:safarnama/utils/colors.dart';
import 'package:safarnama/utils/wrapper.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final city = GetStorage().read('city') ?? "Mumbai";
  final ageGrp = GetStorage().read('age') ?? "Y";

  Future<Map<String, dynamic>> fetchData() async {
    var url = Uri.parse('http://10.0.2.2:5000/city');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "city": [city]
        }));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return json.decode(response.body);
  }

  double _sigmaX = 0.0; // from 0-10
  double _sigmaY = 0.0; // from 0-10
  double _opacity = 0.1; // from 0-1.0

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await GetStorage().erase();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => Login(),
      ),
    );
  }

  @override
  void initState() {
    fetchUserRec();
    // TODO: implement initState
    super.initState();
  }

  final controller = Get.put(DataController());

  Future<Map<String, dynamic>> fetchNearby() async {
    var url = Uri.parse('http://10.0.2.2:5000/city');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "city": [controller.city.value]
        }));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> fetchAgeGrp() async {
    var url = Uri.parse('http://10.0.2.2:5000/byAge');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"age": ageGrp.toString().toLowerCase()}));
    print('Age status: ${response.statusCode}');
    print('Age body: ${response.body}');
    print(response.body);

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> fetchUserRec() async {
    var url = Uri.parse('http://10.0.2.2:5000/topCity');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    print('City status: ${response.statusCode}');
    print('City body: ${response.body}');

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return themeWrapper(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text("Welcome , Ojas")),
                  IconButton(
                      onPressed: () {
                        _signOut();
                      },
                      icon: Icon(FeatherIcons.logOut))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Obx(() => RichText(
                    text: TextSpan(
                      text: 'Because you live in,\n',
                      style: GoogleFonts.montserrat(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 20)),
                      children: <TextSpan>[
                        TextSpan(
                          text: "${controller.city}",
                          style: TextStyle(
                              color: darkAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
              FutureBuilder(
                builder: (ctx, snapshot) {
                  // Checking if future is resolved or not
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If we got an error
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: TextStyle(fontSize: 18),
                        ),
                      );

                      // if we got our data
                    } else if (snapshot.hasData) {
                      // Extracting data from snapshot object
                      Map<String, dynamic> data =
                          snapshot.data as Map<String, dynamic>;
                      List<Map<String, dynamic>> places = [];
                      data[controller.city.value]['images'].forEach((i, value) {
                        places.add({"name": i, "image": value});
                      });

                      return SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(0),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: places.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        SimilarPlaces(
                                            place: places[index]['name'],
                                            city: city),
                                  ),
                                );
                              },
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Stack(
                                  children: [
                                    ImageFiltered(
                                        imageFilter: ImageFilter.blur(
                                            sigmaX: 2, sigmaY: 2),
                                        child: Image.network(
                                          places[index]['image'],
                                          fit: BoxFit.fill,
                                        )),
                                    Positioned(
                                        bottom: 10,
                                        left: 10,
                                        child: Text(
                                          places[index]['name'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }

                  // Displaying LoadingSpinner to indicate waiting state
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },

                // Future that needs to be resolved
                // inorder to display something on the Canvas
                future: fetchNearby(),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  text: 'Top Cities,\n',
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(color: Colors.black, fontSize: 20)),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Recommended for you\n",
                      style: TextStyle(
                          color: darkAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                builder: (ctx, snapshot) {
                  // Checking if future is resolved or not
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If we got an error
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: TextStyle(fontSize: 18),
                        ),
                      );

                      // if we got our data
                    } else if (snapshot.hasData) {
                      // Extracting data from snapshot object
                      dynamic data = snapshot.data as Map<String, dynamic>;
                      data = data['response'];

                      return SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(0),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute<void>(
                                //     builder: (BuildContext context) =>
                                //         SimilarPlaces(
                                //             place: places[index]['name'],
                                //             city: city),
                                //   ),
                                // );
                              },
                              child: Container(
                                width: 160,
                                child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data[index][0],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.bar_chart_outlined),
                                            Text(
                                              '${data[index][1]['score']}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }

                  // Displaying LoadingSpinner to indicate waiting state
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },

                // Future that needs to be resolved
                // inorder to display something on the Canvas
                future: fetchUserRec(),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  text: 'Top Places,\n',
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(color: Colors.black, fontSize: 20)),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Catered for your age\n",
                      style: TextStyle(
                          color: darkAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                builder: (ctx, snapshot) {
                  // Checking if future is resolved or not
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If we got an error
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: TextStyle(fontSize: 18),
                        ),
                      );

                      // if we got our data
                    } else if (snapshot.hasData) {
                      // Extracting data from snapshot object
                      dynamic data = snapshot.data as Map<String, dynamic>;
                      data = data[ageGrp.toString().toLowerCase()]['Suggested'];
                      print(data);
                      return SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(0),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        SimilarPlaces(
                                            place: data[index][0],
                                            city: city),
                                  ),
                                );
                              },
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Stack(
                                  children: [
                                    ImageFiltered(
                                        imageFilter: ImageFilter.blur(
                                            sigmaX: 2, sigmaY: 2),
                                        child: Image.network(
                                          data[index][1][0],
                                          fit: BoxFit.fill,
                                        )),
                                    Positioned(
                                        bottom: 10,
                                        left: 10,
                                        child: Text(
                                          data[index][0],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                              ),
                            );
                          },
                        ),
                      );
                      // return SizedBox(
                      //   height: 130,
                      //   child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     padding: EdgeInsets.all(0),
                      //     physics: const BouncingScrollPhysics(),
                      //     shrinkWrap: true,
                      //     itemCount: data.length,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       return InkWell(
                      //         onTap: () {
                      //           // Navigator.push(
                      //           //   context,
                      //           //   MaterialPageRoute<void>(
                      //           //     builder: (BuildContext context) =>
                      //           //         SimilarPlaces(
                      //           //             place: places[index]['name'],
                      //           //             city: city),
                      //           //   ),
                      //           // );
                      //         },
                      //         child: Container(
                      //           width: 160,
                      //           child: Card(
                      //             semanticContainer: true,
                      //             clipBehavior: Clip.antiAliasWithSaveLayer,
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: Column(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 children: [
                      //                   Text(
                      //                     data[index][0],
                      //                     style: TextStyle(
                      //                         color: Colors.black,
                      //                         fontSize: 18,
                      //                         fontWeight: FontWeight.bold),
                      //                   ),
                      //                   Row(
                      //                     children: [
                      //                       Icon(Icons.bar_chart_outlined),
                      //                       Text(
                      //                         '${data[index][1][0]}',
                      //                         style: TextStyle(
                      //                             color: Colors.black,
                      //                             fontSize: 18,
                      //                             fontWeight: FontWeight.bold),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(10.0),
                      //             ),
                      //             elevation: 5,
                      //             margin: EdgeInsets.symmetric(
                      //                 horizontal: 5, vertical: 10),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // );
                    }
                  }

                  // Displaying LoadingSpinner to indicate waiting state
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },

                // Future that needs to be resolved
                // inorder to display something on the Canvas
                future: fetchAgeGrp(),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Popular Spots in'),
              Text(
                city ?? "",
                style: TextStyle(
                    color: darkAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                builder: (ctx, snapshot) {
                  // Checking if future is resolved or not
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If we got an error
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: TextStyle(fontSize: 18),
                        ),
                      );

                      // if we got our data
                    } else if (snapshot.hasData) {
                      // Extracting data from snapshot object
                      Map<String, dynamic> data =
                          snapshot.data as Map<String, dynamic>;
                      List<Map<String, dynamic>> places = [];
                      data[city]['images'].forEach((i, value) {
                        places.add({"name": i, "image": value});
                      });

                      return ListView.builder(
                        //  scrollDirection: Axis.v,
                        padding: EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: places.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      SimilarPlaces(
                                    place: places[index]['name'],
                                    city: city,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Stack(
                                children: [
                                  ImageFiltered(
                                      imageFilter: ImageFilter.blur(
                                          sigmaX: 2, sigmaY: 2),
                                      child: Image.network(
                                        places[index]['image'],
                                        fit: BoxFit.fill,
                                      )),
                                  Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Text(
                                        places[index]['name'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ))
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              margin: EdgeInsets.symmetric(vertical: 10),
                            ),
                          );
                        },
                      );
                    }
                  }

                  // Displaying LoadingSpinner to indicate waiting state
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },

                // Future that needs to be resolved
                // inorder to display something on the Canvas
                future: fetchData(),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
