class BusinessTest {
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

  BusinessTest({
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

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['imageURL'] = imageURL;
    data['businessName'] = businessName;
    data['category'] = category;
    data['address'] = address;
    data['description'] = description;
    data['tagline'] = tagline;
    data['hourOpen'] = hourOpen.toString();
    data['hourClose'] = hourClose.toString();
    data['totalOffers'] = totalOffers.toString();
    data['totalUsed'] = totalUsed.toString();
    return data;
  }
}