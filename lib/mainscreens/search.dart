import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';

class SearchScreen extends StatefulWidget {
  final ValueSetter setStateMain;
  final ValueSetter setTitle;
  final int categoryState;
  const SearchScreen({Key? key, required this.setStateMain, required this.setTitle, this.categoryState = 0}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  int screenState = 0;

  @override
  void initState() {
    super.initState();
    screenState = widget.categoryState;
  }

  List<String> buildRecentSearch() {
    List<String> recent = [];
    recent.addAll(Attributes.latestSearch.reversed);

    return recent;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth / 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight / 70,),
            Attributes.latestSearch.isNotEmpty ? _headings("Recently Searched") : const SizedBox(),
            for(int i = 0; i < Attributes.latestSearch.length && i < 5; i++)...<Widget>[
              Attributes.latestSearch.isNotEmpty ? _searchHistoryItem(buildRecentSearch()[i].toString())
                  : const SizedBox(),
            ],
            const SizedBox(height: 4,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _headings("Categories"),
                Container(
                  width: screenWidth / 2,
                  height: screenHeight / 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: screenState == 0 ? Alignment.centerLeft : Alignment.centerRight,
                        child: Container(
                          width: screenWidth / 4,
                          height: screenHeight / 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Attributes.blue,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Feedback.forTap(context);
                                setState(() {
                                  screenState = 0;
                                });
                              },
                              child: _switchText(0, "To Do"),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Feedback.forTap(context);
                                setState(() {
                                  screenState = 1;
                                });
                              },
                              child: _switchText(1, "To Eat"),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight / 100,
              ),
              child: GridView.count(
                shrinkWrap: true,
                primary: false,
                clipBehavior: Clip.none,
                crossAxisCount: 4,
                mainAxisSpacing: screenWidth / 8,
                crossAxisSpacing: screenWidth / 20,
                children: [
                  for(int i = 0; i < Attributes.catToDo.length; i++)...<Widget>[
                    GestureDetector(
                      onTap: () {
                        Feedback.forTap(context);
                        if(screenState == 0) {
                          widget.setStateMain(4);
                          widget.setTitle(Attributes.catToDo[i]);
                        } else if(screenState == 1) {
                          widget.setStateMain(5);
                          widget.setTitle(Attributes.catToEat[i]);
                        }
                      },
                      child: _categoryItem(i),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchText(int i, String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Actor",
          fontSize: screenHeight / 45,
          color: screenState == i ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _categoryItem(int i) {
    String image = screenState == 0 ? Attributes.catToDo[i].replaceAll(' ', '').toLowerCase()
        : Attributes.catToEat[i].replaceAll(' ', '').toLowerCase();

    return Container(
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
                  "assets/images/categories/$image.png",
                ),
                Text(
                  screenState == 0 ? Attributes.catToDo[i] : Attributes.catToEat[i],
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
    );
  }

  Widget _searchHistoryItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth / 25,
        vertical: 4,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Actor",
          fontSize: screenHeight / 45,
          color: Attributes.blue,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _headings(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Actor",
        fontSize: screenHeight / 25,
      ),
      textAlign: TextAlign.start,
    );
  }
}
