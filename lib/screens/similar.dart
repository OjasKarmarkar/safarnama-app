import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:safarnama/screens/itrn.dart';
import 'package:safarnama/utils/wrapper.dart';

import '../utils/colors.dart';

class SimilarPlaces extends StatefulWidget {
  final String? place;
  final String? city;
  const SimilarPlaces({Key? key, required this.place , required this.city}) : super(key: key);

  @override
  State<SimilarPlaces> createState() => _SimilarPlacesState();
}

class _SimilarPlacesState extends State<SimilarPlaces> {
  Future<Map<String, dynamic>> fetchData() async {
    var url = Uri.parse('http://10.0.2.2:5000/placeName');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "place": [widget.place]
        }));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return json.decode(response.body);
  }

  double _sigmaX = 0.0; // from 0-10
  double _sigmaY = 0.0; // from 0-10
  double _opacity = 0.1; // from 0-1.0

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              Text("Because you seem to like"),
              Text(
                widget.place!,
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
                      print(snapshot.data);
                      // Extracting data from snapshot object
                      Map<String, dynamic> data =
                          snapshot.data as Map<String, dynamic>;
                      List<dynamic> places = data[widget.place]['Suggested'];
                      return ListView.builder(
                        padding: EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: places.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () {
                                Get.to(ItrnGen(),
                                    arguments: {'pl' :  places[index][0] , 'city' : widget.city , 'img' : places[index][1][0] , 'current' : widget.place});
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
                                          places[index][1].length == 0
                                              ? "https://images.unsplash.com/photo-1521427185932-e69b86608ff6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"
                                              : places[index][1][0],
                                          fit: BoxFit.fill,
                                        )),
                                    Positioned(
                                        bottom: 10,
                                        left: 10,
                                        child: Text(
                                          places[index][0],
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
                              ));
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
