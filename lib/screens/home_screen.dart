import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'common_feed_screen.dart';
import 'ask_me_screen.dart';
import 'personal_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const CommonFeedScreen(),
    const AskMeScreen(),
    const PersonalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.bulletinBoard),
            label: 'Common Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.chatQuestion),
            label: 'Ask Me',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.accountCircle),
            label: 'Personal',
          ),
        ],
      ),
    );
  }
}
