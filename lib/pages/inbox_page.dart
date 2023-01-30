import 'package:bkash/pages/login_screen.dart';
import 'package:bkash/utils/shared_preferences.dart';
import 'package:bkash/widgets/cash_in_widget.dart';
import 'package:bkash/widgets/cashout_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sms_receiver.dart';
import '../styles/AppTheme.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {

    final cashProvider = Provider.of<SMSReceiverProvider>(context);

    void _handleMenuItem(String value) async {
      switch (value) {
        case 'bKash':
          await cashProvider.onServiceChanged(val: services.first);
          break;
        case 'Nagad':
          await cashProvider.onServiceChanged(val: services.last);
          break;
        case 'Refresh':
          await cashProvider.onRefresh();
          break;
        case 'Logout':
          SharedUtils.clearCache().then((_){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
          });
          break;
      }
    }
    ///store data from device to server if last stored
    ///data-time is accessed threshold data-time(for
    ///example after 5 days data will be updated)
    cashProvider.dataStoreHelper();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: AppTheme.actionBarText,
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Cash In",
              ),
              Tab(
                text: "Cash Out",
              ),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: _handleMenuItem,
              itemBuilder: (_) {
                return ['bKash', 'Nagad', 'Refresh','Logout'].map((e) {
                  return PopupMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const Expanded(
              child: TabBarView(
                children: [
                  CashInWidget(),
                  CashOutWidget(),
                ],
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              const Text('Total Received'),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '৳ ${cashProvider.totalReceived.toStringAsFixed(2)}',
                                style: AppTheme.tTrxTextGreen,
                              )
                            ],
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              const Text('Total Send'),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                  '৳ ${cashProvider.totalSend.toStringAsFixed(2)}',
                                  style: AppTheme.tTrxTextRed)
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
