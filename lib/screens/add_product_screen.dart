import 'dart:io';
import 'package:auction_app/components/pop_up_menu.dart';
import 'package:auction_app/components/product_form_field.dart';
import 'package:auction_app/models/ProductModel.dart';
import 'package:auction_app/screens/home_screen.dart';
import 'package:auction_app/services/cloud_firestore_service.dart';
import 'package:auction_app/services/firebase_storage_service.dart';
import 'package:auction_app/services/image_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final productNameController = TextEditingController();
  final productDesController = TextEditingController();
  final productPriceController = TextEditingController();
  File _pickedImgFile;
  DateTime _selectedDate;
  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    progressDialog=ProgressDialog(context,isDismissible: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
        actions: [PopUpMenu()],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductFormField(
                controller: productNameController,
                labelText: "Product Name ",
                inputType: TextInputType.name,
              ),
              SizedBox(
                height: 20.0,
              ),
              ProductFormField(
                controller: productDesController,
                labelText: "Product Description ",
                inputType: TextInputType.text,
              ),
              ElevatedButton(
                  onPressed: () async {
                    _pickedImgFile = await ImagePickerService.instance
                        .pickImage(source: ImageSource.gallery);
                    setState(() {});
                  },
                  child: Text('Select Product Image')),
              SizedBox(
                height: 5.0,
              ),
              Text(_pickedImgFile == null
                  ? "No Image Selected"
                  : "Image Selected"),
              ProductFormField(
                controller: productPriceController,
                labelText: "Min Bid Price for Product",
                inputType: TextInputType.number,
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: _selectedDate != null
                          ? _selectedDate
                          : DateTime.now(),
                      firstDate: DateTime(2019, 1),
                      lastDate: DateTime(2030, 12),
                    ).then((pickedDate) {
                      //do whatever you want
                      _selectedDate = pickedDate;
                      setState(() {});
                    });
                  },
                  child: Text("Select Date")),
              SizedBox(
                height: 5.0,
              ),
              Text(_selectedDate == null
                  ? "No Date Selected"
                  : DateFormat('d MMM y').format(_selectedDate)),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  onPressed: () async {
                    String productName = productNameController.text.trim();
                    String productDes = productDesController.text.trim();
                    String productPrice = productPriceController.text.trim();
                    if (productName.isNotEmpty &&
                        productDes.isNotEmpty &&
                        productPrice.isNotEmpty &&
                        _selectedDate != null &&
                        _pickedImgFile != null) {
                      progressDialog.style(message: "Adding Product",borderRadius: 10.0,
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
                      //upload product image
                      String imageUrl = await FirebaseStorageService.instance
                          .uploadProductPic(_pickedImgFile,
                              "${DateTime.now().microsecondsSinceEpoch} .jpg");
                      ProductModel product = ProductModel(
                          productName: productName,
                          productDescription: productDes,
                          minBidPrice: productPrice,
                          productPhoto: imageUrl,
                          auctionEndDatetime:
                              _selectedDate.microsecondsSinceEpoch);
                      bool isSuccessful =
                          await FirestoreService.instance.addProduct(product);
                      await progressDialog.hide();
                      if (isSuccessful) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("something went wrong")));

                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("input is not valid")));
                      return;
                    }
                  },
                  child: Row(
                    children: [
                      Spacer(),
                      Text("process to add Product"),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
