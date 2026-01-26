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

  final List<Widget> _screens = const [
    TheatreShowMoviesPage(),
    CinemasPage(),
    ComingSoonMovies(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /// Base icon widget (uniform size)
  Widget _navIcon(String assetPath, {double scale = 0.9}) {
    return SizedBox(
      height: 22,
      width: 22,
      child: Transform.scale(
        scale: scale,
        child: ImageIcon(
          AssetImage(assetPath),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.shineBlack,

      
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        elevation: 20,
        backgroundColor: AppColours.shineBlack,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: AppColours.shineWhite,
        unselectedItemColor:AppColours.insideGrey ,

        items: [
          BottomNavigationBarItem(
            icon: _navIcon('assets/home.png'),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _navIcon('assets/cinemas2.png'),
            label: "Cinemas",
          ),
          BottomNavigationBarItem(
            
            icon: _navIcon(
              'assets/coming-soon.png',
              scale: 1.3,
            ),
            label: "Coming Soon",
          ),
          BottomNavigationBarItem(
            icon: _navIcon('assets/user.png'),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
