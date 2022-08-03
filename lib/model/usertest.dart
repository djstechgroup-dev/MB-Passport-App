class UserTest {
  final String? email;
  final String? name;
  final String? favouriteBusiness;
  final String? offerRedeemed;
  final String? savedDeals;
  final String? savingsEarned;
  final String? password;
  final DateTime? date;

  UserTest({
    this.email,
    this.name,
    this.favouriteBusiness,
    this.offerRedeemed,
    this.savedDeals,
    this.savingsEarned,
    this.password,
    this.date,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['favouriteBusiness'] = favouriteBusiness;
    data['offerRedeemed'] = offerRedeemed;
    data['savedDeals'] = savedDeals;
    data['savingsEarned'] = savingsEarned;
    data['password'] = password;
    data['date'] = date.toString();
    return data;
  }
}