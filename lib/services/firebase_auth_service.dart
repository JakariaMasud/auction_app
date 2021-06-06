
import 'dart:ffi';

import 'package:auction_app/services/cloud_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  // make this a singleton class
  FirebaseAuthService._privateConstructor();

  static final FirebaseAuthService instance =
      FirebaseAuthService._privateConstructor();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> login(String email, password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return false;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return false;
      }
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //Save Username inside firestore database
      await FirestoreService.instance
          .saveUserName(userCredential.user.uid, name);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return false;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<User> get onAuthStateChanged {
    return auth.authStateChanges();
  }

  User getCurrentUser() {
    return auth.currentUser;
  }

  Future<void>logOut() async {
    await auth.signOut();
  }
}
