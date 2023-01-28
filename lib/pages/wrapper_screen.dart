import 'package:bkash/pages/login_screen.dart';
import 'package:bkash/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'inbox_page.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SharedUtils.getBoolValue(SharedUtils.keyIsLoggedIn),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!) {
            return const InboxPage(
              title: 'Summary',
            );
          }
          return const LoginPage();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
