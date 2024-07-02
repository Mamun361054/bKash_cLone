import 'package:provider/provider.dart';
import 'package:thrift/pages/login_screen.dart';
import 'package:thrift/providers/bkash_provider.dart';
import 'package:flutter/material.dart';
import 'inbox_page.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<UserProvider>(context).phone != null;
    return isLoggedIn ? const InboxPage(title: 'Summary') : const LoginPage();
  }
}
