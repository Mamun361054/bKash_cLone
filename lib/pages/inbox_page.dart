import 'package:thrift/pages/login_screen.dart';
import 'package:thrift/providers/data_polling_worker.dart';
import 'package:thrift/utils/shared_preferences.dart';
import 'package:thrift/widgets/cash_in_widget.dart';
import 'package:thrift/widgets/cashout_widget.dart';
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

class _InboxPageState extends State<InboxPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
    case AppLifecycleState.resumed:
    DataPollingWorker().createPollingWorker(context.read<SMSReceiverProvider>());
    break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cashProvider = Provider.of<SMSReceiverProvider>(context);

    cashProvider.initSession();

    void handleMenuItem(String value) async {
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
          SharedUtils.clearCache().then((_) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          });
          break;
      }
    }

    ///store data from device to server if last stored
    ///data-time is accessed threshold data-time(for
    ///example after 30 min data will be updated)
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
              onSelected: handleMenuItem,
              itemBuilder: (_) {
                return ['bKash', 'Nagad', 'Refresh', 'Logout'].map((e) {
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
