import 'package:bkash/enums/home_menu.dart';
import 'package:bkash/styles/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sms_receiver.dart';
import '../utils/TextUtils.dart';

class CashInWidget extends StatelessWidget {

  const CashInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final smsReceiverProvider = Provider.of<SMSReceiverProvider>(context);

    return Scaffold(
      body: ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: smsReceiverProvider.cashIns.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {

          final item = smsReceiverProvider.cashIns[index];

          return Card(margin: const EdgeInsets.fromLTRB(12.0, 6, 12.0, 6), elevation: 4.0, color: Colors.white, child: Container(margin: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(children: [
                  Image.asset(item.tImage, height: 60, width: 60, fit: BoxFit.fitWidth,),
                  const SizedBox(width: 12,),
                  Expanded(child: Column(children: [
                    Row(children: [Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(0, 2, 0, 2), child: Text(item.cashType == CashType.cashIn ? 'Cash In' : '', style: AppTheme.ntitleText, textAlign: TextAlign.start,),)),
                      Text('+৳${item.amount}', style: getAmtStyle(item.tCode), textAlign: TextAlign.start,)],),
                    Row(children: [Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(0, 2, 0, 2), child: Text(item.date, style: AppTheme.nbodyText, textAlign: TextAlign.start,),))],),
                  ],)),
                ],)],
            ),),);
        },
      ),
    );
  }
}