import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ReferralSection extends StatefulWidget {
  const ReferralSection({Key? key}) : super(key: key);

  @override
  _ReferralSectionState createState() => _ReferralSectionState();
}

class _ReferralSectionState extends State<ReferralSection> {
  String rcode = "";
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        rcode = documentSnapshot.get('rcode');
      } else {
        print('Document does not exist on the database');
      }
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Referral Section',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hey ${FirebaseAuth.instance.currentUser?.email},",
            style: const TextStyle(fontSize: 35),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton.icon(
              onPressed: () {
                Share.share(
                  'Have you tried BHIVE.fund yet? Use my referral code: $rcode',
                );
              },
              icon: const Icon(
                Icons.share,
                size: 40,
              ),
              label: const Text(
                "\nShare Referral Link\n",
                style: TextStyle(fontSize: 20, fontFamily: "Roboto"),
              ),
              style: OutlinedButton.styleFrom(
                  primary: Colors.black, side: BorderSide.none),
            ),
          ),
          const Text(
            "Have you tried BHIVE.fund?\n"
            "I've been investing with them and thought you'd love it too!\n\n"
            "BHIVE.fund is one of India's largest and fastest-growing investment platforms.\n\n"
            "Investment with them is fast & easy.\n"
            "Click on the link to start investing\n\n",
            style: TextStyle(fontSize: 20, fontFamily: "Roboto"),
          ),
        ],
      ),
    );
  }
}
