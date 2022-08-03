import 'dart:convert';
import 'package:passportapp/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  late SharedPreferences sharedPreferences;

  Future<void> loadSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> saveUserData(UserData user) async {
    loadSharedPreferences().then((v) {
      List<String>? listPref = sharedPreferences.getStringList("userData");
      List<UserData> list = [];

      if(listPref == null) {
        list.add(user);
        saveUser(list);
      } else {
        list = listPref.map((item) => UserData.fromMap(jsonDecode(item))).toList();
        list.add(user);
        saveUser(list);
      }
    });
  }

  Future<void> saveUser(List<UserData> list) async {
    loadSharedPreferences().then((value) {
      List<String> listPref = list.map((item) => jsonEncode(item.toMap())).toList();
      sharedPreferences.setStringList("userData", listPref);
    });
  }

  Future<List<UserData>> getUserData() async {
    List<UserData> list = [];
    await loadSharedPreferences();
    List<String>? listPref = sharedPreferences.getStringList("userData");

    if(listPref == null) {
      list = list;
    } else {
      list = listPref.map((item) => UserData.fromMap(jsonDecode(item))).toList();
    }
    return list;
  }

  Future<void> addToRecentSearch(String item) async {
    await loadSharedPreferences();
    List<String>? listPref = sharedPreferences.getStringList("recentSearch");
    List<String> recentSearch = [];

    if(listPref == null) {
      recentSearch.add(item);
      sharedPreferences.setStringList("recentSearch", recentSearch);
    } else {
      recentSearch = listPref;
      recentSearch.add(item);
      sharedPreferences.setStringList("recentSearch", recentSearch);
    }
  }

  Future<List<String>> getRecentSearch() async {
    await loadSharedPreferences();
    List<String>? listPref = sharedPreferences.getStringList("recentSearch");
    List<String> recentSearch = [];

    if(listPref == null) {
      recentSearch = [];
    } else {
      recentSearch = listPref;
    }

    return recentSearch;
  }
}