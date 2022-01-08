import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ReferralDashboard extends StatefulWidget {
  const ReferralDashboard({Key? key}) : super(key: key);

  @override
  _ReferralDashboardState createState() => _ReferralDashboardState();
}

class _ReferralDashboardState extends State<ReferralDashboard> {
  int referralCount = 0;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  List myReferralList = [];
  bool _isLoading = true;

  init() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('myReferrals')
        .orderBy('email')
        .get()
        .then((QuerySnapshot querySnapshot) {
      referralCount = querySnapshot.size;
      for (var doc in querySnapshot.docs) {
        myReferralList.add(doc.get('email'));
      }
    }).then((value) {
      setState(() {
        _isLoading = false;
      });
      return null;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: SafeArea(
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
              'Referral Dashboard',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.all(15),
            children: <Widget>[
              Row(
                children: [
                  const Text(
                    "Your Rewards",
                    style: TextStyle(fontSize: 35),
                  ),
                  Icon(
                    Icons.wallet_giftcard,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Cash Earned:",
                    style: TextStyle(fontSize: 20, fontFamily: "Roboto"),
                  ),
                  Text(
                    "Rs ${referralCount * 100}",
                    style: const TextStyle(
                        fontSize: 25,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "My Referrals",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              referralCount == 0
                  ? const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Center(
                        child: Text(
                          "Oops! You don't have any referrals yet!\n\n"
                          "Share your referral link to your friends.\n"
                          "As soon as they sign up, you receive Rs100!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: referralCount,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ListTile(
                            title: Text(myReferralList[index]),
                            trailing: const Text("Rs 100"),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        );
                      },
                    ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Column(
                  children: [
                    const Text("FAQ"),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "What are the incentives for referring a friend?",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Is there any eligibility criteria for me to send to out invites?",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "When will I get my referral bonus?",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Where will I receive this bonus?",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
