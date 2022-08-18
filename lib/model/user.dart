class UserData {
  final String? token;
  final String? uid;
  final String? displayName;
  final String? email;
  final String? phone;

  UserData({
    this.token,
    this.uid,
    this.displayName,
    this.email,
    this.phone,
  });

  UserData.fromMap(Map map) :
        token = map['token'],
        uid = map['uid'],
        displayName = map['displayName'],
        email = map['email'],
        phone = map['phone'];

  Map toMap() {
    return {
      'token': token,
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phone': phone,
    };
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
    data['email'] = email;
    data['name'] = displayName;
    return data;
  }
}

class UserAttributes {
  static String favoriteBusiness = " ";
  static String savedDeals = " ";
  static String? profilePicURL = " ";
  static int offersRedeemed = -1;
  static int savingsEarned = -1;
}