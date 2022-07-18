import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';

class OfferScreen extends StatefulWidget {
  final String title;
  final String label1;
  final bool label2;
  final String openTime;
  final String coupon;
  final int used;
  final int remaining;
  final double distance;
  final String location;
  final String description;

  const OfferScreen({Key? key,
    required this.title,
    required this.label1,
    required this.label2,
    required this.openTime,
    required this.coupon,
    required this.used,
    required this.remaining,
    required this.distance,
    required this.location,
    required this.description
  }) : super(key: key);

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  int saveButtonState = 0;

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
                          widget.description,
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
        widget.title.contains("Alabama") ? "assets/images/img_alabama4.png"
            : "assets/images/img_dirtydons2.png",
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _titleAndHeart() {
    return Stack(
      children: [
        Center(child: _title(widget.title)),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12,
            ),
            child: Image.asset("assets/images/heartIcon.png"),
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
        _label(0, widget.label1),
        _label(1, widget.label2 ? "Open Today" : "Closed Today"),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.openTime,
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
                widget.coupon,
                style: TextStyle(
                  fontFamily: "Actor",
                  fontSize: screenHeight / 35,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            _smallerText(
              "Used ${widget.used} time${widget.used > 1 ? "s" : ""}",
              Alignment.bottomLeft,
              TextAlign.start,
            ),
            _smallerText(
              "${widget.remaining} remaining",
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
            text: "${widget.distance} miles from you\n",
            style: TextStyle(
              fontFamily: "Actor",
              fontSize: screenHeight / 50,
              color: Attributes.blue,
            ),
            children: [
              TextSpan(
                text: widget.location,
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
        color: options == 0 ? const Color(0xFFE1EAFC) : (widget.label2 ? const Color(0xFFD9FBE8) : Colors.redAccent),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Actor",
            color: options == 0 ? Attributes.blue : (widget.label2 ? Colors.green : Colors.red),
            fontSize: screenHeight / 55,
          ),
        ),
      ),
    );
  }

}
