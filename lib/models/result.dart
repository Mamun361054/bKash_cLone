class Result {
  final String mobile;
  final String beneficiaryId;
  final String type;
  final double amount;
  final String date;
  final int duration;

  Result(
      {required this.mobile,
      required this.beneficiaryId,
      required this.amount,
      required this.type,
      required this.duration,
      required this.date});

  Map<String, dynamic> get toMap => {
        "beneficiaryId": beneficiaryId,
        "beneficiaryMobile": mobile,
        "type": type,
        "amount": amount,
        "date": date,
        "duration": duration
      };
}
