import 'package:cloud_firestore/cloud_firestore.dart';

class BidModel {
  String bidId;
  String bidPrice;
  String bidderId;
  String bidderName;

  BidModel({this.bidId,this.bidPrice, this.bidderId, this.bidderName});
  Map<String,dynamic> toMap(){
    return {
      "bidId":bidId,
      "bidPrice":bidPrice,
      "bidderId":bidderId,
      "bidderName":bidderName,

    };
  }

  factory BidModel.fromDocument(DocumentSnapshot snapshot){
    return BidModel(
        bidId:snapshot['bidId'],
        bidPrice: snapshot['bidPrice'],
        bidderId: snapshot['bidderId'],
       bidderName: snapshot['bidderName'],

    );
  }
}