import 'package:auction_app/models/BidModel.dart';
import 'package:auction_app/models/ProductModel.dart';
import 'package:auction_app/services/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // make this a singleton class
  FirestoreService._privateConstructor();

  static final FirestoreService instance =
      FirestoreService._privateConstructor();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> saveUserName(String uid, String userName) async {
    await firestore.collection("users").doc(uid).set({"UserName": userName});
  }

  Future<bool> addProduct(ProductModel product) async {
    try {
      //add product to the uploader doc
      String currentUserId = FirebaseAuthService.instance.getCurrentUser().uid;
      product.ownerId = currentUserId;
      String generatedId = firestore
          .collection('users')
          .doc(currentUserId)
          .collection('ProductList')
          .doc()
          .id;
      //manually add generated id as Product id field
      product.id = generatedId;
      await firestore
          .collection('users')
          .doc(currentUserId)
          .collection('ProductList')
          .doc(generatedId)
          .set(product.toMap());
      //add product to the universal doc
      await firestore
          .collection('AllProducts')
          .doc(generatedId)
          .set(product.toMap());
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<String> getUserName() async {
    String currentUserId = FirebaseAuthService.instance.getCurrentUser().uid;
    final doc = await firestore.collection('users').doc(currentUserId).get();
    return doc['UserName'];
  }

  Stream<List<ProductModel>> userProductStream() {
    String currentUserId = FirebaseAuthService.instance.getCurrentUser().uid;
    return firestore
        .collection('users')
        .doc(currentUserId)
        .collection('ProductList')
        .snapshots()
        .map((snapshotList) => snapshotList.docs
            .map((singleDoc) => ProductModel.fromDocument(singleDoc))
            .toList());
  }

  Stream<List<ProductModel>> allProductStream() {
    return firestore.collection('AllProducts').snapshots().map((snapshotList) =>
        snapshotList.docs
            .map((singleDoc) => ProductModel.fromDocument(singleDoc))
            .toList());
  }

  Stream<List<BidModel>> bidsStream(String itemId) {
    return firestore
        .collection('AllProducts')
        .doc(itemId)
        .collection('bidList')
        .orderBy('bidPrice',descending: true)
        .snapshots()
        .map((snapshotList) => snapshotList.docs
            .map((singleDoc) => BidModel.fromDocument(singleDoc))
            .toList());
  }

  Future<bool> addBid(BidModel bid, String productId, String ownerId) async {
    try {
      String generatedId = firestore
          .collection('AllProducts')
          .doc(productId)
          .collection('bidList')
          .doc()
          .id;
      bid.bidId = generatedId;
      await firestore
          .collection('AllProducts')
          .doc(productId)
          .collection('bidList')
          .doc(generatedId)
          .set(bid.toMap());
      await firestore
          .collection('users')
          .doc(ownerId)
          .collection('ProductList')
          .doc(productId)
          .collection('bidList')
          .doc(generatedId)
          .set(bid.toMap());
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateBid(
      BidModel updatedBid, String productId, String ownerId) async {
    try {
      await firestore
          .collection('AllProducts')
          .doc(productId)
          .collection('bidList')
          .doc(updatedBid.bidId)
          .update({"bidPrice": updatedBid.bidPrice});
      await firestore
          .collection('users')
          .doc(ownerId)
          .collection('ProductList')
          .doc(productId)
          .collection('bidList')
          .doc(updatedBid.bidId)
          .update({"bidPrice": updatedBid.bidPrice});
      return true;
    } catch (error) {
      return false;
    }
  }
}
