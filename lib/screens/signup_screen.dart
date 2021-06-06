import 'package:auction_app/Helpers/size_config.dart';
import 'package:auction_app/components/custom_text_field.dart';
import 'package:auction_app/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                width: SizeConfig.width,
                controller: nameController,
                icon: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                textInputType: TextInputType.name,
                labelText: "Enter Name",
              ),
              CustomTextField(
                width: SizeConfig.width,
                controller: emailController,
                icon: Icon(
                  Icons.email,
                  color: Colors.blue,
                ),
                textInputType: TextInputType.emailAddress,
                labelText: "Enter Email",
              ),
              CustomTextField(
                width: SizeConfig.width,
                controller: passwordController,
                icon: Icon(
                  Icons.lock,
                  color: Colors.blue,
                ),
                textInputType: TextInputType.text,
                labelText: "Enter Password",
                obscureText: true,
              ),
              GestureDetector(
                  onTap: () async {
                    progressDialog.style(
                        message: "Creating account",
                        borderRadius: 10.0,
                        backgroundColor: Colors.white,
                        progressWidget: CircularProgressIndicator(),
                        elevation: 10.0,
                        insetAnimCurve: Curves.easeInOut,
                        progress: 0.0,
                        maxProgress: 100.0,
                        progressTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400),
                        messageTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600));
                    await progressDialog.show();
                    String email = emailController.text.trim();
                    String password = emailController.text.trim();
                    String name = nameController.text;
                    if (email.isNotEmpty &&
                        password.isNotEmpty &&
                        name.isNotEmpty) {
                      bool isSuccessful = await FirebaseAuthService.instance
                          .signUp(email, password, name);
                      if (isSuccessful) {
                        await progressDialog.hide();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Signup successful")));
                      } else {
                        //failed to log in
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Signup failed")));
                        await progressDialog.hide();
                      }
                    } else {
                      //input is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Input is not valid")));
                      await progressDialog.hide();
                    }
                  },
                  child: Container(
                    width: SizeConfig.width * 0.9,
                    height: SizeConfig.height * 0.065,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(29.0),
                    ),
                    child: Center(
                        child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    )),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
