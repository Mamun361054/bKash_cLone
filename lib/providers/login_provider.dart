import 'package:provider/provider.dart';
import 'package:thrift/data/dio_service/repository.dart';
import 'package:thrift/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../data/response_model/body_login.dart';
import '../pages/inbox_page.dart';
import 'bkash_provider.dart';

class LoginProvider extends ChangeNotifier {
  TextEditingController phoneController = TextEditingController();
  TextEditingController beneficiaryIdController = TextEditingController();


  void loginApi(BuildContext context) async {
    if (phoneController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "phone filed can't be empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (beneficiaryIdController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "beneficiary field can't be empty ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      var bodyLogin = BodyLogin(phone: phoneController.text, beneficiaryId: beneficiaryIdController.text);
      var apiResponse = await Repository.getLogin(bodyLogin);

      if (apiResponse.httpCode == 200) {

        SharedUtils.setValue(SharedUtils.keyBeneficiaryPhone, phoneController.text);
        SharedUtils.setValue(SharedUtils.keyBeneficiaryId, beneficiaryIdController.text);
        SharedUtils.setBoolValue(SharedUtils.keyIsLoggedIn, true);

        context.read<UserProvider>().onPhoneChange(phoneController.text);
        context.read<UserProvider>().onBeneficiaryChange(beneficiaryIdController.text);

        Fluttertoast.showToast(
            msg: "লগইন সফল হয়েছে",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 18.0);

        Navigator.push(context, MaterialPageRoute(builder: (context) => const InboxPage(title: 'Summary',)));

      } else {
        Fluttertoast.showToast(
            msg: apiResponse.httpCode == 401
                ? "ভুল ব্যবহারকারী নাম বা পাসওয়ার্ড"
                : 'ইন্টারনেটে চালু নেই!\nইন্টারনেটে চালু করে আবার লগইন করুন',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 18.0);
      }
      notifyListeners();
    }
  }

}
