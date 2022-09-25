import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';

class SavedDealsViewHolder extends StatefulWidget {
  final String imageURL;
  final String businessName;
  final int options;
  const SavedDealsViewHolder({Key? key, required this.imageURL, required this.businessName, required this.options}) : super(key: key);

  @override
  State<SavedDealsViewHolder> createState() => _SavedDealsViewHolderState();
}

class _SavedDealsViewHolderState extends State<SavedDealsViewHolder> {
  double screenWidth = 0;
  double screenHeight = 0;
  double imageWidth1 = 0;
  String tagline = " ";

  @override
  void initState() {
    super.initState();
    _getOtherData();
  }

  void _getOtherData() async {
    QuerySnapshot snap = await FirebaseFirestore.instance.collection("Deals")
        .where('imageURL', isEqualTo: widget.imageURL).get();

    if(mounted) {
      setState(() {
        tagline = snap.docs[0]['tagline'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    imageWidth1 = screenWidth / 3.8;

    late Widget body;

    if(widget.options == 0) {
      body = Container(
        height: screenHeight / 6.8,
        width: screenWidth / 1.5,
        margin: EdgeInsets.only(
          top: screenWidth / 30,
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
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: screenHeight / 6.8,
              width: imageWidth1,
              margin: const EdgeInsets.only(right: 16),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: Image.network(
                  widget.imageURL,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            SizedBox(
              width: screenWidth / 1.5 - imageWidth1 - screenWidth / 20,
              child: RichText(
                text: TextSpan(
                  text: widget.businessName,
                  children: [
                    TextSpan(
                      text: "\n\n$tagline",
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
            ),
          ],
        ),
      );
    } else {
      body = Padding(
        padding: const EdgeInsets.symmetric(
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
                child: Image.network(
                  widget.imageURL,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.businessName,
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
                            tagline,
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

    return body;
  }
}
