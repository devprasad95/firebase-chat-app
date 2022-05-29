import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({Key? key}) : super(key: key);

  Future _reload({User? user}) async {
    await user?.reload();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    return FutureBuilder(
      future: _reload(user: user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: LinearProgressIndicator(),
            ),
          );
        } else {
          if (user != null) {
            return const HomeScreen();
          } else {
            return LogInScreen();
          }
        }
      },
    );
  }
}
