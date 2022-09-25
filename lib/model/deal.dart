class DealData {
  final String? id;
  final String? imageURL;
  final String? businessName;
  final String? category;
  final String? address;
  final String? description;
  final String? tagline;
  final int? hourOpen;
  final int? hourClose;
  final int? totalOffers;
  final int? totalUsed;

  DealData({
    this.id,
    this.imageURL,
    this.businessName,
    this.category,
    this.address,
    this.description,
    this.tagline,
    this.hourOpen,
    this.hourClose,
    this.totalOffers,
    this.totalUsed,
  });

  DealData.fromMap(Map map) :
        id = map['id'],
        imageURL = map['imageURL'],
        businessName = map['businessName'],
        category = map['category'],
        address = map['address'],
        description = map['description'],
        tagline = map['tagline'],
        hourOpen = map['hourOpen'],
        hourClose = map['hourClose'],
        totalOffers = map['totalOffers'],
        totalUsed = map['totalUsed'];

  Map toMap() {
    return {
      'id': id,
      'imageURL': imageURL,
      'businessName': businessName,
      'category': category,
      'address': address,
      'description': description,
      'tagline': tagline,
      'hourOpen': hourOpen,
      'hourClose': hourClose,
      'totalOffers': totalOffers,
      'totalUsed': totalUsed,
    };
  }

  factory DealData.fromJson(Map<String, dynamic> json) {
    return DealData(
        id: json['deals']['id'],
        imageURL: json['deals']['imageURL'],
        businessName: json['deals']['id'],
        category: json['deals']['id'],
        address: json['deals']['id'],
        description: json['deals']['id'],
        tagline: json['deals']['tagline'],
        hourOpen: json['deals']['id'],
        hourClose: json['deals']['id'],
        totalOffers: json['deals']['no_offers'],
        totalUsed: json['deals']['no_offers'],
    );
  }
}