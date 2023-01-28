import 'package:bkash/enums/home_menu.dart';
import 'package:bkash/models/cash_data.dart';
import 'package:bkash/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

final services = ['bKash','Nagad'];

class SMSReceiverProvider extends ChangeNotifier{

  double totalReceived = 0.0;
  double totalSend = 0.0;
  String selectedService = services.first;

  SMSReceiverProvider(){
    getAllSMS();
    initialService();
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
        address: selectedService == 'Nagad' ? 'NAGAD' :selectedService,
      );

      debugPrint('sms inbox messages: ${messages.length}');
      ///decode SMS data to [CashData]
      decodeCashData();
      ///notify listeners
      notifyListeners();
    } else {
      Permission.sms.request().then((status) async {
        if(status.isGranted){
          debugPrint(selectedService);
          messages = await _query.querySms(
            kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
            address: selectedService == 'Nagad' ? 'NAGAD' :selectedService,
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
    final value = await SharedUtils.getValue(SharedUtils.keyService) ;
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

  decodeCashData(){
    for (var item in messages) {

      final str = item.body!.toLowerCase();

      if(str.contains('bill') || str.contains('cash out') || str.contains('recharge') || str.contains('payment')){
        final amount = FetchDoubleFromString.retrieveAmountData(item.body!);
        totalSend += amount;
        final date = FetchDoubleFromString.retrieveDateData(item.body!);
        cashOuts.add(CashData(cashType: CashType.cashOut, amount: amount, date: date,tCode: 0,tImage: "assets/cash_out.jpg"));
      }else if(str.contains('sent') || str.contains('received') || str.contains('add') || str.contains('cashback') || str.contains('cash in')){
        double amount = 0.0;
        if(selectedService == "Nagad" && str.contains('sent')){
           amount = FetchDoubleFromString.retrieveAmountData(item.body!,isSent: true);
        }else {
          amount = FetchDoubleFromString.retrieveAmountData(item.body!);
        }
        totalReceived += amount;
        final date = FetchDoubleFromString.retrieveDateData(item.body!);
        cashIns.add(CashData(cashType: CashType.cashIn, amount: amount, date: date,tCode: 1,tImage: "assets/add_money.jpg"));
        FetchDoubleFromString.retrieveAmountData(item.body!);
      }
    }}


}


class FetchDoubleFromString {

  static double retrieveAmountData(String input,{bool isSent = false}){

    RegExp doubleRE = RegExp(r"-?(?:\d*\.)?\d+(?:[eE][+-]?\d+)?");

    var numbers = doubleRE.allMatches(input.replaceAll(',', '')).map((m) => double.parse(m[0].toString())).toList();

    return isSent ? numbers[1] : numbers.first;
  }

  static String retrieveDateData(String input){

    RegExp doubleRE = RegExp('\\d{2}/\\d{2}/\\d{4}');

    var date = doubleRE.firstMatch(input)?.group(0);

    debugPrint('group1 $date');
    return date ?? '';
  }
}
