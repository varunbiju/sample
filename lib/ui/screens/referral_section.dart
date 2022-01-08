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
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String rcode = "";

  @override
  void initState() {
    _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        rcode = documentSnapshot.get('referralCode');
      } else {
        print('Document does not exist on the database');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            Text(
              "Hey ${_auth.currentUser?.email},",
              style: const TextStyle(fontSize: 35),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Have you tried BHIVE.fund?\n"
              "I've been investing with them and thought you'd love it too!\n\n"
              "BHIVE.fund is one of India's largest and fastest-growing investment platforms.\n\n"
              "Investment with them is fast & easy.\n"
              "Click on the link to start investing\n",
              style: TextStyle(fontSize: 20, fontFamily: "Roboto"),
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
          ],
        ),
      ),
    );
  }
}
