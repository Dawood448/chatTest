import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  ///-singUp
  Future register(String email, String password, String name,String image) async {
    try {
      UserCredential user = (await _auth.createUserWithEmailAndPassword(
          email: email, password: password));
      log("Register Successful");
      user.user?.updateDisplayName(name);
      Map<String, String> dataToSend = {
        'name': name,
        'email': email,
        'uid': _auth.currentUser!.uid,
        'image': image,
        'status': 'n/A',
      };
      _firebaseFirestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .set(dataToSend);
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains("] ")) {
        errorMessage = errorMessage.split("] ")[1];
      }
      throw errorMessage;
    }

  }

  //--Login
  Future<void> login({required String email, required String password}) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      log("Login Successful");
    }  catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains("] ")) {
        errorMessage = errorMessage.split("] ")[1];
      }
      throw errorMessage;
    }
  }

  //--LogOut
  Future logOut() async {
    await _auth.signOut();
  }
}
