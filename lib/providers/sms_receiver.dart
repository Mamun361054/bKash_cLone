import 'dart:async';

import 'package:bkash/data/dio_service/repository.dart';
import 'package:bkash/enums/home_menu.dart';
import 'package:bkash/models/cash_data.dart';
import 'package:bkash/models/result.dart';
import 'package:bkash/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/time_formatter.dart';

final services = ['bKash', 'Nagad'];

class SMSReceiverProvider extends ChangeNotifier {
  double totalReceived = 0.0;
  double totalSend = 0.0;
  String selectedService = services.first;
  DateTime currentDateTime = DateTime.now();

  SMSReceiverProvider() {
    getAllSMS();
    initialService();
  }

  void dataStoreHelper() async {
    Duration duration = await getSyncDuration();
    bool isFirstTime = await SharedUtils.getBoolValue(SharedUtils.keyIsFirstTime,defaultValue: true);
    Timer.periodic(const Duration(minutes: 10), (_) async     {
      if(duration.inMinutes > 30 || isFirstTime){
        await Repository.storeResultData(convertResultToMap());
        SharedUtils.setBoolValue(SharedUtils.keyIsFirstTime, false);
        SharedUtils.setIntValue(SharedUtils.keySecond, currentDateTime.millisecond);
      }
    });
  }

  Future<Duration> getSyncDuration() async {
    final second =  await SharedUtils.getIntValue(SharedUtils.keySecond) ?? 0;
    final duration = getDuration(second);
    return duration;
  }

  int getMilliSecondEpoch(){
    return currentDateTime.millisecond;
  }

  final SmsQuery _query = SmsQuery();
  List<SmsMessage> messages = [];
  List<CashData> cashIns = [];
  List<CashData> cashOuts = [];

  getAllSMS() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
        address: selectedService == 'Nagad' ? 'NAGAD' : selectedService,
      );

      debugPrint('sms inbox messages: ${messages.length}');

      ///decode SMS data to [CashData]
      decodeCashData();

      ///notify listeners
      notifyListeners();
    } else {
      Permission.sms.request().then((status) async {
        if (status.isGranted) {
          debugPrint(selectedService);
          messages = await _query.querySms(
            kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
            address: selectedService == 'Nagad' ? 'NAGAD' : selectedService,
          );

          debugPrint('sms inbox messages: ${messages.length}');

          ///decode SMS data to [CashData]
          decodeCashData();

          ///notify listeners
          notifyListeners();
        }
      });
    }
  }

  initialService() async {
    final value = await SharedUtils.getValue(SharedUtils.keyService);
    selectedService = value ?? services.first;
  }

  onServiceChanged({required String val}) async {
    selectedService = val;
    SharedUtils.setValue(SharedUtils.keyService, selectedService);
    await onRefresh();
  }

  Future onRefresh() async {
    debugPrint('onRefresh');
    messages = [];
    cashIns = [];
    cashOuts = [];
    totalSend = 0.0;
    totalReceived = 0.0;
    await getAllSMS();
    await initialService();
  }

  List<Result> convertCashToResult() {

    List<Result> results = [];

    for (var cash in [...cashIns, ...cashOuts]) {
      Result result = Result(
          mobile: '01812858585',
          beneficiaryId: '11813789',
          amount: cash.amount,
          type: cash.cashType == CashType.cashIn ? 'in' : 'out',
          date: cash.date);
      results.add(result);
    }
    return results;
  }

  List<Map<String,dynamic>> convertResultToMap(){
    return convertCashToResult().map((e) => e.toMap).toList();
  }

  decodeCashData() {
    for (var item in messages) {

      final str = item.body!.toLowerCase();

      if (str.contains('bill') ||
          str.contains('cash out') ||
          str.contains('recharge') ||
          str.contains('payment')) {
        final amount = FetchDoubleFromString.retrieveAmountData(item.body!);
        totalSend += amount;
        final date = FetchDoubleFromString.retrieveDateData(item.body!);
        cashOuts.add(CashData(
            cashType: CashType.cashOut,
            amount: amount,
            date: date,
            tCode: 0,
            tImage: "assets/cash_out.jpg"));
      } else if (str.contains('sent') ||
          str.contains('received') ||
          str.contains('add') ||
          str.contains('cashback') ||
          str.contains('cash in')) {
        double amount = 0.0;
        if (selectedService == "Nagad" && str.contains('sent')) {
          amount = FetchDoubleFromString.retrieveAmountData(item.body!,
              isSent: true);
        } else {
          amount = FetchDoubleFromString.retrieveAmountData(item.body!);
        }
        totalReceived += amount;
        final date = FetchDoubleFromString.retrieveDateData(item.body!);
        cashIns.add(CashData(
            cashType: CashType.cashIn,
            amount: amount,
            date: date,
            tCode: 1,
            tImage: "assets/add_money.jpg"));
        FetchDoubleFromString.retrieveAmountData(item.body!);
      }
    }
    convertCashToResult();
  }
}

class FetchDoubleFromString {
  static double retrieveAmountData(String input, {bool isSent = false}) {
    RegExp doubleRE = RegExp(r"-?(?:\d*\.)?\d+(?:[eE][+-]?\d+)?");

    var numbers = doubleRE
        .allMatches(input.replaceAll(',', ''))
        .map((m) => double.parse(m[0].toString()))
        .toList();

    return isSent ? numbers[1] : numbers.first;
  }

  static String retrieveDateData(String input) {
    RegExp doubleRE = RegExp('\\d{2}/\\d{2}/\\d{4}');

    var date = doubleRE.firstMatch(input)?.group(0);

    debugPrint('group1 $date');
    return date ?? '';
  }
}
