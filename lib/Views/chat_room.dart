import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  final String chatId;
  final Map<String, dynamic> userData;
  const ChatRoom({super.key, required this.chatId, required this.userData});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController chatController = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime localTime = DateTime.now();

  Future sendMessage() async {
    Map<String, dynamic> message = {
      'sendBy': _auth.currentUser!.displayName,
      'message': chatController.text,
      'time': localTime
    };

    _firebaseFirestore
        .collection('chating')
        .doc(widget.chatId)
        .collection('chats')
        .add(message);
    chatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
            stream: _firebaseFirestore
                .collection('user')
                .doc(widget.userData['uid'])
                .snapshots(),
            builder: (BuildContext ctx, snapshot) {
              return Column(
                children: [
                  Text(widget.userData['name']),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.userData['status'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: widget.userData['status'] == 'online'
                            ? Colors.green.shade500
                            : Colors.grey),
                  ),
                ],
              );
            }),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Image.network(
              widget.userData['image'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 1.30,
              width: size.width,
              // color: Colors.grey,
              child: StreamBuilder(
                stream: _firebaseFirestore
                    .collection('chating')
                    .doc(widget.chatId)
                    .collection('chats')
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder:
                    (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("");
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        Map<String, dynamic>? message =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>?;
                        return messageBody(size, message!);
                      },
                    );
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              height: size.height / 12,
              width: size.width,
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: chatController,
                      decoration: InputDecoration(
                        hintText: "Enter Message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageBody(Size size, Map<String, dynamic> message) {
    // Timestamp firebaseTimestamp = message['time'];
    // DateTime localTime = firebaseTimestamp.toDate().toLocal();
    // String formattedTime = DateFormat('h:mm a').format(localTime);
    return Container(
      width: size.width,
      alignment: message['sendBy'] == _auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.blue),
        child: Text(
          message['message'],
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
