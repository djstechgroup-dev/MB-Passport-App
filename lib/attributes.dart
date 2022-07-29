import 'dart:ui';
import 'package:location/location.dart';

class Attributes {
  static int unseenNotification = 3;
  static LocationData? locationData;
  static Color blue = const Color(0xFF18469D);
  static Color lightBlue = const Color(0xFFE0F5FC);
  static Color yellow = const Color(0xFFFFD75B);
  static double currentTemp = 0;
  static double currentUV = 0;
  static double currentPrecipitation = 0;
  static String userFavorite = "";
  static List<String> savedDeals = [];

  static List<String> catToDo = [
    "Attractions",
    "Beach",
    "Events",
    "Family Fun",
    "Fishing",
    "Golf",
    "Lodging",
    "Shopping",
    "Shows",
    "Transportation",
    "Watersport",
    "Wellness",
  ];

  static List<String> catToEat = [
    "Breakfast",
    "Brewpub",
    "Buffet",
    "Burgers & Wings",
    "Delivery",
    "Family Dining",
    "Fine Dining",
    "Oceanfront",
    "Pizza",
    "Seafood",
    "Sportsbar",
    "Steakhouse",
  ];
}