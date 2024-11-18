import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:publicpatch/pages/notifications.dart';
import 'package:publicpatch/pages/reportForm.dart';
import 'package:publicpatch/pages/reports.dart';
import 'package:publicpatch/pages/reportsMap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _unreadNotifications = 3;

  void markAllNotificationsAsRead() {
    setState(() {
      _unreadNotifications = 0;
    });
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      ReportsPage(),
      ReportsMapPage(),
      ReportFormPage(),
      NotificationsPage(
        onMarkAllRead: markAllNotificationsAsRead,
        unreadCount: _unreadNotifications,
      ),
      Text('Profile', style: TextStyle(fontSize: 24, color: Colors.black)),
    ];

    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
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
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
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
            const BottomNavigationBarItem(
              icon: Icon(
                Ionicons.search_outline,
                size: 30,
                color: Color(0xFF9DA4B3),
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Ionicons.add_circle_outline,
                size: 40,
                color: Color(0xFF9DA4B3),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                label: _unreadNotifications > 0
                    ? Text('$_unreadNotifications')
                    : null,
                isLabelVisible: _unreadNotifications > 0,
                child: const Icon(
                  Ionicons.notifications_outline,
                  size: 30,
                  color: Color(0xFF9DA4B3),
                ),
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
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
