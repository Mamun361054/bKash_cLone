import 'package:shared_preferences/shared_preferences.dart';

class SharedUtils{
  static String keyService = "service";
  static String keyBeneficiaryId = "beneficiary";
  static String keyBeneficiaryPhone = "phone";
  static String keyIsLoggedIn = 'isLoggedIn';
  static String keyIsFirstTime = 'isFirstTime';
  static String keySecond = 'isLoggedIn';

  static setValue(String key,String? value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value!);
  }

  static Future<String?> getValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      var value = prefs.getString(key);
      return value;
  }

  static setIntValue(String key,int? value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value!);
  }

  static setBoolValue(String key,bool? value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value!);
  }

  static Future<int?> getIntValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      var value = prefs.getInt(key);
      return value;

  }

  static Future<bool> getBoolValue(String key,{bool defaultValue = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      var value = prefs.getBool(key);
      return value ?? defaultValue;
  }

  static deleteKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<bool> clearCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}