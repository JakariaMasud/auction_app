import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel{
  String id;
  String productName;
  String productDescription;
  String productPhoto;
  String minBidPrice;
  int auctionEndDatetime;
  String ownerId;

  ProductModel({this.id, this.productName, this.productDescription,
    this.productPhoto, this.minBidPrice, this.auctionEndDatetime,this.ownerId});

  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "productName":productName,
      "productDescription":productDescription,
      "productPhoto":productPhoto,
      "minBidPrice":minBidPrice,
      "auctionEndDatetime":auctionEndDatetime,
      "ownerId":ownerId

    };
  }

  factory ProductModel.fromDocument(DocumentSnapshot snapshot){
    return ProductModel(
      id: snapshot['id'],
      productName: snapshot['productName'],
      productDescription: snapshot['productDescription'],
      productPhoto: snapshot['productPhoto'],
      minBidPrice: snapshot['minBidPrice'],
      auctionEndDatetime: snapshot['auctionEndDatetime'],
        ownerId: snapshot['ownerId']
    );
  }
}