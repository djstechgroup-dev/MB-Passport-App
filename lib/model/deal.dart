class DealData {
  final String? id;
  final String? imageURL;
  final String? businessId;
  final String? businessName;
  final String? category;
  final String? address;
  final String? description;
  final String? tagline;
  final String? dayOpen;
  final String? dayClose;
  final List<dynamic>? otherDeals;
  final int? hourOpen;
  final int? hourClose;
  final int? totalOffers;
  final int? totalUsed;
  final String? activeTo;

  DealData({
    this.id,
    this.imageURL,
    this.businessId,
    this.businessName,
    this.category,
    this.address,
    this.description,
    this.tagline,
    this.otherDeals,
    this.dayOpen,
    this.dayClose,
    this.hourOpen,
    this.hourClose,
    this.totalOffers,
    this.totalUsed,
    this.activeTo,
  });

  DealData.fromMap(Map map) :
        id = map['id'],
        imageURL = map['imageURL'],
        businessId = map['businessId'],
        businessName = map['businessName'],
        category = map['category'],
        address = map['address'],
        description = map['description'],
        tagline = map['tagline'],
        otherDeals = map['otherDeals'],
        dayOpen = map['dayOpen'],
        dayClose = map['dayClose'],
        hourOpen = map['hourOpen'],
        hourClose = map['hourClose'],
        totalOffers = map['totalOffers'],
        totalUsed = map['totalUsed'],
        activeTo = map['active_to'];

  Map toMap() {
    return {
      'id': id,
      'imageURL': imageURL,
      'businessId': businessId,
      'businessName': businessName,
      'category': category,
      'address': address,
      'description': description,
      'tagline': tagline,
      'otherDeals': otherDeals,
      'dayOpen': dayOpen,
      'dayClose': dayClose,
      'hourOpen': hourOpen,
      'hourClose': hourClose,
      'totalOffers': totalOffers,
      'totalUsed': totalUsed,
      'active_to': activeTo,
    };
  }

  factory DealData.fromJson(Map<String, dynamic> json) {
    return DealData(
        id: json['deal']['_id'],
        imageURL: json['deal']['imageURL'],
        businessId: json['deal']['businessId']['_id'],
        businessName: json['deal']['businessId']['businessName'],
        category: json['deal']['businessId']['category'],
        address: json['deal']['businessId']['address'],
        description: json['deal']['businessId']['description'],
        tagline: json['deal']['tagline'],
        otherDeals: json['deal']['businessId']['deals'],
        dayOpen: json['deal']['businessId']['openingTime']['day'],
        dayClose: json['deal']['businessId']['closingTime']['day'],
        hourOpen: json['deal']['businessId']['openingTime']['time']['hours'],
        hourClose: json['deal']['businessId']['closingTime']['time']['hours'],
        totalOffers: json['deal']['no_offers'],
        totalUsed: json['deal']['used_deals'],
        activeTo: json['deal']['active_to'],
    );
  }
}