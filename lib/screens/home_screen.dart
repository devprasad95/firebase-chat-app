import 'package:chat_app/methods/user_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../methods/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore database = FirebaseFirestore.instance;
  TextEditingController messageController = TextEditingController();
  String url = '';
  late Future _fetchStorage;
  Future<void> signOut() async {
    try {
      await Auth().signOut();
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> fetchStorage() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference = firebaseStorage.ref().child('love.png');
    await reference.getDownloadURL().then((urlValue) => url = urlValue);
  }

  Future<void> sendData({bool isEmoji = false}) async {
    database.collection('messages').doc().set(
          UserApp(
            message: isEmoji ? 'love' : messageController.text,
            uid: Auth().user!.uid,
            date: DateTime.now().toString(),
          ).toMap(),
        );
  }

  Widget messageWidget({required String message, required String uid}) {
    bool isMyMessage = uid == Auth().user!.uid;
    bool isLove = message.toLowerCase() == 'love';
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: isLove
          ? Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Image.network(
                url,
                height: 50,
              ),
            )
          : Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomRight: isMyMessage
                      ? const Radius.circular(0)
                      : const Radius.circular(20),
                  bottomLeft: isMyMessage
                      ? const Radius.circular(20)
                      : const Radius.circular(0),
                ),
                color: isMyMessage ? Colors.indigo : Colors.black12,
              ),
              child: Text(
                message,
                style: TextStyle(
                    color: isMyMessage ? Colors.white : Colors.black,
                    fontSize: 16),
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchStorage = fetchStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: _fetchStorage,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text(
                snapshot.error.toString(),
              );
            } else {
              return StreamBuilder<QuerySnapshot>(
                  stream: database
                      .collection('messages')
                      .orderBy('date')
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Widget> messageList = [];
                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;

                      for (var doc in docs) {
                        final message = doc['messages'];
                        final date = doc['date'];
                        final uid = doc['uid'];
                        messageList
                            .add(messageWidget(message: message, uid: uid));
                      }
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            reverse: true,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: messageList),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 10,
                          ),
                          child: TextField(
                            style: const TextStyle(fontSize: 20),
                            controller: messageController,
                            decoration: InputDecoration(
                              prefixIcon: GestureDetector(
                                onTap: () async {
                                  await sendData(isEmoji: true);
                                  messageController.clear();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    url,
                                    height: 30,
                                  ),
                                ),
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    await sendData();
                                    messageController.clear();
                                  },
                                  icon: const Icon(Icons.send)),
                              hintText: 'Email',
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                  width: 2,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.01),
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
