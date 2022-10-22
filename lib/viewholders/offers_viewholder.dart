import 'dart:math';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';
import 'package:passportapp/services/location_service.dart';

class OffersViewHolder extends StatefulWidget {
  final String? imageURL;
  final String name;
  final String category;
  final String address;
  final String tagline;
  final int totalOffers;
  final int used;
  const OffersViewHolder({Key? key, required this.imageURL, required this.category, required this.address, required this.name, required this.tagline, required this.used, required this.totalOffers}) : super(key: key);

  @override
  State<OffersViewHolder> createState() => _OffersViewHolderState();
}

class _OffersViewHolderState extends State<OffersViewHolder> {
  double screenWidth = 0;
  double screenHeight = 0;
  double lat = 0;
  double long = 0;

  bool calculated = false;

  int remaining = 0;

  String distance = "<1 Mile";

  Future<void> _getOtherData() async {
    List<geo.Location> latLongFromAddress = await LocationService().getLatLongFromAddress(widget.address);
    final lat = latLongFromAddress[0].latitude;
    final long = latLongFromAddress[0].longitude;

    double dist = calculateDistance(Attributes.locationData?.latitude, Attributes.locationData?.longitude, lat, long) * 1000 / 1609.344;

    setState(() {
      distance = dist < 99 ? (dist < 1 ? "<1 Mile" : "${dist.toStringAsFixed(0)} Miles") : "99+ Miles";
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    remaining = widget.totalOffers - widget.used;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _imageClip(widget.imageURL!),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Text(
            widget.name,
            style: TextStyle(
              fontFamily: "Actor",
              fontSize: screenHeight / 40,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _labelOffers(0, widget.category),
            const SizedBox(width: 8,),
            _labelOffers(1, distance),
          ],
        ),
        Container(
          height: screenHeight / 35,
          margin: const EdgeInsets.symmetric(
            vertical: 4,
          ),
          padding: const EdgeInsets.only(
            top: 2,
            left: 15,
            right: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Attributes.lightBlue,
          ),
          child: RichText(
            text: TextSpan(
              text: "Used ${widget.used} times today, ",
              children: [
                TextSpan(
                  text: "$remaining remaining",
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
              style: TextStyle(
                fontFamily: "Actor",
                color: Attributes.blue,
              ),
            ),
          ),
        ),
        DottedBorder(
          dashPattern: const [6, 3, 6, 3],
          child: Container(
            height: screenHeight / 16,
            width: screenWidth / 1.6,
            decoration: BoxDecoration(
              color: Attributes.yellow,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.tagline,
                style: TextStyle(
                  fontFamily: "Actor",
                  fontSize: screenHeight / 50,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double calculateDistance(lat1, long1, lat2, long2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((long2 - long1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  Widget _labelOffers(int options, String text) {
    return Container(
      height: screenHeight / 35,
      padding: EdgeInsets.only(
        top: options == 0 ? 2 : 0,
        bottom: options == 0 ? 4 : 0,
        left: 15,
        right: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: options == 0 ? const Color(0xFFE1EAFC) : Colors.white,
        border: Border.all(color: options != 0 ? Colors.black54 : const Color(0xFFE1EAFC)),
      ),
      child: Center(
          child: options == 0 ? Text(
            text,
            style: TextStyle(
              fontFamily: "Actor",
              color: Attributes.blue,
            ),
          ) : Row(
            children: [
              Image.asset(
                "assets/images/pinLocation.png",
                height: 14,
              ),
              Transform.translate(
                offset: const Offset(8, -1),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontFamily: "Actor",
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

  Widget _imageClip(String image) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          image,
          fit: BoxFit.fitHeight,
          width: screenWidth / 1.6,
        ),
      ),
    );
  }
}
