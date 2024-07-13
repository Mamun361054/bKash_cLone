import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrift/data/dio_service/repository.dart';
import 'package:thrift/pages/wrapper_screen.dart';
import 'package:thrift/providers/bkash_provider.dart';
import 'package:thrift/providers/data_polling_worker.dart';
import 'package:thrift/providers/permission_provider.dart';
import 'package:thrift/providers/sms_receiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:thrift/utils/app_consts.dart';

import 'enums/home_menu.dart';
import 'models/cash_data.dart';
import 'models/result.dart';

SmsQuery query = SmsQuery();

void fetchAndSendSms() async {
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox('user');

  final cashIns = [];
  final cashOuts = [];
  var permission = await Permission.sms.status;
  if(permission.isGranted){

    final messages = await query.querySms(
      kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
      address: 'bKash',
    );

    for (var item in messages) {
      final str = item.body!.toLowerCase();

      if (str.contains('bill') ||
          str.contains('cash out') ||
          str.contains('send') ||
          str.contains('recharge') ||
          str.contains('payment')) {
        final amount = FetchDoubleFromString.retrieveAmountData(item.body!);
        if (amount.toString().length <= 5) {
          final date = FetchDoubleFromString.retrieveDateData(item.body!);
          final trxId = FetchDoubleFromString.retrieveTxnIdData(item.body!);

          cashOuts.add(CashData(
              cashType: CashType.cashOut,
              subType: getSubType(str),
              amount: amount,
              date: date,
              trxId: trxId ?? '',
              tCode: 0,
              tImage: "assets/cash_out.jpg"));
        }
      } else if (str.contains('sent') ||
          str.contains('received') ||
          str.contains('add') ||
          str.contains('cashback') ||
          str.contains('cash in')) {
        double amount = 0.0;

        amount = FetchDoubleFromString.retrieveAmountData(item.body!);
        if (amount.toString().length <= 5) {
          final date = FetchDoubleFromString.retrieveDateData(item.body!);
          final trxId = FetchDoubleFromString.retrieveTxnIdData(item.body!);

          cashIns.add(CashData(
              cashType: CashType.cashIn,
              subType: getSubType(str),
              amount: amount,
              date: date,
              trxId: trxId ?? '',
              tCode: 1,
              tImage: "assets/add_money.jpg"));
        }
        FetchDoubleFromString.retrieveAmountData(item.body!);
      }
    }

    List<Result> results = [];


    String? getPhone() {
      return box.get('phone');
    }

    String? getBeneficiaryId() {
      return box.get('beneficiaryId');
    }
    for (var cash in [...cashIns, ...cashOuts]) {
      Result result = Result(
          mobile: getPhone() ?? 'NA',
          beneficiaryId: getBeneficiaryId() ?? '',
          amount: cash.amount,
          txnId: cash.trxId,
          duration: 1,
          thriftDuration: 1,
          type: cash.cashType == CashType.cashIn ? 'in' : 'out',
          subType: cash.subType,
          date: cash.date);
      results.add(result);
    }
    final data = results.map((e) => e.toMap).toList();
    Repository.storeResultData(data);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox('user');
  await AndroidAlarmManager.initialize();
  SMSReceiverProvider provider = SMSReceiverProvider();
  DataPollingWorker().createPollingWorker(provider);
  ///SharedPreferences
  final SharedPreferences preference = await SharedPreferences.getInstance();

  ///RunApp
  runApp(MyApp(
    provider: provider,
    preference: preference,
  ));
  configLoading();
  ///schedule periodic data transmission
  await AlarmScheduler.scheduleRepeatable();
}

class MyApp extends StatelessWidget {
  final SMSReceiverProvider provider;
  final SharedPreferences preference;

  const MyApp({Key? key, required this.provider, required this.preference})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<SMSReceiverProvider>(create: (_) => provider),
        ChangeNotifierProvider(create: (contest) => UserProvider()),
        ChangeNotifierProvider(
            create: (context) => PermissionProvider(preference)),
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
