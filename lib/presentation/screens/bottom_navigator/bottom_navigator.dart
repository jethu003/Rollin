import 'package:flutter/material.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:rollin_user/presentation/screens/cinemas/cinemas.dart';
import 'package:rollin_user/presentation/screens/coming_soon/coming_soon.dart';
import 'package:rollin_user/presentation/screens/home_page/home_page.dart';
import 'package:rollin_user/presentation/screens/profile/profile_page.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TheatreShowMoviesPage(),
    const CinemasPage(),
    const ComingSoonMovies(),
    const ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.shineBlack,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        elevation: 10,
        backgroundColor: AppColours.shineBlack,
        type: BottomNavigationBarType.fixed,
        selectedItemColor:AppColours.primaryColor,
        unselectedItemColor: AppColours.shineWhite,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.theaters),
            label: "Cinemas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            label: "Coming Soon",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}