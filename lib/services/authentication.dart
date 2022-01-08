import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/services/database.dart';

class Authentication {
  static FirebaseAuth authInstance = FirebaseAuth.instance;
  static User? get currentUser => authInstance.currentUser;

  static Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for this email.'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message!),
          ),
        );
      }
      return false;
    }
  }

  static Future<bool> signUp({
    required String email,
    required String password,
    required String referralCode,
    required BuildContext context,
  }) async {
    try {
      await authInstance.createUserWithEmailAndPassword(
          email: email, password: password);
      await Database.databaseInstance
          .collection('users')
          .doc(authInstance.currentUser?.uid)
          .set({
        'email': authInstance.currentUser?.email,
        'myReferralCode': authInstance.currentUser?.uid.substring(0, 5),
        'referralCode': referralCode,
      });
      await Database.databaseInstance
          .collection('users')
          .where('myReferralCode', isEqualTo: referralCode)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.collection('myReferrals').add({'email': email});
        }
      });
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak.'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An account already exists for that email.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message!),
          ),
        );
      }
      return false;
    }
  }
}
