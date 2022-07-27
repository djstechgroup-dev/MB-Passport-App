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
  String tagline = " ";

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    late Widget body;

    if(widget.options == 0) {
      body = Container(
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: screenWidth / 3.8,
                child: Center(
                  child: Image.network(
                    widget.imageURL,
                  ),
                ),
              ),
              RichText(
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
            ],
          ),
        ),
      );
    } else {
      body = Container(
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
