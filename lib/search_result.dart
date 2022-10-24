import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';
import 'package:passportapp/services/prefs_service.dart';
import 'package:passportapp/services/string_service.dart';

class SearchResultScreen extends StatefulWidget{
  final String searchKey;
  final ValueSetter setStateMain;
  final ValueSetter setTitle;
  const SearchResultScreen({Key? key, required this.searchKey, required this.setStateMain, required this.setTitle}) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  double screenWidth = 0;
  double screenHeight = 0;

  List<String> categories = [];
  List<String> icons = [];

  @override
  void initState() {
    super.initState();
    addListItem(Attributes.catToDo);
    addListItem(Attributes.catToEat);
  }

  void addListItem(List<String> list) {
    for (var item in list) {
      categories.add(item.toLowerCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth / 20),
        child: Column(
          children: [
            SizedBox(
              width: screenWidth,
              child: _headings("Categories"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight / 20,
              ),
              child: GridView.count(
                shrinkWrap: true,
                primary: false,
                clipBehavior: Clip.none,
                crossAxisCount: 4,
                mainAxisSpacing: screenWidth / 8,
                crossAxisSpacing: screenWidth / 20,
                children: [
                  for(int i = 0; i < filterSearchResults(widget.searchKey).length; i++)...<Widget>[
                    _categoryItem(i),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryItem(int i) {
    String text = categories[i].toCapitalize();

    return GestureDetector(
      onTap: () {
        Feedback.forTap(context);
        PrefsService().addToRecentSearch(text);
        widget.setStateMain(5);
        widget.setTitle(text);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Transform.translate(
          offset: Offset(0, -screenHeight / 25),
          child: Wrap(
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/images/categories/${categories[i].replaceAll(' ', '').toLowerCase()}.png",
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: "Actor",
                      fontSize: screenHeight / 65,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> filterSearchResults(String query) {
    List<String> buffer = <String>[];
    buffer.addAll(categories);

    if(query.isNotEmpty) {
      List<String> bufferData = <String>[];
      for (var item in buffer) {
        if(item.contains(query)) {
          bufferData.add(item);
        }
      }
      setState(() {
        categories.clear();
        categories.addAll(bufferData);
      });
      return bufferData;
    } else {
      setState(() {
        categories.clear();
        addListItem(Attributes.catToDo);
        addListItem(Attributes.catToEat);
      });
      return buffer;
    }
  }

  Widget _headings(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Actor",
        fontSize: screenWidth / 14,
      ),
      textAlign: TextAlign.start,
    );
  }
}
