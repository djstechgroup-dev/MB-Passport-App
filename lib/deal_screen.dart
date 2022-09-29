import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';
import 'package:passportapp/model/deal.dart';
import 'package:passportapp/services/deal_service.dart';
import 'package:passportapp/services/prefs_service.dart';
import 'package:share_plus/share_plus.dart';

import 'model/user.dart';

class DealScreen extends StatefulWidget {
  final String dealId;

  const DealScreen({Key? key, required this.dealId,}) : super(key: key);

  @override
  State<DealScreen> createState() => _DealScreenState();
}

class _DealScreenState extends State<DealScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  int saveButtonState = 0;
  int likeButtonState = 0;
  int totalUsed = 0;
  int totalOffers = 0;

  String dealId = " ";
  String businessId = " ";
  String businessName = " ";
  String imageURL = "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg";
  String category = " ";
  String tagline = " ";
  String operatingHours = " ";
  String location = " ";
  String description = " ";
  String distance = "<1 Miles";

  List<dynamic> otherDeals = [];

  bool buildUI = false;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _getDealsData(widget.dealId);
  }

  void _getUserFavorite() {
    if(UserAttributes.favoriteBusiness.contains(businessId)) {
      setState(() {
        likeButtonState = 1;
      });
    } else {
      setState(() {
        likeButtonState = 0;
      });
    }
    print("FAVORITE BUSINESS : ${UserAttributes.favoriteBusiness}");
  }

  void _getUserSaved() {
    if(UserAttributes.savedDeals.contains(dealId)) {
      setState(() {
        saveButtonState = 1;
      });
    } else {
      setState(() {
        saveButtonState = 0;
      });
    }
    print("SAVED DEALS : ${UserAttributes.savedDeals}");
  }

  void _setAsFavorite() async {
    PrefsService().getUserData().then((value) async {
      String favBusiness = UserAttributes.favoriteBusiness == " " ? "$businessId, " : "${UserAttributes.favoriteBusiness}$businessId, ";
      setState(() {
        UserAttributes.favoriteBusiness = favBusiness;
      });
      // await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid).update({
      //   'favoriteBusiness': favBusiness,
      // });
      setState(() {
        likeButtonState = 1;
      });
      print("FAVORITE BUSINESS : ${UserAttributes.favoriteBusiness}");
    });
  }

  void _unFavorite() async {
    PrefsService().getUserData().then((value) async {
      String favBusiness = UserAttributes.favoriteBusiness.replaceAll("$businessId, ", "");
      setState(() {
        UserAttributes.favoriteBusiness = favBusiness;
      });
      // await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid).update({
      //   'favoriteBusiness': favBusiness,
      // });
      setState(() {
        likeButtonState = 0;
      });
      print("FAVORITE BUSINESS : ${UserAttributes.favoriteBusiness}");
    });
  }

  void _saveDeal() async {
    PrefsService().getUserData().then((value) async {
      String savedDeals = UserAttributes.savedDeals == " " ? "$dealId, " : "${UserAttributes.savedDeals}$dealId, ";
      setState(() {
        UserAttributes.savedDeals = savedDeals;
      });
      // await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid).update({
      //   'savedDeals': savedDeals,
      // });
      setState(() {
        saveButtonState = 1;
      });
      print("SAVED DEALS : ${UserAttributes.savedDeals}");
    });
  }

  void _unSaveDeal() async {
    PrefsService().getUserData().then((value) async {
      String savedDeals = UserAttributes.savedDeals.replaceAll("$dealId, ", "");
      setState(() {
        UserAttributes.savedDeals = savedDeals;
      });
      // await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid).update({
      //   'savedDeals': savedDeals,
      // });
      setState(() {
        saveButtonState = 0;
      });
      print("SAVED DEALS : ${UserAttributes.savedDeals}");
    });
  }

  Future<void> _getDealsData(String id) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    DealData deal = await DealApi().getDealById(token?.token, id);

    // checkIsOpen(deal[0]['businessId']['openingTime']['day'], deal[0]['businessId']['openingTime']['day']).then((value) {
    //   setState(() {
    //     isOpen = value;
    //   });
    // });
    //
    // setOperatingHours(snap.docs[0]['operatingHourStart'], snap.docs[0]['operatingHourEnd']).then((value) {
    //   setState(() {
    //     operatingHours = value;
    //   });
    // });
    //
    // final double lat = double.parse(snap.docs[0]['address'].split(", ").sublist(0, 1).join(""));
    // final double long = double.parse(snap.docs[0]['address'].split(", ").sublist(1, 2).join(""));
    //
    setState(() {
      dealId = widget.dealId;
      businessId = deal.businessId!;
      businessName = deal.businessName!;
      imageURL = deal.imageURL ?? imageURL;
      category = deal.category!;
      // distance = (calculateDistance(Attributes.locationData?.latitude, Attributes.locationData?.longitude, lat, long) * 1000 / 1609.344)
      //     < 99 ? "${(calculateDistance(Attributes.locationData?.latitude, Attributes.locationData?.longitude, lat, long) * 1000 / 1609.344).toStringAsFixed(0)} miles from you"
      //     : "99+ miles from you";
      totalUsed = deal.totalUsed!;
      totalOffers = deal.totalOffers!;
      tagline = deal.tagline!;
      location = deal.address!;
      description = deal.description!;
      otherDeals = deal.otherDeals!;
    });
    _getUserFavorite();
    _getUserSaved();
  }

  double calculateDistance(lat1, long1, lat2, long2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((long2 - long1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  Future<String> setOperatingHours(int i, j) async {
    String start = await convertHours(i);
    String end = await convertHours(j);
    String output = "$start-$end";

    return output;
  }

  Future<String> convertHours(int hour) async {
    String output;
    if(hour > 12) {
      output = "${hour - 12}pm";
      return output;
    } else {
      output = "${hour}am";
      return output;
    }
  }

  Future<bool> checkIsOpen(int start, int end) async {
    if(DateTime.now().hour >= start && DateTime.now().hour <= end) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bigImage(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth / 20,
                vertical: screenWidth / 20,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: screenWidth,
                    child: _titleAndHeart(),
                  ),
                  const SizedBox(height: 4,),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth / 20,
                    ),
                    child: Column(
                      children: [
                        _labels(),
                        const SizedBox(height: 12,),
                        _coupon(),
                        const SizedBox(height: 12,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Feedback.forTap(context);
                                saveButtonState == 0 ? _saveDeal() : _unSaveDeal();
                              },
                              child: saveButtonState == 0 ? _button1("saveIcon", "Save") : _button1("unsaveIcon", "Unsave"),
                            ),
                            _button2("redeemIcon", "Redeem"),
                            GestureDetector(
                              onTap: () {
                                Share.share("Hey check out this!");
                              },
                              child: _button1("shareIcon", "Share"),
                            ),
                          ],
                        ),
                        _distanceLocation(),
                        _divider(),
                        Text(
                          description,
                          style: TextStyle(
                            fontFamily: "Actor",
                            fontSize: screenHeight / 71,
                            color: Colors.black54,
                          ),
                        ),
                        _divider(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Other Deals from this Vendor",
                            style: TextStyle(
                              fontFamily: "Actor",
                              fontSize: screenHeight / 50,
                            ),
                          ),
                        ),
                        FutureBuilder(
                          future: getOtherDeals(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            } else {
                              return ListView.builder(
                                clipBehavior: Clip.none,
                                scrollDirection: Axis.vertical,
                                primary: false,
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 8,
                                      left: 8,
                                      right: 8,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          dealId = snapshot.data[index].id;
                                          businessName = snapshot.data[index].businessName!;
                                          imageURL = snapshot.data[index].imageURL ?? imageURL;
                                          category = snapshot.data[index].category!;
                                          // distance = (calculateDistance(Attributes.locationData?.latitude, Attributes.locationData?.longitude, lat, long) * 1000 / 1609.344)
                                          //     < 99 ? "${(calculateDistance(Attributes.locationData?.latitude, Attributes.locationData?.longitude, lat, long) * 1000 / 1609.344).toStringAsFixed(0)} miles from you"
                                          //     : "99+ miles from you";
                                          totalUsed = snapshot.data[index].totalUsed!;
                                          totalOffers = snapshot.data[index].totalOffers!;
                                          tagline = snapshot.data[index].tagline!;
                                          location = snapshot.data[index].address!;
                                          description = snapshot.data[index].description!;
                                          otherDeals = snapshot.data[index].otherDeals!;
                                        });
                                      },
                                      child: _otherDealsItem(snapshot.data[index].tagline),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        _divider(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bigImage() {
    return SizedBox(
      height: screenHeight / 3,
      width: screenWidth,
      child: Image.network(
        imageURL,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _titleAndHeart() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth / 8,
          ),
          child: Center(child: _title(businessName)),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12,
            ),
            child: GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                likeButtonState == 0 ? _setAsFavorite() : _unFavorite();
              },
              child: Image.asset(
                likeButtonState == 0 ? "assets/images/heartIcon_grey.png" : "assets/images/heartIcon.png",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _labels() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _label(0, category),
        _label(1, isOpen ? "Open Today" : "Closed Today"),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              operatingHours,
              style: TextStyle(
                fontFamily: "Actor",
                fontSize: screenHeight / 55,
                color: Colors.black,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ],
    );
  }

  Widget _coupon() {
    return DottedBorder(
      dashPattern: const [12, 6],
      child: Container(
        height: screenHeight / 12,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Attributes.yellow,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                tagline,
                style: TextStyle(
                  fontFamily: "Actor",
                  fontSize: screenHeight / 35,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            _smallerText(
              "Used $totalUsed time${totalUsed > 1 ? "s" : ""}",
              Alignment.bottomLeft,
              TextAlign.start,
            ),
            _smallerText(
              "${totalOffers - totalUsed} remaining",
              Alignment.bottomRight,
              TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }

  Widget _distanceLocation() {
    return Row(
      children: [
        Image.asset(
          "assets/images/pinLocation_outlined.png",
        ),
        const SizedBox(width: 8,),
        SizedBox(
          width: screenWidth / 1.5,
          child: RichText(
            text: TextSpan(
              text: "$distance\n",
              style: TextStyle(
                fontFamily: "Actor",
                fontSize: screenHeight / 50,
                color: Attributes.blue,
              ),
              children: [
                TextSpan(
                  text: location,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<List<DealData>> getOtherDeals() async {
    List<DealData> dealData = [];
    for(int i = 0; i < otherDeals.length; i++) {
      if(otherDeals[i] != dealId) {
        final token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
        DealData deal = await DealApi().getDealById(token?.token, otherDeals[i]);

        dealData.add(deal);
      }
    }

    return dealData;
  }

  Widget _otherDealsItem(String text) {
    return Row(
      children: [
        _otherDealsIcon(),
        const SizedBox(width: 8,),
        Text(
          text,
          style: TextStyle(
            fontFamily: "Actor",
            fontSize: screenHeight / 60,
          ),
        ),
      ],
    );
  }

  Widget _otherDealsIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset("assets/images/deal_info_bg.png"),
        Image.asset("assets/images/deal_info.png"),
      ],
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Divider(
        color: Colors.black26,
      ),
    );
  }

  Widget _button1(String image, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth / 18,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Attributes.blue),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screenWidth / 8,
            child: Image.asset(
              "assets/images/$image.png",
              width: screenWidth / 8,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontFamily: "Actor",
              fontSize: screenHeight / 50,
              color: Attributes.blue,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _button2(String image, String text) {
    return Transform.translate(
      offset: Offset(0, -screenWidth / 18),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth / 25,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Attributes.blue,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenWidth / 6,
              child: Image.asset(
                "assets/images/$image.png",
                width: screenWidth / 6,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontFamily: "Actor",
                fontSize: screenHeight / 50,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallerText(String text, Alignment alignment, TextAlign align) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.only(
          left: alignment == Alignment.bottomRight ? 0 : 8,
          right: alignment == Alignment.bottomRight ? 8 : 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Actor",
            fontSize: screenHeight / 60,
            color: alignment == Alignment.bottomRight ? Colors.red : Colors.green,
          ),
          textAlign: align,
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Actor",
        fontSize: screenHeight / 25,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _label(int options, String text) {
    return Container(
      height: screenHeight / 30,
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 4,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: options == 0 ? const Color(0xFFE1EAFC) : (isOpen ? const Color(0xFFD9FBE8) : Colors.redAccent),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Actor",
            color: options == 0 ? Attributes.blue : (isOpen ? Colors.green : Colors.white),
            fontSize: screenHeight / 55,
          ),
        ),
      ),
    );
  }

}
