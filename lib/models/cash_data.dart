import 'package:thrift/enums/home_menu.dart';

class CashData{

  final CashType cashType;
  final double amount;
  final String date;
  final String trxId;
  final int tCode;
  final String tImage;

  CashData({required this.cashType,required this.amount,required this.date,required this.trxId,required this.tCode,required this.tImage});

}