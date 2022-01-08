import 'package:flutter/material.dart';
import 'package:sample/services/backend.dart';

import 'services/authentication.dart';
import 'ui/screens/home_page.dart';
import 'ui/screens/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initBackend();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: Typography.blackMountainView.apply(fontFamily: 'Trueno'),
        primarySwatch: Colors.amber,
      ),
      home: Authentication.currentUser != null
          ? const HomePage()
          : const LoginPage(),
    );
  }
}
