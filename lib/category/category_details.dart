import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/viewholders/saved_deals_viewholder.dart';
import '../services/deal_service.dart';

class CategoryDetails extends StatefulWidget {
  final String title;
  final ValueSetter setStateMain;
  final ValueSetter setImageURL;
  final ValueSetter setBusinessName;
  final ValueSetter setDealId;
  const CategoryDetails({Key? key, required this.title, required this.setStateMain, required this.setImageURL, required this.setBusinessName, required this.setDealId}) : super(key: key);

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
    getDeals().then((value) {
      if(value.isNotEmpty) {
        setState(() {
          dealAvailable = true;
        });
      }
    });
  }

  Future<List<dynamic>> getDeals() async {
    List<dynamic> deals = [];
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
      List<dynamic> deal = await DealApi().getAllDeals(token?.token);

      for(int i = 0; i < deal.length; i++) {
        if(widget.title == "Attractions") {
          if(deal[i]['businessId']['category'] == "Entertainment") {
            deals.add(deal[i]);
          }
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

    if(!dealAvailable) {
      body = emptyDeals();
    } else {
      body = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight / 70,),
            _headings("${widget.title} Near You"),
            FutureBuilder(
              future: getDeals(),
              builder: (context, AsyncSnapshot snapshot) {
                if(snapshot.hasData) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.only(left: screenWidth / 20),
                      child: Row(
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
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            _headings("All ${widget.title} Deals"),
            FutureBuilder(
              future: getDeals(),
              builder: (context, AsyncSnapshot snapshot) {
                if(!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth / 20,
                      ),
                      child: Column(
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
                      ),
                    ),
                  );
                }
              },
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

