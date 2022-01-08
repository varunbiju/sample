import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sample/services/authentication.dart';
import 'package:sample/services/database.dart';
import 'package:share_plus/share_plus.dart';

import 'login_page.dart';
import 'referral_dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _myReferralCode = "";
  bool _isLoading = false;

  init() async {
    setState(() {
      _isLoading = true;
    });
    await Database.databaseInstance
        .collection('users')
        .doc(Authentication.authInstance.currentUser?.uid)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        _myReferralCode = documentSnapshot.get('myReferralCode');
      }
    }).then((value) => setState(() {
              _isLoading = false;
            }));
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
            centerTitle: true,
            title: const Text(
              'Home Page',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () async {
                  await Authentication.authInstance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LoginPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(15),
            children: <Widget>[
              Text(
                "Hey ${Authentication.currentUser?.email},",
                style: const TextStyle(fontSize: 35),
              ),
              const Text(
                "\nWhy don't you introduce us to your friends?\n\n"
                "Invite a friend to invest on BHIVE.fund and get a cashback equal to 1% of their investment\n",
                style: TextStyle(fontSize: 25, fontFamily: "Roboto"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      Share.share(
                        "Hey, have you tried BHIVE.fund?\n"
                        "I've been Investing with them and thought you’d love it too!\n"
                        "BHIVE.fund is one of India's largest and fastest-growing investment platforms.\n"
                        "Investing with them is fast & easy. Use my referral code to start investing: $_myReferralCode",
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 75),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                    label: const Text(
                      "Refer a Friend!",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ReferralDashboard(),
                        ),
                      );
                    },
                    child: const Text(
                      "Referral Dashboard",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 75),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
