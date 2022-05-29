import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../methods/auth.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  Future<void> signIn() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(
        () {
          errorMessage = e.message ?? '';
        },
      );
    }
  }

  Future<void> createAccount() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(
        () {
          errorMessage = e.message ?? '';
        },
      );
    }
  }

  Future<void> resetPassword() async {
    try {
      await Auth().sendPasswordResetWithEmail(email: emailController.text);
    } on FirebaseAuthException catch (e) {
      setState(
        () {
          errorMessage = e.message ?? '';
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              Image.asset('images/chat.png'),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: Colors.black.withOpacity(0.03),
                  filled: true,
                  labelText: 'E-Mail',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: Colors.black.withOpacity(0.03),
                    filled: true,
                    labelText: 'Password'),
              ),
              ElevatedButton(
                onPressed: () {
                  signIn();
                },
                child: const Text("Log In"),
              ),
              ElevatedButton(
                onPressed: () {
                  createAccount();
                },
                child: const Text("Register"),
              ),
              TextButton(
                onPressed: () {
                  resetPassword();
                },
                child: const Text('Forgot Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
