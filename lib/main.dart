import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thrift/pages/wrapper_screen.dart';
import 'package:thrift/providers/bkash_provider.dart';
import 'package:thrift/providers/data_polling_worker.dart';
import 'package:thrift/providers/sms_receiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox('user');
  await AndroidAlarmManager.initialize();
  SMSReceiverProvider provider = SMSReceiverProvider();
  DataPollingWorker().createPollingWorker(provider);
  runApp(MyApp(provider: provider));
  configLoading();
  ///schedule periodic data transmission
  await AlarmScheduler.scheduleRepeatable();
}

class MyApp extends StatelessWidget {

  final SMSReceiverProvider provider;

  const MyApp({Key? key,required this.provider}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<SMSReceiverProvider>(create: (_) => provider),
        ChangeNotifierProvider(create: (contest) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'THRIFT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const WrapperScreen(),
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