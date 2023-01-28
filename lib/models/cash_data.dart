import 'package:bkash/enums/home_menu.dart';

class CashData{

  final CashType cashType;
  final double amount;
  final String date;
  final int tCode;
  final String tImage;

  CashData({required this.cashType,required this.amount,required this.date,required this.tCode,required this.tImage});
}