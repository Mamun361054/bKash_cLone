class AppConst {

  /// Make sure you are in live server or test server by base url
  static String baseUrlApi = "https://dexapi.metakave.com";
  static String bearerToken = "Bearer";

}

String? getSubType(String str){
  if(str.contains('bill')){
    return 'Bill Payment';
  } else if (str.contains('send')){
    return 'Outgoing Payment';
  } else if (str.contains('recharge')){
    return 'Mobile Recharge';
  } else if (str.contains('payment')){
    return 'Merchant Payment';
  } else if (str.contains('sent')){
    return 'Sent';
  } else if (str.contains('deposit')){
    return 'Received deposit Payment';
  }else if (str.contains('add')){
    return 'Incoming Payment ';
  } else if (str.contains('cashback')){
    return 'Received Cashback';
  } else if (str.contains('cash in')){
    return 'Cash in';
  }else{
    return 'Payment';
  }
}