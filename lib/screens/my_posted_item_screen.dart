import 'package:auction_app/components/custom_text.dart';
import 'package:auction_app/components/pop_up_menu.dart';
import 'package:auction_app/components/product_item_card.dart';
import 'package:auction_app/models/ProductModel.dart';
import 'package:auction_app/services/cloud_firestore_service.dart';
import 'package:flutter/material.dart';

import 'add_product_screen.dart';

class MyPostedItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Posted Item"),
        actions: [PopUpMenu()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddProductScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: FirestoreService.instance.userProductStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length < 1) {
              return Center(
                child: CustomText(
                  text: 'No More Item Available Right Now',
                  size: 24.0,
                ),
              );
            } else {
              return Container(
                color: Colors.grey[100],
                child: GridView.count(
                  crossAxisCount: 2,
                  children: snapshot.data
                      .map((singleProduct) =>
                          ProductItemCard(productModel: singleProduct))
                      .toList(),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
