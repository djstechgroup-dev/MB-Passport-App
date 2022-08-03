import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';
import 'package:passportapp/viewholders/saved_deals_viewholder.dart';

class CategoryDetails extends StatefulWidget {
  final String title;
  final ValueSetter setStateMain;
  final ValueSetter setImageURL;
  final ValueSetter setBusinessName;
  const CategoryDetails({Key? key, required this.title, required this.setStateMain, required this.setImageURL, required this.setBusinessName}) : super(key: key);

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  double screenWidth = 0;
  double screenHeight = 0;
  bool dealAvailable = false;

  @override
  void initState() {
    super.initState();
    getDeals();
  }

  void getDeals() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Business")
          .where('category', isEqualTo: widget.title)
          .get();

      String imageURL = snap.docs[0]['imageURL'];
      setState(() {
        dealAvailable = true;
      });
    } catch(e) {
      setState(() {
        dealAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    late Widget body;

    if(!dealAvailable) {
      body = emptyDeals();
    } else {
      body = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight / 70,),
            _headings("${widget.title} Near You"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: EdgeInsets.only(left: screenWidth / 20),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("Business").where('category', isEqualTo: widget.title).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      final snap = snapshot.data!.docs;
                      return Row(
                        children: [
                          for(int i = 0; i < snap.length; i++)...<Widget>[
                            GestureDetector(
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
            _headings("All ${widget.title} Deals"),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth / 20),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Business")
                      .where('category', isEqualTo: widget.title)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      final snap = snapshot.data!.docs;
                      return Column(
                        children: [
                          for(int i = 0; i < snap.length; i++)...<Widget>[
                            GestureDetector(
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

  Widget emptyDeals() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth / 15,
        ),
        child: Text(
          "Sorry, there are no deals available for ${widget.title}",
          style: TextStyle(
            fontFamily: "Actor",
            fontSize: screenHeight / 25,
          ),
          textAlign: TextAlign.center,
        ),
      ),
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

