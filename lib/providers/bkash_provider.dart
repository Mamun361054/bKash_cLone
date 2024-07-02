import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:thrift/models/user_model.dart';
import 'package:thrift/utils/global_state.dart';

const String userMap = 'user_map';
final box = Hive.box('user');

class UserProvider extends ChangeNotifier {
  String? phone;
  String? beneficiaryId;

  UserProvider() {
    phone = getPhone();
    beneficiaryId = getBeneficiaryId();
    globalState.set(userMap, UserModel(phoneNumber: phone ?? '', BeneficiaryId: beneficiaryId ?? '',).toMap());
  }

  void onPhoneChange(String phoneNumber) {
    box.put('phone', phoneNumber);
    phone = phoneNumber;
  }

  void onBeneficiaryChange(String beneficiaryId) {
    box.put('beneficiaryId', beneficiaryId);
    beneficiaryId = beneficiaryId;
  }

  String? getPhone() {
    return box.get('phone');
  }

  String? getBeneficiaryId() {
    return box.get('beneficiaryId');
  }
}
