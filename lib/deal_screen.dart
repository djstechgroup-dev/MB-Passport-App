import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';

class DealScreen extends StatefulWidget {
  final String deal;

  const DealScreen({Key? key,
    required this.deal,
  }) : super(key: key);

  @override
  State<DealScreen> createState() => _DealScreenState();
}

class _DealScreenState extends State<DealScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  int saveButtonState = 0;
  int likeButtonState = 0;
  int used = 0;
  int total = 0;

  String title = " ";
  String category = " ";
  String schedule = " ";
  String coupon = " ";
  String location = " ";
  String description = " ";

  bool open = false;

  @override
  void initState() {
    super.initState();
    _getDealsData();
  }

  Future<void> _getDealsData() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("Deals").doc(widget.deal).get();

    setState(() {
      title = snap['title'];
      category = snap['category'];
      open = snap['open'];
      schedule = snap['schedule'];
      coupon = snap['coupon'];
      used = snap['used'];
      total = snap['total'];
      location = snap['location'];
      description = snap['description'];
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
          children: [
            _bigImage(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth / 20,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: screenWidth,
                    child: _titleAndHeart()
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
                                setState(() {
                                  saveButtonState = saveButtonState == 0 ? 1 : 0;
                                });
                              },
                              child: saveButtonState == 0 ? _button1("saveIcon", "Save") : _button1("unsaveIcon", "Unsave"),
                            ),
                            _button2("redeemIcon", "Redeem"),
                            _button1("shareIcon", "Share"),
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
                        const SizedBox(width: 8,),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            left: 8,
                            right: 8,
                          ),
                          child: _otherDealsItem(),
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
      width: screenWidth,
      child: Image.asset(
        title.contains("Alabama") ? "assets/images/img_alabama4.png"
            : "assets/images/img_dirtydons2.png",
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
          child: Center(child: _title(title)),
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
                setState(() {
                  likeButtonState = likeButtonState == 0 ? 1 : 0;
                });
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
        _label(1, open ? "Open Today" : "Closed Today"),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              schedule,
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
                coupon,
                style: TextStyle(
                  fontFamily: "Actor",
                  fontSize: screenHeight / 35,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            _smallerText(
              "Used $used time${used > 1 ? "s" : ""}",
              Alignment.bottomLeft,
              TextAlign.start,
            ),
            _smallerText(
              "${total - used} remaining",
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
        RichText(
          text: TextSpan(
            text: "1.6 miles from you\n",
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
      ],
    );
  }

  Widget _otherDealsItem() {
    return Row(
      children: [
        _otherDealsIcon(),
        const SizedBox(width: 8,),
        Text(
          "Deal Information 2",
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
        color: options == 0 ? const Color(0xFFE1EAFC) : (open ? const Color(0xFFD9FBE8) : Colors.redAccent),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Actor",
            color: options == 0 ? Attributes.blue : (open ? Colors.green : Colors.white),
            fontSize: screenHeight / 55,
          ),
        ),
      ),
    );
  }

}
