import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/model/user.dart';
import 'package:passportapp/services/deal_service.dart';
import 'package:passportapp/viewholders/saved_deals_viewholder.dart';

class AccountDealsHistory extends StatefulWidget {
  final ValueSetter setStateMain;
  final ValueSetter setImageURL;
  final ValueSetter setBusinessName;
  final ValueSetter setDealId;

  const AccountDealsHistory({Key? key, required this.setStateMain, required this.setImageURL, required this.setBusinessName, required this.setDealId}) : super(key: key);

  @override
  State<AccountDealsHistory> createState() => _AccountDealsHistoryState();
}

class _AccountDealsHistoryState extends State<AccountDealsHistory> {
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

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: screenWidth / 20,
        ),
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
                        activeTo: snapshot.data[i]['active_to'],
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
    );
  }
}
