import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';
import 'package:passportapp/model/user.dart';
import 'package:passportapp/services/deal_service.dart';
import 'package:passportapp/viewholders/offers_viewholder.dart';
import 'package:passportapp/services/prefs_service.dart';

class HomeScreen extends StatefulWidget {
  final ValueSetter setStateMain;
  final ValueSetter setStateSearch;
  final ValueSetter setImageURL;
  final ValueSetter setBusinessName;
  final ValueSetter setDealId;
  const HomeScreen({Key? key, required this.setStateMain, required this.setStateSearch, required this.setImageURL, required this.setBusinessName, required this.setDealId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenWidth = 0;
  double screenHeight = 0;

  int redeemed = 0;
  int savings = 0;
  String name = "";
  String tagline = "";

  List<dynamic> deals = [];
  bool buildList = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    PrefsService().getUserData().then((value) {
      List<UserData> user = value;
      setState(() {
        name = user[0].displayName!.split(" ").sublist(0, 1).join("").toString();
        redeemed = UserAttributes.offersRedeemed;
        savings = UserAttributes.savingsEarned;
      });
    });

    FirebaseAuth.instance.currentUser?.getIdTokenResult().then((value) async {
      List<dynamic> deal = await DealApi().getAllDeals(value.token);
      setState(() {
        deals = deal;
        buildList = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight / 70,),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth / 35,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: screenHeight / 4.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today in Myrtle Beach",
                            style: TextStyle(
                              fontFamily: "Actor",
                              fontSize: screenHeight / 45,
                              color: Attributes.blue,
                            ),
                          ),
                          const SizedBox(height: 4,),
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/weather_sunny.png",
                                width: screenWidth / 8,
                              ),
                              Text(
                                "${Attributes.currentTemp}°F"
                                    "\nPrecipitation: ${Attributes.currentPrecipitation}%"
                                    "\nSun Index ${Attributes.currentUV}",
                                style: TextStyle(
                                  fontFamily: "Actor",
                                  fontSize: screenHeight / 49.5,
                                  color: Attributes.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8,),
                          _stats(0),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: SizedBox(
                      height: screenHeight / 4.8,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Good\nMorning!",
                                style: TextStyle(
                                  fontFamily: "Actor",
                                  fontSize: screenHeight / 45,
                                ),
                              ),
                              Text(
                                name,
                                style: TextStyle(
                                  fontFamily: "Actor",
                                  fontSize: screenHeight / 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _stats(2),
                            ],
                          ),
                          Transform.translate(
                            offset: const Offset(0, 10),
                            child: SizedBox(
                              height: screenWidth / 4,
                              width: screenWidth / 4,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(UserAttributes.profilePicURL!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth / 20,
                vertical: screenHeight / 35,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _shortcuts("Dining", () {
                    Feedback.forTap(context);
                    // PrefsService().getUserData().then((value) {
                    //   print(value[0].token);
                    //   print(value[0].uid);
                    //   print(value[0].email);
                    //   print(value[0].displayName);
                    //   print(value[0].phone);
                    // });

                    FirebaseAuth.instance.currentUser?.getIdTokenResult().then((value) {
                      DealApi().getDealById(value.token, "632d567d80ad8aaeb7c2ca4b");
                    });
                    
                    // AuthApi().signInUser(
                    //   "emailnew@gmail.com",
                    //   "password",
                    // );

                    // widget.setStateMain(1);
                    // widget.setStateSearch(1);
                  }),
                  _shortcuts("Category", () {
                    Feedback.forTap(context);

                    // widget.setStateMain(1);
                    // widget.setStateSearch(0);
                  }),
                  _shortcuts("Near Me", () {
                    Feedback.forTap(context);
                  }),
                  _shortcuts("Most Popular", () {
                    Feedback.forTap(context);
                  }),
                ],
              ),
            ),
            _heading("Offers Near Me"),
            Container(
              height: screenHeight / 2.3,
              margin: EdgeInsets.only(
                top: screenHeight / 50,
                bottom: screenHeight / 50,
                left: screenWidth / 20,
              ),
              child: buildList ? ListView.builder(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                primary: false,
                shrinkWrap: true,
                itemCount: deals.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        Feedback.forTap(context);
                        widget.setImageURL(deals[index]['imageURL'] ?? "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg");
                        widget.setBusinessName(deals[index]['businessId']['businessName']);
                        widget.setDealId(deals[index]['_id']);
                        widget.setStateMain(6);
                      },
                      child: OffersViewHolder(
                        imageURL: deals[index]['imageURL'] ?? "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                        category: deals[index]['businessId']['category'],
                        address: deals[index]['locations'][0]['address'],
                        tagline: deals[index]['tagline'],
                        totalOffers: deals[index]['no_offers'],
                        used: deals[index]['used_deals'],
                        // (calculateDistance(Attributes.locationData?.latitude, Attributes.locationData?.longitude, lat, long) * 1000 / 1609.344)
                        //     < 99 ? "${(calculateDistance(Attributes.locationData?.latitude, Attributes.locationData?.longitude, lat, long) * 1000 / 1609.344).toStringAsFixed(0)} miles"
                        //     : "99+ miles",
                        name: deals[index]['businessId']['businessName'],
                      ),
                    ),
                  );
                },
              ) : const SizedBox(),
            ),
            UserAttributes.favoriteBusiness.trim().isNotEmpty ? _heading("Favorite Businesses") : const SizedBox(),
            // UserAttributes.favoriteBusiness.trim().isNotEmpty ? Container(
            //   height: screenHeight / 3.7,
            //   margin: EdgeInsets.only(
            //     top: screenHeight / 50,
            //     bottom: screenHeight / 50,
            //     left: screenWidth / 20,
            //   ),
            //   child: buildList ? ListView.builder(
            //     clipBehavior: Clip.none,
            //     scrollDirection: Axis.horizontal,
            //     primary: false,
            //     shrinkWrap: true,
            //     itemCount: snap.length,
            //     itemBuilder: (context, index) {
            //       if(UserAttributes.favoriteBusiness.contains(snap[index]['businessName'])) {
            //         return GestureDetector(
            //           onTap: () {
            //             Feedback.forTap(context);
            //             widget.setImageURL(snap[index]['imageURL']);
            //             widget.setBusinessName(snap[index]['businessName']);
            //             widget.setStateMain(6);
            //           },
            //           child: Container(
            //             margin: const EdgeInsets.only(right: 12),
            //             child: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 _imageClip(snap[index]['imageURL']),
            //                 Padding(
            //                   padding: const EdgeInsets.symmetric(
            //                     vertical: 8,
            //                   ),
            //                   child: Text(
            //                     snap[index]['businessName'],
            //                     style: TextStyle(
            //                       fontFamily: "Actor",
            //                       fontSize: screenHeight / 40,
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         );
            //       } else {
            //         return const SizedBox();
            //       }
            //     },
            //   ) : const SizedBox();
            // ) : const SizedBox(),
          ],
        ),
      ),
    );
  }
  
  Widget _heading(String text) {
    return Padding(
      padding: EdgeInsets.only(
        right: screenWidth / 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _headingText(text),
          _underlineText("See All"),
        ],
      ),
    );
  }

  Widget _headingText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth / 20,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Actor",
          fontSize: screenHeight / 35,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _imageClip(String image) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          image,
          fit: BoxFit.fitHeight,
          width: screenWidth / 1.6,
        ),
      ),
    );
  }

  Widget _underlineText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Actor",
        fontWeight: FontWeight.w400,
        fontSize: screenHeight / 49.5,
        decoration: TextDecoration.underline,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _shortcuts(String text, VoidCallback function) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: screenHeight / 22,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth / 25,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color(0xFFEFEFEF),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: "Actor",
              fontSize: screenHeight / 55,
            ),
          ),
        ),
      ),
    );
  }

  Widget _stats(int options) {
    return Container(
      height: screenHeight / 13,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: options == 0 ? Attributes.lightBlue : Attributes.yellow,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Transform.translate(
                offset: Offset(0, options == 0 ? -8 : -2),
                child: Text(
                  options == 0 ? redeemed.toString()
                      : "\$$savings",
                  style: TextStyle(
                    fontFamily: "Actor",
                    fontSize: options == 0 ? screenHeight / 15 : screenHeight / 20,
                    color: options == 0 ? Attributes.blue : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Transform.translate(
                offset: Offset(options == 0 ? -5 : 10, options == 0 ? 0 : 5),
                child: Text(
                  options == 0 ? (redeemed > 1 ? "Offers\nRedeemed" : "Offer\nRedeemed")
                      : (savings > 1 ? "Savings\nEarned" : "Saving\nEarned"),
                  style: TextStyle(
                    fontFamily: "Actor",
                    fontSize: options == 0 ? screenHeight / 45 : screenHeight / 55,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
