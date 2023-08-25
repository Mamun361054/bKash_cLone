class Result {
  final String mobile;
  final String beneficiaryId;
  final String type;
  final String? subType;
  final String? sender;
  final double amount;
  final String date;
  final String txnId;
  final int duration;
  final int? thriftDuration;

  Result(
      {required this.mobile,
      required this.beneficiaryId,
      required this.amount,
      required this.type,
      required this.duration,
      this.thriftDuration,
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
        "duration": thriftDuration
      };
}
