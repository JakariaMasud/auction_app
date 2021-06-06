
import 'package:auction_app/screens/my_posted_item_screen.dart';
import 'package:auction_app/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PopUpMenu extends StatelessWidget {
  List<String> menuItem=<String>['Logout','My Posted Items'];
  BuildContext ctx;
  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    ctx=context;
    progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
    return PopupMenuButton<String>(onSelected:handleClick,itemBuilder: (context,){
      return menuItem.map((item) {
        return PopupMenuItem<String>(
          value: item,
          child: Text(item),);
      }).toList();
    });
  }
  void handleClick(String value) async{
    switch (value) {
      case 'Logout':
        progressDialog.style(message: "Logging out",borderRadius: 10.0,
            backgroundColor: Colors.white,
            progressWidget: CircularProgressIndicator(),
            elevation: 10.0,
            insetAnimCurve: Curves.easeInOut,
            progress: 0.0,
            maxProgress: 100.0,
            progressTextStyle: TextStyle(
                color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
            messageTextStyle: TextStyle(
                color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
        await progressDialog.show();
        await FirebaseAuthService.instance.logOut();
        await progressDialog.hide();
        break;
      case 'My Posted Items':
        Navigator.push(ctx, MaterialPageRoute(builder: (context)=>MyPostedItemScreen()));
    }
  }
}