class UserData {
  final String? uid;
  final String? displayName;
  final String? email;
  final String? phone;
  final String? role;

  UserData({
    this.uid,
    this.displayName,
    this.email,
    this.phone,
    this.role,
  });

  UserData.fromMap(Map map) :
        uid = map['uid'],
        displayName = map['displayName'],
        email = map['email'],
        phone = map['phone'],
        role = map['role'];

  Map toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }
}

class UserAttributes {
  static String favoriteBusiness = " ";
  static String savedDeals = " ";
  static String? profilePicURL = " ";
  static int offersRedeemed = -1;
  static int savingsEarned = -1;
}