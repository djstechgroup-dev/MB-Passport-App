import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passportapp/account_tabs/account_information.dart';
import 'package:passportapp/account_tabs/deals_history.dart';
import 'package:passportapp/account_tabs/contact_us.dart';
import 'package:passportapp/account_tabs/notifications.dart';
import 'package:passportapp/account_tabs/preferences.dart';
import 'package:passportapp/attributes.dart';
import 'package:passportapp/category/category_details.dart';
import 'package:passportapp/faq_screen.dart';
import 'package:passportapp/mainscreens/home.dart';
import 'package:passportapp/mainscreens/profile.dart';
import 'package:passportapp/mainscreens/redeem.dart';
import 'package:passportapp/mainscreens/search.dart';
import 'package:passportapp/deal_screen.dart';
import 'package:passportapp/model/user.dart';
import 'package:passportapp/most_popular.dart';
import 'package:passportapp/notification_screen.dart';
import 'package:passportapp/refer_screen.dart';
import 'package:passportapp/search_result.dart';
import 'package:passportapp/see_all/fav_business.dart';
import 'package:passportapp/see_all/offers.dart';

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
  int searchState = 0;
  int backButtonState = 0;
  TextEditingController searchController = TextEditingController();

  String callBackTitle = "";
  String searchKey = "";
  String appBarText = "Discover Deals";

  //Deals Variable
  String imageURL = "";
  String businessName = "";
  String dealId = "";
  int dealOptions = 0;

  List<String> iconAssetsFilled = ["filled_home", "filled_search", "filled_redeem", "filled_profile"];
  List<String> iconAssetsOutlined = ["outlined_home", "outlined_search", "outlined_redeem", "outlined_profile"];
  List<String> pages = ["Home", "Search", "Redeem", "Profile"];

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Attributes.blue,
      statusBarBrightness: Brightness.dark,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    appbarHeight = selectedScreen == 6 ? 0 : screenHeight / 7;

    late Widget body;

    switch(selectedScreen) {
      case 0:
        body = HomeScreen(
          setStateMain: (v) => setState(() {selectedScreen = v;}),
          setStateSearch: (v) => setState(() {searchState = v;}),
          setImageURL: (v) => setState(() {imageURL = v;}),
          setBusinessName: (v) => setState(() {businessName = v;}),
          setDealId: (v) => setState(() {dealId = v;}),
          setDealOptions: (v) => setState(() {dealOptions = v;}),
        );
        setState(() {
          appBarText = "Discover Deals";
          appbarState = 0;
          backButtonState = 1;
          searchKey = "";
        });
        searchController.clear();
        break;
      case 1:
        body = SearchScreen(
          setStateMain: (v) => setState(() {selectedScreen = v;}),
          setTitle: (v) => setState(() {callBackTitle = v;}),
          categoryState: searchState,
        );
        setState(() {
          appBarText = "Search Deals";
          appbarState = 0;
          backButtonState = 0;
          searchKey = "";
        });
        searchController.clear();
        break;
      case 2:
        body = RedeemScreen(
          setStateMain: (v) => setState(() {selectedScreen = v;}),
          setImageURL: (v) => setState(() {imageURL = v;}),
          setBusinessName: (v) => setState(() {businessName = v;}),
          setDealId: (v) => setState(() {dealId = v;}),
        );
        setState(() {
          appBarText = "Redeem";
          appbarState = 0;
          backButtonState = 0;
          searchKey = "";
        });
        searchController.clear();
        break;
      case 3:
        body = ProfileScreen(
          setStateMain: (v) => setState(() {selectedScreen = v;}),
          setImageURL: (v) => setState(() {imageURL = v;}),
          setBusinessName: (v) => setState(() {businessName = v;}),
        );
        String? name = UserAttributes.isAppleUser ? UserAttributes.appleUserName : FirebaseAuth.instance.currentUser?.displayName;
        List<String>? words = name?.split(" ");
        setState(() {
          appBarText = words![0];
          appbarState = 0;
          backButtonState = 0;
          searchKey = "";
        });
        searchController.clear();
        break;
      case 4:
        body = const NotificationScreen();
        searchController.clear();

        setState(() {
          appBarText = "Notifications";
        });
        break;
      case 5:
        body = CategoryDetails(
          title: callBackTitle,
          setStateMain: (v) => setState(() {selectedScreen = v;}),
          setImageURL: (v) => setState(() {imageURL = v;}),
          setBusinessName: (v) => setState(() {businessName = v;}),
          setDealId: (v) => setState(() {dealId = v;}),
        );
        setState(() {
          appBarText = callBackTitle;
          appbarState = 1;
          backButtonState = 2;
        });
        searchController.clear();
        break;
      case 6:
        body = DealScreen(
          id: dealId,
          options: dealOptions,
        );
        setState(() {
          appBarText = "Offers";
        });
        searchController.clear();
        break;
      case 7:
        body = SearchResultScreen(
          searchKey: searchKey,
          setStateMain: (v) => setState(() {selectedScreen = v;}),
          setTitle: (v) => setState(() {callBackTitle = v;}),
        );
        break;
      case 8:
        body = FAQScreen(
          setStateMain: (v) => setState(() {selectedScreen = v;}),
        );
        searchController.clear();

        setState(() {
          appBarText = "FAQ";
        });
        break;
      case 9:
        body = ReferScreen(
          setStateMain: (v) => setState(() {selectedScreen = v;}),
        );
        searchController.clear();
        break;
      case 10:
        body = const AccountContactUs();
        searchController.clear();
        break;
      case 11:
        body = const AccountPreferences();
        searchController.clear();

        setState(() {
          appBarText = "Preferences";
        });
        break;
      case 12:
        body = AccountDealsHistory(
          setStateMain: (v) => setState(() {selectedScreen = v;}),
          setImageURL: (v) => setState(() {imageURL = v;}),
          setBusinessName: (v) => setState(() {businessName = v;}),
          setDealId: (v) => setState(() {dealId = v;}),
        );
        searchController.clear();

        setState(() {
          appBarText = "Deals History";
        });
        break;
      case 13:
        body = const AccountInformation();
        searchController.clear();

        setState(() {
          appBarText = "Account Information";
        });
        break;
      case 14:
        body = const AccountNotification();
        searchController.clear();

        setState(() {
          appBarText = "Notification Settings";
        });
        break;
      case 15:
        body = const SeeAllOffers();
        searchController.clear();
        break;
      case 16:
        body = const SeeAllFavBusiness();
        searchController.clear();
        break;
      case 17:
        body = const MostPopular();
        searchController.clear();
        break;
      default:
        body = Container();
        break;
    }
    return Scaffold(
      backgroundColor: Attributes.blue,
      body: SafeArea(
        child: SizedBox(
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
              selectedScreen == 6 ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth / 20,
                  vertical: screenHeight / 40,
                ),
                child: GestureDetector(
                  onTap: () {
                    Feedback.forTap(context);
                    setState(() {
                      selectedScreen = backButtonState == 0 ? 2 : (backButtonState == 1 ? 0 : 5);
                    });
                  },
                  child: Image.asset(
                    "assets/images/backButton.png",
                    width: screenWidth / 15,
                  ),
                ),
              ) : _appBar(appBarText),
            ],
          ),
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
      ) : Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: TextStyle(
                fontFamily: "Actor",
                fontSize: screenHeight / 18,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Transform.translate(
              offset: const Offset(0, 10),
              child: Wrap(
                children: [
                  _profilePicture(),
                ],
              ),
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
              onTap: () {
                selectedScreen = 7;
              },
              onChanged: (value) {
                setState(() {
                  searchKey = value;
                  selectedScreen = 7;
                });
              },
              controller: searchController,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: UserAttributes.profilePicURL != null ?
        Image.network(UserAttributes.profilePicURL!) :
        Image.asset("assets/images/logoOnly.png"),
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
    return GestureDetector(
      onTap: () {
        Feedback.forTap(context);
        setState(() {
          selectedScreen = 4;
        });
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Image.asset(
            "assets/images/notificationIcon.png",
            width: screenWidth / 18,
          ),
          //NOTIFICATION LABEL
          Attributes.unseenNotification > 0 ? Container(
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
          ) : const SizedBox(),
        ],
      ),
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
