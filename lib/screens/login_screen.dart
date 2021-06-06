import 'package:auction_app/Helpers/size_config.dart';
import 'package:auction_app/components/custom_text_field.dart';
import 'package:auction_app/screens/signup_screen.dart';
import 'package:auction_app/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(
                  width: SizeConfig.width,
                  controller: emailController,
                  icon: Icon(
                    Icons.email,
                    color: Colors.blue,
                  ),
                  textInputType: TextInputType.emailAddress,
                  labelText: "Enter email",
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
                        message: "Checking Credential",
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
                    if (email.isNotEmpty && password.isNotEmpty) {
                      bool isSuccessful = await FirebaseAuthService.instance
                          .login(email, password);
                      if (isSuccessful) {
                        await progressDialog.hide();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login successful")));
                      } else {
                        await progressDialog.hide();
                        //failed to log in
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login failed")));
                      }
                    } else {
                      await progressDialog.hide();
                      //input is empty
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Email or Password is wrong")));
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
                      "Login",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
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
                      "Create An Account",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
