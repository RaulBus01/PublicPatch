import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:publicpatch/pages/login.dart';
import 'package:publicpatch/service/notification_ServiceStorage.dart';
import 'package:publicpatch/service/user_secure.dart';
import 'package:publicpatch/utils/create_route.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: SelectableText('Settings'),
        backgroundColor: const Color(0XFF0D0E15),
        titleTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      backgroundColor: const Color(0XFF0D0E15),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(134, 54, 60, 73),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(padding: EdgeInsets.only(top: 20)),
            LogOutButton(),
            Padding(padding: EdgeInsets.only(top: 20)),
            accountCategory('Account'),
            settingsCategory('Settings'),
          ],
        ),
      ),
    );
  }

  SizedBox settingOption(String title, IconData icon) {
    return SizedBox(
        height: 48,
        child: Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 15)),
            Expanded(
                child: Text(
              title,
              style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold),
            )),
            Icon(icon, color: const Color.fromARGB(255, 255, 255, 255)),
            Padding(padding: EdgeInsets.only(right: 20)),
          ],
        ));
  }

  SizedBox accountCategory(String title) {
    return SizedBox(
        height: 183,
        child: Column(
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 20)),
                Text(
                  title,
                  style: TextStyle(
                      color: const Color.fromARGB(2500, 118, 129, 150),
                      fontSize: 16,
                      fontFamily: 'OpenSans-Bold',
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            settingOption('Change Password', Ionicons.caret_forward),
            settingOption('Blocked Users', Ionicons.caret_forward),
            settingOption('Security', Ionicons.caret_forward),
            Divider(
              color: const Color.fromARGB(2500, 118, 129, 150),
              thickness: 1,
            ),
          ],
        ));
  }

  Column settingsCategory(String title) {
    return Column(
      children: [
        Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 20)),
            Padding(padding: EdgeInsets.only(top: 40)),
            Text(
              title,
              style: TextStyle(
                  color: const Color.fromARGB(2500, 118, 129, 150),
                  fontSize: 16,
                  fontFamily: 'OpenSans-Bold',
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        settingOption('Linked Accounts', Ionicons.caret_forward),
        langSettingOption('Language', 'English'),
        toggleSettingOption('Push Notifications'),
        Divider(
          color: const Color.fromARGB(2500, 118, 129, 150),
          thickness: 1,
        ),
      ],
    );
  }

  SizedBox toggleSettingOption(String title) {
    return SizedBox(
        height: 48,
        child: Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 15)),
            Expanded(
                child: Text(
              title,
              style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold),
            )),
            ToggleButtons(
              isSelected: [true],
              onPressed: (int index) {},
              children: [
                Icon(Ionicons.checkmark,
                    color: const Color.fromARGB(255, 5, 255, 26))
              ],
            ),
            Padding(padding: EdgeInsets.only(right: 20)),
          ],
        ));
  }

  SizedBox langSettingOption(String title, String language) {
    return SizedBox(
        height: 48,
        child: Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 15)),
            Expanded(
                child: Text(
              title,
              style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold),
            )),
            Text('English',
                style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.only(right: 20)),
          ],
        ));
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    super.key,
  });
  Future<void> logout() async {
    final userId = await UserSecureStorage.getUserId();
    final notificationStorage = NotificationStorage(userId: userId.toString());
    await notificationStorage.closeBox();

    await UserSecureStorage.deleteToken();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 40,
      child: ElevatedButton(
          onPressed: () {
            logout();
            Navigator.pushReplacement(
                context, CreateRoute.createRoute(const LoginPage()));
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFFFF9509), Color(0xFFFE2042)]),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                'Log Out',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )),
    );
  }
}
