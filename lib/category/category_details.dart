import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';

class CategoryDetails extends StatefulWidget {
  final String title;
  final ValueSetter setStateMain;
  final ValueSetter setDeal;
  const CategoryDetails({Key? key, required this.title, required this.setStateMain, required this.setDeal}) : super(key: key);

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight / 70,),
            _headings("${widget.title} Near You"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: screenWidth / 20,),
                  GestureDetector(
                    onTap: () {
                      Feedback.forTap(context);
                      widget.setStateMain(6);
                      widget.setDeal("deal2");
                    },
                    child: _coupons(
                      "img_alabama2",
                      "The Alabama\n     Theatre",
                      "\$5 OFF Admission",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Feedback.forTap(context);
                      widget.setStateMain(6);
                      widget.setDeal("deal4");
                    },
                    child: _coupons(
                      "img_wonderworks",
                      "Extreme\nPizza",
                      "Free Drinks",
                    ),
                  ),
                ],
              ),
            ),
            _headings("All ${widget.title} Deals"),
            GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                widget.setStateMain(6);
                widget.setDeal("deal2");
              },
              child: _deals(
                "img_alabama3",
                "The Alabama Theatre\n",
                "\$5 OFF Admission\nExpires 3/10",
              ),
            ),
            GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                widget.setStateMain(6);
                widget.setDeal("deal3");
              },
              child: _deals(
                "img_jurassic2",
                "Jurassic Miniature Golf\n",
                "5\$ Family Round\nExpires 4/15",
              ),
            ),
            GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                widget.setStateMain(6);
                widget.setDeal("deal5");
              },
              child: _deals(
                "img_skywheel",
                "Myrtle Beach Skywheel\n",
                "Kids Ride Free!\nExpires 4/6",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deals(String image, String text1, String text2) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth / 20,
        vertical: 8,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              height: screenHeight / 6,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Image.asset(
                "assets/images/$image.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              height: screenHeight / 6,
              decoration: BoxDecoration(
                  border: Border.all()
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              child: Column(
                children: [
                  Text(
                    text1,
                    style: TextStyle(
                      fontFamily: "Actor",
                      fontSize: screenHeight / 45,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  DottedBorder(
                    dashPattern: const [6, 3, 6, 3],
                    child: Container(
                      height: screenHeight / 12,
                      width: screenWidth / 2.6,
                      decoration: BoxDecoration(
                        color: Attributes.yellow,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          text2,
                          style: TextStyle(
                            fontFamily: "Actor",
                            fontSize: screenHeight / 50,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _coupons(String image, String text1, String text2) {
    return Container(
      height: screenHeight / 6.8,
      width: screenWidth / 1.5,
      margin: EdgeInsets.only(
        top: screenWidth / 20,
        bottom: screenWidth / 20,
        right: screenWidth / 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Transform.translate(
            offset: const Offset(-4.5, 0),
            child: SizedBox(
              width: screenWidth / 3.8,
              child: Center(
                child: Image.asset(
                  "assets/images/$image.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              text: text1,
              children: [
                TextSpan(
                  text: "\n\n$text2",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: screenHeight / 55,
                  ),
                ),
              ],
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Actor",
                fontSize: screenHeight / 45,
              ),
            ),
          ),
        ],
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
