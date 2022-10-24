import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';
import 'package:passportapp/model/user.dart';

class AccountInformation extends StatefulWidget {
  const AccountInformation({Key? key}) : super(key: key);

  @override
  State<AccountInformation> createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  double screenWidth = 0;
  double screenHeight = 0;

  String id = "Id";
  String name = "Name";
  String email = "Email";
  String address = "Address";

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  Future<void> _getUserData() async {
    if(!UserAttributes.isAppleUser) {
      setState(() {
        id = FirebaseAuth.instance.currentUser!.uid;
        name = FirebaseAuth.instance.currentUser!.displayName!;
        email = FirebaseAuth.instance.currentUser!.email!;
        address = "Address";
      });
    } else {
      setState(() {
        id = FirebaseAuth.instance.currentUser!.uid;
        name = UserAttributes.appleUserName;
        email = FirebaseAuth.instance.currentUser!.email!;
        address = "Address";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: screenWidth / 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _profilePicture()),
            formField(false, Icons.tag, id, idController),
            formField(true, Icons.person, name, nameController),
            formField(false, Icons.mail, email, emailController),
            formField(true, Icons.location_on, address, addressController),
            GestureDetector(
              onTap: () {
                Feedback.forTap(context);
              },
              child: buttonSave(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profilePicture() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight / 30,
      ),
      height: screenWidth / 3.5,
      width: screenWidth / 3.5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: UserAttributes.profilePicURL != null ?
        Image.network(UserAttributes.profilePicURL!) :
        Image.asset("assets/images/logoOnly.png"),
      ),
    );
  }

  Widget formField(bool enabled, IconData icon, String hint, TextEditingController controller) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(
        top: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      child: TextFormField(
        enabled: enabled,
        maxLines: 1,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          border: InputBorder.none,
        ),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }

  Widget buttonSave() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight / 50,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Attributes.blue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Text(
          "Save Changes",
          style: TextStyle(
            fontFamily: "Actor",
            fontSize: screenHeight / 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
