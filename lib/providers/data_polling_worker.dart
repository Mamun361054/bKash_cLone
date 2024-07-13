import 'package:flutter/cupertino.dart';
import 'package:thrift/main.dart';
import 'package:thrift/providers/sms_receiver.dart';

class DataPollingWorker {
  static final DataPollingWorker _instance = DataPollingWorker._();

  factory DataPollingWorker() {
    return _instance;
  }

  DataPollingWorker._();

  bool _running = false;

  /// 알람 플래그 탐색을 시작한다.
  Future<void> createPollingWorker(SMSReceiverProvider provider) async {
    if (_running) return;
    debugPrint('Starts polling worker');
    _running = true;
    fetchAndSendSms();
    _running = false;
  }
}
