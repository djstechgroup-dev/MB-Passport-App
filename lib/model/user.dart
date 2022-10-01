class UserData {
  final String? token;
  final String? uid;
  final String? displayName;
  final String? email;
  final String? phone;
  final String? savedDeals;
  final int? offersRedeemed;
  final int? savingsEarned;

  UserData({
    this.token,
    this.uid,
    this.displayName,
    this.email,
    this.phone,
    this.savedDeals,
    this.offersRedeemed,
    this.savingsEarned,
  });

  UserData.fromMap(Map map) :
        token = map['token'],
        uid = map['uid'],
        displayName = map['displayName'],
        email = map['email'],
        phone = map['phone'],
        savedDeals = map['savedDeals'],
        offersRedeemed = map['offersRedeemed'],
        savingsEarned = map['savingsEarned'];

  Map toMap() {
    return {
      'token': token,
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phone': phone,
      'savedDeals': savedDeals,
      'offersRedeemed': offersRedeemed,
      'savingsEarned': savingsEarned,
    };
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
    data['email'] = email;
    data['name'] = displayName;
    return data;
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      token: json['token'],
      uid: json['_id'],
      displayName: json['displayName'],
      email: json['email'],
    );
  }
}

class UserAttributes {
  static String favoriteBusiness = " ";
  static String savedDeals = " ";
  static String? profilePicURL = " ";
  static int offersRedeemed = 0;
  static int savingsEarned = 0;
}