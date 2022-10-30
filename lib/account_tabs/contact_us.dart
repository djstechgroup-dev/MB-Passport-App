import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:passportapp/attributes.dart';

class AccountContactUs extends StatefulWidget {
  const AccountContactUs({Key? key}) : super(key: key);

  @override
  State<AccountContactUs> createState() => _AccountContactUsState();
}

class _AccountContactUsState extends State<AccountContactUs> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController questionController = TextEditingController();

  double screenWidth = 0;
  double screenHeight = 0;

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
            _headingText("Contact Us"),
            formField(Icons.person, "Name", nameController, false),
            formField(Icons.email, "Email", emailController, false),
            formField(Icons.phone, "Phone", phoneController, false),
            formField(Icons.question_answer, "Question", questionController, true),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: () async {
                Feedback.forTap(context);
                String name = nameController.text;
                String email = emailController.text.trim();
                String phone = phoneController.text.trim();
                String question = questionController.text;

                if(name.isEmpty) {
                  showCustomSnackBar("Name can't be empty!");
                } else if(email.isEmpty) {
                  showCustomSnackBar("Email can't be empty!");
                } else if(phone.isEmpty) {
                  showCustomSnackBar("Phone can't be empty!");
                } else if(question.isEmpty) {
                  showCustomSnackBar("Question can't be empty!");
                } else {
                  try {
                    final Email emailToSend = Email(
                      recipients: ['help@myrtlebeachpassport.com'],
                      subject: 'Question from $name',
                      body: 'Name: $name\nEmail: $email\nPhone: $phone\nQuestion: $question',
                      isHTML: false,
                    );

                    await FlutterEmailSender.send(emailToSend);
                  } catch(e) {
                    showCustomSnackBar("An error occured, can't submit!");
                  }
                }
              },
              child: buttonSubmit(),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Widget buttonSubmit() {
    return Container(
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
          "Submit Question",
          style: TextStyle(
            fontFamily: "Actor",
            fontSize: screenHeight / 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget formField(IconData icon, String hint, TextEditingController controller, bool isQuestion) {
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
        maxLines: isQuestion ? 6 : 1,
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

  Widget _headingText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Actor",
        fontSize: screenHeight / 35,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.start,
    );
  }
}
