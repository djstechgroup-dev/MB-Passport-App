import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/model/user.dart';
import 'package:passportapp/viewholders/saved_deals_viewholder.dart';

import '../services/deal_service.dart';

class RedeemScreen extends StatefulWidget {
  final ValueSetter setStateMain;
  final ValueSetter setImageURL;
  final ValueSetter setBusinessName;
  final ValueSetter setDealId;

  const RedeemScreen({Key? key,
    required this.setStateMain, required this.setImageURL, required this.setBusinessName, required this.setDealId,
  }) : super(key: key);

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  double screenWidth = 0;
  double screenHeight = 0;

  Future<List<dynamic>> getSavedDeals() async {
    List<dynamic> deals = [];
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
      List<dynamic> deal = await DealApi().getAllDeals(token?.token);

      for(int i = 0; i < deal.length; i++) {
        if(UserAttributes.savedDeals.contains(deal[i]['_id'])) {
          deals.add(deal[i]);
        }
      }
      return deals;
    } catch(e) {
      return deals;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    late Widget body;

    if(UserAttributes.savedDeals.trim().isEmpty) {
      body = Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth / 15,
          ),
          child: Text(
            "You have not save any deals yet.",
            style: TextStyle(
              fontFamily: "Actor",
              fontSize: screenHeight / 25,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      body = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight / 70,),
            _headings("Recently Saved"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: EdgeInsets.only(
                  left: screenWidth / 20,
                ),
                child: FutureBuilder(
                  future: getSavedDeals(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if(snapshot.hasData) {
                      return Row(
                        children: [
                          for(int i = 0; i < snapshot.data.length; i++)...<Widget>[
                            GestureDetector(
                              onTap: () {
                                Feedback.forTap(context);
                                widget.setImageURL(snapshot.data[i]['imageURL'] ?? "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg");
                                widget.setBusinessName(snapshot.data[i]['businessId']['businessName']);
                                widget.setDealId(snapshot.data[i]['_id']);
                                widget.setStateMain(6);
                              },
                              child: SavedDealsViewHolder(
                                imageURL: snapshot.data[i]['imageURL'] ?? "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                                businessName: snapshot.data[i]['businessId']['businessName'],
                                tagline: snapshot.data[i]['tagline'],
                                options: 0,
                              ),
                            ),
                          ],
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  }
                ),
              ),
            ),
            _headings("All Saved Deals"),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth / 20),
                child: FutureBuilder(
                  future: getSavedDeals(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if(snapshot.hasData) {
                      return Column(
                        children: [
                          for(int i = 0; i < snapshot.data.length; i++)...<Widget>[
                            GestureDetector(
                              onTap: () {
                                Feedback.forTap(context);
                                widget.setImageURL(snapshot.data[i]['imageURL'] ?? "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg");
                                widget.setBusinessName(snapshot.data[i]['businessId']['businessName']);
                                widget.setDealId(snapshot.data[i]['_id']);
                                widget.setStateMain(6);
                              },
                              child: SavedDealsViewHolder(
                                imageURL: snapshot.data[i]['imageURL'] ?? "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                                businessName: snapshot.data[i]['businessId']['businessName'],
                                tagline: snapshot.data[i]['tagline'],
                                options: 1,
                              ),
                            ),
                          ],
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: body,
    );
  }

  Widget _headings(String text) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth / 20,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Actor",
          fontSize: screenHeight / 25,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

}
