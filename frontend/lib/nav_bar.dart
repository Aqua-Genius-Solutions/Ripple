import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final List<Widget> screens;
  final ValueChanged<int> onTap;

  BottomNavigationBarWidget({
    required this.currentIndex,
    required this.onTap,
    required this.screens,
  });

  final List<List<String>> _iconData = [
    [
      'icons/home-page.png',
      'icons/home-page-colored.png',
    ],
    [
      'icons/trophy.png',
      'icons/trophy-colored.png',
    ],
    [
      'icons/news.png',
      'icons/news-colored.png',
    ],
    [
      'icons/chat.png',
      'icons/chat-colored.png',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
        Color.fromRGBO(246, 246, 246, 1), 
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34.0),
          boxShadow: [
            BoxShadow(
              color:Color.fromARGB(255,159, 223, 255),
              offset: Offset(1, 0),
              blurRadius: 8.0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34.0),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: onTap,
            items: List.generate(_iconData.length, (index) {
              final List<String> icons = _iconData[index];
              final unselectedIcon = icons[0];
              final selectedIcon = icons[1];

              return BottomNavigationBarItem(
                icon: Image.asset(
                  currentIndex == index ? selectedIcon : unselectedIcon,
                ),
                label: '',
              );
            }),
          ),
        ),
      ),
    );
  }
}
