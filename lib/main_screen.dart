import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';
import 'package:passportapp/categories_todo/todo_screen.dart';
import 'package:passportapp/categories_toeat/toeat_screen.dart';
import 'package:passportapp/mainscreens/home.dart';
import 'package:passportapp/mainscreens/profile.dart';
import 'package:passportapp/mainscreens/redeem.dart';
import 'package:passportapp/mainscreens/search.dart';
import 'package:passportapp/offerscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  double appbarHeight = 0;
  int selectedScreen = 0;
  int appbarState = 0;
  TextEditingController searchController = TextEditingController();

  String callBackTitle = "";

  //OfferScreen variables
  String offersTitle = "";
  String offersLabel1 = "";
  bool offersLabel2 = false;
  String offersOpenTime = "";
  String offersCoupon = "";
  int offersUsed = 0;
  int offersRemaining = 0;
  double offersDistance = 0;
  String offersLocation = "";
  String offersDescription = "";

  String appBarText = "Discover Deals";

  List<String> iconAssetsFilled = ["filled_home", "filled_search", "filled_redeem", "filled_profile"];
  List<String> iconAssetsOutlined = ["outlined_home", "outlined_search", "outlined_redeem", "outlined_profile"];
  List<String> pages = ["Home", "Search", "Redeem", "Profile"];

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    appbarHeight = selectedScreen < 6 ? screenHeight / 7 : 0;

    late Widget body;

    switch(selectedScreen) {
      case 0:
        body = HomeScreen(
          setStateAppBar: (v) => setState(() {appbarState = v;}),
        );
        setState(() {
          appBarText = "Discover Deals";
          appbarState = 0;
        });
        break;
      case 1:
        body = SearchScreen(
          setStateMain: (v) => setState(() {selectedScreen = v;}),
          setTitle: (v) => setState(() {callBackTitle = v;}),
        );
        setState(() {
          appBarText = "Search Deals";
          appbarState = 0;
        });
        break;
      case 2:
        body = RedeemScreen(
          setStateAppBar: (value) {
            setState(() {
              appbarState = value;
            });
          },
          setTitle: (v) => setState(() {offersTitle = v;}),
          setLabel1: (v) => setState(() {offersLabel1 = v;}),
          setLabel2: (v) => setState(() {offersLabel2 = v;}),
          setOpenTime: (v) => setState(() {offersOpenTime = v;}),
          setCoupon: (v) => setState(() {offersCoupon = v;}),
          setUsed: (v) => setState(() {offersUsed = v;}),
          setRemaining: (v) => setState(() {offersRemaining = v;}),
          setDistance: (v) => setState(() {offersDistance = v;}),
          setLocation: (v) => setState(() {offersLocation = v;}),
          setDescription: (v) => setState(() {offersDescription = v;}),
        );
        setState(() {
          appBarText = "Redeem";
          appbarState = 0;
        });
        break;
      case 3:
        body = const ProfileScreen();
        setState(() {
          appBarText = Attributes.fullName;
          appbarState = 0;
        });
        break;
      case 4:
        body = TodoScreen(title: callBackTitle,);
        setState(() {
          appBarText = callBackTitle;
          appbarState = 1;
        });
        break;
      case 5:
        body = ToeatScreen(title: callBackTitle,);
        setState(() {
          appBarText = callBackTitle;
          appbarState = 1;
        });
        break;
      case 6:
        body =  OfferScreen(
          title: offersTitle,
          label1: offersLabel1,
          label2: offersLabel2,
          openTime: offersOpenTime,
          coupon: offersCoupon,
          used: offersUsed,
          remaining: offersRemaining,
          distance: offersDistance,
          location: offersLocation,
          description: offersDescription,
        );
        setState(() {
          appBarText = "Offers";
        });
        break;
      default:
        body = Container();
        break;
    }
    return Scaffold(
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: appbarHeight,
              ),
              child: body,
            ),
            selectedScreen < 6 ? _appBar(appBarText) : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth / 20,
                vertical: screenHeight / 40,
              ),
              child: GestureDetector(
                onTap: () {
                  Feedback.forTap(context);
                  setState(() {
                    selectedScreen = 2;
                  });
                },
                child: Image.asset(
                  "assets/images/backButton.png",
                  width: screenWidth / 15,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  Widget _appBar(String text) {
    return Container(
      height: appbarHeight,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Attributes.blue,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth / 20,
        vertical: screenHeight / 40,
      ),
      child: selectedScreen != 3 ? Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _textAppBar(text),
              _notificationButton(),
            ],
          ),
          _searchBar(),
        ],
      ) : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: "Actor",
              fontSize: screenHeight / 18,
              color: Colors.white,
            ),
          ),
          Transform.translate(
            offset: const Offset(0, 10),
            child: Wrap(
              children: [
                _profilePicture(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: screenHeight / 22,
      width: screenWidth,
      margin: const EdgeInsets.only(top: 6),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth / 28,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  bottom: 10,
                ),
                border: InputBorder.none,
                hintText: "Search for a Deal or Category...",
                hintStyle: TextStyle(
                  fontFamily: "Actor",
                  fontSize: screenHeight / 35,
                  color: Colors.white,
                ),
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: TextStyle(
                fontFamily: "Actor",
                fontSize: screenHeight / 35,
                color: Colors.white,
              ),
            ),
          ),
          // Text(
          //   ,
          //   style: TextStyle(
          //     fontFamily: "Actor",
          //     fontSize: screenHeight / 35,
          //     color: Colors.white,
          //   ),
          // ),
          Image.asset(
            "assets/images/searchIcon.png",
            width: screenWidth / 20,
          ),
        ],
      ),
    );
  }

  Widget _profilePicture() {
    return SizedBox(
      height: screenWidth / 3.5,
      width: screenWidth / 3.5,
      child: const CircleAvatar(
        backgroundImage: AssetImage("assets/images/profilePic.png"),
      ),
    );
  }
  
  Widget _textAppBar(String text) {
    return appbarState == 0 ? Text(
      text,
      style: TextStyle(
        fontFamily: "Actor",
        fontSize: screenHeight / 35,
        color: Colors.white,
      ),
    ) : Row(
      children: [
        GestureDetector(
          onTap: () {
            Feedback.forTap(context);
            setState(() {
              selectedScreen = 1;
            });
          },
          child: Image.asset(
            "assets/images/backButton.png",
            width: screenWidth / 15,
          ),
        ),
        const SizedBox(width: 4,),
        Text(
          text,
          style: TextStyle(
            fontFamily: "Actor",
            fontSize: screenHeight / 35,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _notificationButton() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Image.asset(
          "assets/images/notificationIcon.png",
          width: screenWidth / 18,
        ),
        Container(
          height: 14,
          width: 14,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: Transform.translate(
            offset: const Offset(0, -1),
            child: Text(
              Attributes.unseenNotification.toString(),
              style: const TextStyle(
                fontFamily: "Actor",
                fontSize: 10,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomNavigation() {
    return Container(
      height: screenHeight / 10,
      width: screenWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for(int i = 0; i < pages.length; i++)...<Widget>[
            GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                setState(() {
                  selectedScreen = i;
                });
              },
              child: _bottomNavItem(
                selectedScreen == i ? iconAssetsFilled[i] : iconAssetsOutlined[i],
                pages[i],
                i,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _bottomNavItem(String asset, String text, int i) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/$asset.png",
            width: screenWidth / 13.5,
          ),
          const SizedBox(height: 4,),
          Text(
            text,
            style: TextStyle(
              fontFamily: "Actor",
              color: i == selectedScreen ? Attributes.blue : Colors.black54,
              fontSize: screenHeight / 60,
            ),
          ),
        ],
      ),
    );
  }
}
