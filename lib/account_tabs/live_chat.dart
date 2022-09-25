import 'package:flutter/material.dart';

class AccountLiveChat extends StatefulWidget {
  const AccountLiveChat({Key? key}) : super(key: key);

  @override
  State<AccountLiveChat> createState() => _AccountLiveChatState();
}

class _AccountLiveChatState extends State<AccountLiveChat> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Text("Live Chat"),
      ),
    );
  }
}
