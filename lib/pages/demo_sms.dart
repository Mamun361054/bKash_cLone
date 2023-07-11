import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sms_receiver.dart';

class SMSBinderView extends StatefulWidget {
  const SMSBinderView({Key? key}) : super(key: key);

  @override
  State<SMSBinderView> createState() => _SMSBinderViewState();
}

class _SMSBinderViewState extends State<SMSBinderView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final cashProvider = Provider.of<SMSReceiverProvider>(context);

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: cashProvider.cashIns.length,
          itemBuilder: (BuildContext context, int i) {
            var message = cashProvider.cashIns[i];

            return ListTile(
              title: Text('${message.amount} [${message.date}]'),
              subtitle: Text('${message.cashType}'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          cashProvider.onRefresh();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
