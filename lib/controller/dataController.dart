import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DataController extends GetxController {
  RxString city = RxString('Mumbai');
  bool isLoading = false;
  String? itrnry;

  @override
  void onInit() {
    //getLocBased();
    getLocation();
    super.onInit();
  }

  void getLocation() {
    try {
      http.get(Uri.parse('http://ip-api.com/json')).then((value) {
        city.value = json.decode(value.body)['city'];
      });
    } catch (err) {
      //handleError
    }
  }

  void getItrn(String city, String cat, String place) {
    update();
    isLoading = true;
    try {
      http
          .post(
              Uri.parse(
                  'https://api.writesonic.com/v2/business/content/ans-my-ques?num_copies=1'),
              headers: {
                'X-API-KEY': '85d1925a-bd06-4e92-afbf-5b248dcc2d9a',
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({
                'question':
                    'Generate 2 day itinerary of $cat places nearby and including $place'
              }))
          .then((value) {
        isLoading = false;
        update();
        print(value.body);
        print(jsonDecode(value.body)[0]['text']);

        if (jsonDecode(value.body)[0] != null) {
          itrnry = jsonDecode(value.body)[0]['text'];
        }
      });
    } catch (err) {
      isLoading = false;
      print(err);
      //handleError
    }
    update();
  }
}
