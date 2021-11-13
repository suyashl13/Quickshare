import 'package:flutter/material.dart';
import 'package:quickshare_client/screens/auth/LoginScreen.dart';
import 'package:quickshare_client/screens/profile/EditProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ProfileDialog extends StatelessWidget {
  late SharedPreferences _preferences;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Edit Profile'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => EditProfileScreen()));
          },
        ),
        ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              _preferences = await SharedPreferences.getInstance();
              _preferences.clear();
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            })
      ],
    );
  }
}
