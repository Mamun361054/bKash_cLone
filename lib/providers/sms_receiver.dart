import 'dart:async';
import 'package:app_usage/app_usage.dart';
import 'package:thrift/data/dio_service/repository.dart';
import 'package:thrift/enums/home_menu.dart';
import 'package:thrift/models/cash_data.dart';
import 'package:thrift/models/result.dart';
import 'package:thrift/utils/shared_preferences.dart';
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
  List<AppUsageInfo> usages = [];
  AppUsageInfo? bkashAppUsage;
  String benId = '';
  String benPhone = '';

  SMSReceiverProvider() {
    getAllSMS();
    initialService();
    getUsageData();
  }

  getUsageData()async{
    DateTime startDate = currentDateTime.subtract(const Duration(days: 1));
    try {
    usages = await AppUsage().getAppUsage(startDate, currentDateTime);
    for (var usage in usages) {
      if(usage.appName == 'bkash'){
        debugPrint('app name : ${usage.appName}');
        debugPrint('app usage : ${usage.usage.inMinutes}');
        bkashAppUsage = usage;
        return;
      }
    }
    notifyListeners();
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }


  void dataStoreHelper() async {

    bool isFirstTime = await SharedUtils.getBoolValue(SharedUtils.keyIsFirstTime,defaultValue: true);
    if(isFirstTime){
      await Repository.storeResultData(convertResultToMap());
      SharedUtils.setBoolValue(SharedUtils.keyIsFirstTime, false);
      SharedUtils.setValue(SharedUtils.keySecond, '${currentDateTime.millisecondsSinceEpoch}');
    }

    Timer.periodic(const Duration(minutes: 2), (_) async {
      final duration = await getSyncDuration();
      isFirstTime = await SharedUtils.getBoolValue(SharedUtils.keyIsFirstTime,defaultValue: false);
      if(duration.inMinutes > 30){
        getUsageData();
        await Repository.storeResultData(convertResultToMap());
        SharedUtils.setBoolValue(SharedUtils.keyIsFirstTime, false);
        SharedUtils.setValue(SharedUtils.keySecond, '${currentDateTime.millisecondsSinceEpoch}');
      }
    });
  }

  Future<Duration> getSyncDuration() async {
    final second =  await SharedUtils.getValue(SharedUtils.keySecond);
    print('second $second');
    final duration = second != null ? getDuration(int.parse(second)) : const Duration(minutes: 0);
    print('duration ${duration.inMinutes}');
    return duration;
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

  initSession() async {
    benId =  (await SharedUtils.getValue(SharedUtils.keyBeneficiaryId))!;
    benPhone = (await SharedUtils.getValue(SharedUtils.keyBeneficiaryPhone))!;
    print('benid $benId');
    print('benPhone $benPhone');
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
          mobile: benPhone,
          beneficiaryId: benId,
          amount: cash.amount,
          duration: bkashAppUsage?.usage.inMinutes ?? 1,
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
        if(amount.toString().length <= 5){
          totalSend += amount;
          final date = FetchDoubleFromString.retrieveDateData(item.body!);
          cashOuts.add(CashData(
              cashType: CashType.cashOut,
              amount: amount,
              date: date,
              tCode: 0,
              tImage: "assets/cash_out.jpg"));
        }
      } else if (str.contains('sent') ||
          str.contains('received') ||
          str.contains('add') ||
          str.contains('cashback') ||
          str.contains('cash in')) {

          double amount = 0.0;

        if (selectedService == "Nagad" && str.contains('sent')) {
          amount = FetchDoubleFromString.retrieveAmountData(item.body!, isSent: true);
        } else {
          amount = FetchDoubleFromString.retrieveAmountData(item.body!);
        }
        if(amount.toString().length <= 5){
          totalReceived += amount;
          final date = FetchDoubleFromString.retrieveDateData(item.body!);
          cashIns.add(CashData(
              cashType: CashType.cashIn,
              amount: amount,
              date: date,
              tCode: 1,
              tImage: "assets/add_money.jpg"));
        }
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

    return date ?? '';
  }
}
