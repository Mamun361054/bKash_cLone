class Result {
  final String mobile;
  final String beneficiaryId;
  final String type;
  final double amount;
  final String date;
  final String txnId;
  final int duration;

  Result(
      {required this.mobile,
      required this.beneficiaryId,
      required this.amount,
      required this.type,
      required this.duration,
      required this.txnId,
      required this.date});

  Map<String, dynamic> get toMap => {
        "beneficiaryId": beneficiaryId,
        "beneficiaryMobile": mobile,
        "type": type,
        "amount": amount,
        "date": date,
        "trxid": txnId,
        "duration": duration
      };
}
