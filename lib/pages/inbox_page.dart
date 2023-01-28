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
      print(value);
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
      }
    }

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
                return ['bKash', 'Nagad', 'Refresh'].map((e) {
                  return PopupMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList();
              },
            ),
            // DropdownButton<String>(
            //   value: cashProvider.selectedService,
            //   icon: const Icon(Icons.arrow_downward,color: Colors.white,),
            //   elevation: 0,
            //   style: const TextStyle(color: Colors.black),
            //   borderRadius: BorderRadius.circular(12.0),
            //   underline: Container(
            //     height: 2,
            //     color: Colors.transparent,
            //   ),
            //   onChanged: (String? value) async {
            //     await cashProvider.onServiceChanged(val: value ?? services.first);
            //   },
            //   items: services.map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: ColoredBox(
            //           color: Colors.white,
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Text(value.toLowerCase(), style: AppTheme.tTrxText.copyWith(color: Colors.black),),
            //           )),
            //     );
            //   }).toList(),
            // ),
            // IconButton(
            //   onPressed: () async {
            //     await cashProvider.onRefresh();
            //   },
            //   icon: const Icon(Icons.refresh),
            // ),
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
