import 'package:flutter/material.dart';
import 'package:uastpm/page/profile.dart';
import 'dashboard.dart';
import 'maps.dart';
import 'orders.dart';

class BtmNavBar extends StatefulWidget {
  const BtmNavBar({Key? key}) : super(key: key);

  @override
  State<BtmNavBar> createState() => _BtmNavBarState();
}

class _BtmNavBarState extends State<BtmNavBar> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.jumpToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = [
      Dashboard(),
      MapPage(),
      OrdersPage(),
      ProfilePage(), // Added a new page for tracking orders
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_pageController.page?.round() == 1) {
          _pageController.jumpToPage(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          physics: NeverScrollableScrollPhysics(), // Disable page sliding
          children: _widgetOptions,
        ),
        bottomNavigationBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            unselectedItemColor: Theme.of(context).textTheme.bodyText2!.color, // Use the unselected text color from the current theme
            selectedItemColor: Theme.of(context).accentColor, // Use the accent color from the current theme
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard, size: 30),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map, size: 30),
                label: 'Maps',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment, size: 30),
                label: 'Orders', // Added a new item for tracking orders
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 30),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
