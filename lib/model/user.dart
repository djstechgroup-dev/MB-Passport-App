class UserData {
  final String? uid;
  final String? displayName;
  final String? email;
  final String? phone;
  final String? role;
  final String? favoriteBusiness;
  final int? offersRedeemed;
  final int? savingsEarned;

  UserData({
    this.uid,
    this.displayName,
    this.email,
    this.phone,
    this.role,
    this.favoriteBusiness,
    this.offersRedeemed,
    this.savingsEarned,
  });

  UserData.fromMap(Map map) :
        uid = map['uid'],
        displayName = map['displayName'],
        email = map['email'],
        phone = map['phone'],
        role = map['role'],
        favoriteBusiness = map['favoriteBusiness'],
        offersRedeemed = map['offersRedeemed'],
        savingsEarned = map['savingsEarned'];

  Map toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phone': phone,
      'role': role,
      'favoriteBusiness': favoriteBusiness,
      'offersRedeemed': offersRedeemed,
      'savingsEarned': savingsEarned,
    };
  }
}