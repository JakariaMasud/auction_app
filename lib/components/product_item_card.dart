import 'package:auction_app/Helpers/size_config.dart';
import 'package:auction_app/models/ProductModel.dart';
import 'package:auction_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
class ProductItemCard extends StatelessWidget {
  ProductModel productModel;
  ProductItemCard({@required this.productModel});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.height/2.0,
      width: SizeConfig.width/ 2.2,
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailScreen(productModel)));
        },
        child: Card(
          elevation: 4.0,
          child: Column(
            children: <Widget>[
              Image.network(
                productModel.productPhoto,
                height: 140,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                productModel.productName,
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              SizedBox(
                height: 2.0,
              ),
              Text(
                "Base Price :${productModel.minBidPrice} Taka",
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              ),
              SizedBox(
                width: 8.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
