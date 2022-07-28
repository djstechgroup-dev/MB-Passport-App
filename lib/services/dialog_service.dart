import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';

class CustomDialog extends StatefulWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback tapFunction;
  const CustomDialog({Key? key, required this.title, required this.description, required this.tapFunction, required this.buttonText}) : super(key: key);

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primaryBlue = Colors.blue;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      curve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(seconds: 1),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: content(context),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Center(
      child: Container(
        height: screenWidth / 1.5,
        width: screenWidth / 1.5,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: screenWidth / 2.5,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\n${widget.title}",
                    style: TextStyle(
                      fontFamily: "Actor",
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight / 45,
                    ),
                  ),
                  const SizedBox(height: 6,),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontFamily: "Actor",
                      fontSize: screenHeight / 49.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: widget.tapFunction,
              child: Container(
                width: screenWidth,
                height: 50,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Attributes.blue,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    widget.buttonText,
                    style: TextStyle(
                      fontFamily: "Actor",
                      fontSize: screenHeight / 49.5,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
