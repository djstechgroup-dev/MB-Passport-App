class BusinessData {
  final String? businessId;
  final String? businessName;
  final List<dynamic>? otherDeals;

  BusinessData({
    this.businessId,
    this.businessName,
    this.otherDeals,
  });

  factory BusinessData.fromJson(Map<String, dynamic> json) {
    return BusinessData(
      businessId: json['business']['_id'],
      businessName: json['business']['businessName'],
      otherDeals: json['business']['deals'],
    );
  }
}