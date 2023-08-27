class Result {
  final String mobile;
  final String beneficiaryId;
  final String type;
  final String? subType;
  final String? sender;
  final double amount;
  final String date;
  final String rawData;
  final String txnId;
  final int duration;
  final int? thriftDuration;
  final int? nagadDuration;

  Result(
      {required this.mobile,
      required this.beneficiaryId,
      required this.amount,
      required this.type,
      required this.rawData,
      required this.duration,
      this.thriftDuration,
      this.nagadDuration,
      this.sender,
      required this.txnId,
      this.subType,
      required this.date});

  Map<String, dynamic> get toMap => {
        "beneficiaryId": beneficiaryId,
        "beneficiaryMobile": mobile,
        "type": type,
        "sender": sender,
        "sub_type": subType,
        "amount": amount,
        "date": date,
        "trxid": txnId,
        "duration_bkash": duration,
        "duration": thriftDuration,
        "raw_sms": rawData,
        "duration_nagad": nagadDuration
      };
}
