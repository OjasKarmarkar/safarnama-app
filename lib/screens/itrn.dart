import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:safarnama/controller/dataController.dart';
import 'package:safarnama/controller/db.dart';
import 'package:safarnama/utils/colors.dart';
import 'package:safarnama/utils/utils.dart';
import 'package:safarnama/utils/wrapper.dart';

class ItrnGen extends StatefulWidget {
  const ItrnGen({Key? key}) : super(key: key);

  @override
  State<ItrnGen> createState() => _ItrnGenState();
}

class _ItrnGenState extends State<ItrnGen> {
  DataController cx = Get.find();
  double currentRating = 3;
  TextEditingController reviewController = new TextEditingController();

  @override
  void initState() {
    print(Get.arguments['city']);
    print(Get.arguments['pl']);
    cx.getItrn(Get.arguments['city'], 'Nature', Get.arguments['pl']);
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
                    child: GetBuilder<DataController>(
                      builder: (controller) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Get.arguments['pl'],
                                style: TextStyle(
                                    color: darkAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Image.network(
                                Get.arguments['img'] == null
                                    ? "https://images.unsplash.com/photo-1521427185932-e69b86608ff6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"
                                    : Get.arguments['img'],
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              !controller.isLoading
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Provide a FeedBack',
                                          style: TextStyle(
                                              color: darkAccent,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        RatingBar.builder(
                                          initialRating: 3,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            currentRating = rating;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          maxLines: 4,
                                          controller: reviewController,
                                          decoration: UiUtils.inputDecoration(
                                              context,
                                              "Provide a review (Optional)",
                                              Icons.abc),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              DataBase().updateRecData(
                                                  "developer.ojask@gmail.com",
                                                  Get.arguments['current'], {
                                                "feedback": currentRating,
                                                'review': reviewController.text,
                                                "similar_place":
                                                    Get.arguments['pl']
                                              });
                                            },
                                            icon: Icon(Icons.save_outlined))
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Itinerary (2 days) ',
                                    style: TextStyle(
                                        color: darkAccent,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        DataBase().updateRecData(
                                            "developer.ojask@gmail.com",
                                            Get.arguments['current'],
                                            {'generated_itrn': true});
                                      },
                                      icon: Icon(Icons.refresh_outlined))
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              controller.isLoading
                                  ? LoadingAnimationWidget.flickr(
                                      leftDotColor:
                                          Colors.black.withOpacity(0.8),
                                      rightDotColor: accentColor,
                                      size: 200,
                                    )
                                  : Text(controller.itrnry ??
                                      '''
Day 1 (Morning) :

Start your day early and head to Chowmahalla Palace
Explore the grand Durbar Hall and admire the intricate carvings and ornate chandeliers
Visit the Khilwat Mubarak, which used to be the seat of the Asaf Jahi dynasty
Spend some time in the Council Hall, which was used for private meetings and discussions
Afternoon:

Have lunch at the palace's cafe or head to a nearby restaurant for some local cuisine
Visit the Clock Tower and take in the stunning views of the palace complex from above
Explore the palace's extensive collection of vintage cars at the Vintage Car Museum
Take a stroll in the lush gardens of the palace and relax in the peaceful atmosphere
''')
                            ]);
                      },
                    )))));
  }
}
