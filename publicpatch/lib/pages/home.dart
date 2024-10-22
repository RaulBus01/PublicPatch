import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:publicpatch/pages/camera.dart';
import 'package:publicpatch/pages/reports.dart';
import 'package:camera/camera.dart'; // Make sure you have this package

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Handles item tap in the BottomNavigationBar
  void _onItemTapped(int index) async {
    if (index == 2) {
      // When camera icon is tapped, open the camera
      try {
        final cameras = await availableCameras();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraPage(cameras: cameras),
          ),
        );
      } catch (e) {
        print('Error: $e');
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  static const List<Widget> _widgetOptions = <Widget>[
    ReportsPage(),
    Text('Search', style: TextStyle(fontSize: 24, color: Colors.black)),
    Text('Camera',
        style: TextStyle(
            fontSize: 24, color: Colors.black)), // Placeholder for the camera
    Text('Notifications', style: TextStyle(fontSize: 24, color: Colors.black)),
    Text('Profile', style: TextStyle(fontSize: 24, color: Colors.black)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xff1A1C2A),
          splashColor: const Color(0xff9DA4B3),
          splashFactory: InkSparkle.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          selectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: const Color(0xff1A1C2A),
          selectedItemColor: const Color(0xFF9DA4B3),
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped, // Link to the modified method
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Color(0xff1A1C2A),
              activeIcon: Icon(
                Ionicons.home,
                size: 30,
                color: Colors.white,
              ),
              icon: Icon(
                Ionicons.home_outline,
                size: 30,
                color: Color(0xFF9DA4B3),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Ionicons.search_outline,
                size: 30,
                color: Color(0xFF9DA4B3),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Ionicons.add_circle_outline,
                size: 40,
                color: Color(0xFF9DA4B3),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                label: Text('3'),
                child: Icon(
                  Ionicons.notifications_outline,
                  size: 30,
                  color: Color(0xFF9DA4B3),
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Ionicons.person_outline,
                size: 30,
                color: Color(0xFF9DA4B3),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
