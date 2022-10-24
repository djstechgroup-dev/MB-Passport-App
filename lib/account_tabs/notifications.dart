import 'package:flutter/material.dart';

class AccountNotification extends StatefulWidget {
  const AccountNotification({Key? key}) : super(key: key);

  @override
  State<AccountNotification> createState() => _AccountNotificationState();
}

class _AccountNotificationState extends State<AccountNotification> {
  double screenWidth = 0;
  double screenHeight = 0;

  bool allowNotifications = false;
  bool pushNotifications = false;
  bool inAppNotifications = false;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            settingsRow(0, "Allow Notifications"),
            allowNotifications ? settingsRow(1, "Push Notifications") : const SizedBox(),
            allowNotifications ? settingsRow(2, "In-app Notifications") : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget settingsRow(int options, String text) {
    bool toggle = false;

    switch(options) {
      case 0:
        toggle = allowNotifications;
        break;
      case 1:
        toggle = pushNotifications;
        break;
      case 2:
        toggle = inAppNotifications;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            fontFamily: "Actor",
            fontSize: screenHeight / 35,
          ),
        ),
        Switch(
          value: toggle,
          onChanged: (value) {
            setState(() {
              switch(options) {
                case 0:
                  allowNotifications = value;
                  break;
                case 1:
                  pushNotifications = value;
                  break;
                case 2:
                  inAppNotifications = value;
                  break;
              }
            });
          },
        ),
      ],
    );
  }

}
