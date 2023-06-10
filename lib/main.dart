import 'package:thrift/pages/wrapper_screen.dart';
import 'package:thrift/providers/sms_receiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<SMSReceiverProvider>(
            create: (_) => SMSReceiverProvider())
      ],
      child: MaterialApp(
        title: 'THRIFT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const WrapperScreen(),
        // home: const InboxPage(
        //   title: 'Summary',
        // ),
        builder: EasyLoading.init(),
      ),
    );
  }
}
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.deepPurple
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.deepPurple
    ..textColor = Colors.deepPurple
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..boxShadow = <BoxShadow>[];
}