class UserModel {
  final String phoneNumber;
  final String BeneficiaryId;

  UserModel({
    required this.phoneNumber,
    required this.BeneficiaryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'beneficiaryId': BeneficiaryId
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        phoneNumber: map['phoneNumber'] ?? '',BeneficiaryId:map['beneficiaryId']);
  }
}
