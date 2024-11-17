import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:publicpatch/components/BackgroundImage.dart';
import 'package:publicpatch/components/CustomFormInput.dart';
import 'package:publicpatch/pages/signup.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return onSettings(context);
  }

  Container onSettings(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: Color.fromARGB(13, 14, 21, 100)),
          Scaffold(
              backgroundColor: const Color.fromARGB(0, 255, 3, 3),
              body: Stack(fit: StackFit.expand, children: [
                SingleChildScrollView(
                    child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 55)),
                    Text(
                      'Settings',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                          fontFamily: 'OpenSans-Bold',
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.only(top: 40)),
                    accountCategory('Account'),
                    settingsCategory('Settings'),
                  ],
                ))
              ]))
        ],
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
                  Icon(Ionicons.checkmark, color: const Color.fromARGB(255, 5, 255, 26))                ],
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