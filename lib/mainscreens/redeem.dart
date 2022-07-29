import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/model/user.dart';
import 'package:passportapp/viewholders/saved_deals_viewholder.dart';

class RedeemScreen extends StatefulWidget {
  final ValueSetter setStateMain;
  final ValueSetter setImageURL;
  final ValueSetter setBusinessName;

  const RedeemScreen({Key? key,
    required this.setStateMain, required this.setImageURL, required this.setBusinessName,
  }) : super(key: key);

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  double screenWidth = 0;
  double screenHeight = 0;

  Stream<QuerySnapshot> businessStream = FirebaseFirestore.instance
      .collection("Business").snapshots();

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
                padding: EdgeInsets.only(left: screenWidth / 20),
                child: StreamBuilder<QuerySnapshot>(
                  stream: businessStream,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      final snap = snapshot.data!.docs;
                      return Row(
                        children: [
                          for(int i = 0; i < snap.length; i++)...<Widget>[
                            UserAttributes.savedDeals.contains(snap[i]['businessName']) ? GestureDetector(
                              onTap: () {
                                Feedback.forTap(context);
                                widget.setImageURL(snap[i]['imageURL']);
                                widget.setBusinessName(snap[i]['businessName']);
                                widget.setStateMain(6);
                              },
                              child: SavedDealsViewHolder(
                                imageURL: snap[i]['imageURL'],
                                businessName: snap[i]['businessName'],
                                options: 0,
                              ),
                            ) : const SizedBox(),
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Business")
                      .orderBy('businessName', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      final snap = snapshot.data!.docs;
                      return Column(
                        children: [
                          for(int i = 0; i < snap.length; i++)...<Widget>[
                            UserAttributes.savedDeals.contains(snap[i]['businessName']) ? GestureDetector(
                              onTap: () {
                                Feedback.forTap(context);
                                widget.setImageURL(snap[i]['imageURL']);
                                widget.setBusinessName(snap[i]['businessName']);
                                widget.setStateMain(6);
                              },
                              child: SavedDealsViewHolder(
                                imageURL: snap[i]['imageURL'],
                                businessName: snap[i]['businessName'],
                                options: 1,
                              ),
                            ) : const SizedBox(),
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
