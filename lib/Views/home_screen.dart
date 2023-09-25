import 'package:chat_test/Utils/lottie_animation.dart';
import 'package:chat_test/Views/chat_room.dart';
import 'package:chat_test/Views/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Auth/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  TextEditingController nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getSearchResults(String name) {
    return _firebaseFirestore
        .collection('user')
        .where("name", isEqualTo: name)
        .snapshots();
  }

  String generateChatRoomId(String user1Id, String user2Id) {
    if (user1Id[0].toLowerCase().codeUnits[0] >
        user2Id[0].toLowerCase().codeUnits[0]) {
      return "$user1Id$user2Id";
    } else {
      return "$user2Id$user1Id";
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus('online');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus('online');
    } else {
      setStatus('offline');
    }
  }

  setStatus(String status) async {
    _firebaseFirestore.collection('user').doc(_auth.currentUser!.uid).update({
      'status': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Get.to(() => const SplashScreen());
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const LoadingHome(),
            ),
          ),
        ),
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              final AuthController authController = Get.find<AuthController>();
              authController
                  .logOut()
                  .then((value) => Get.off(() => const LoginScreen()));
            },
            icon: const Icon(Icons.login_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TextFormField(
            //   controller: nameController,
            //   decoration: InputDecoration(
            //     hintText: "Search with name",
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //   ),
            //   onChanged: (text) {
            //     setState(() {});
            //   },
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // Use StreamBuilder to display real-time search results.
            StreamBuilder(
              stream: _firebaseFirestore.collection('user').snapshots(),
              builder:
                  (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child:  CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text("No matching users found.");
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        Map<String, dynamic> userData =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        // String firstLetterCapital =
                        //     userData['name'].substring(0, 1).toUpperCase() +
                        //         userData['name'].substring(1);

                        return GestureDetector(
                          onTap: () {
                            String currentUserId = _auth.currentUser?.uid ?? '';
                            String chatId = generateChatRoomId(
                                currentUserId, userData['uid']);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                    chatId: chatId, userData: userData),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    userData['image'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            title: Text(userData['name']),
                            subtitle: Text(
                              userData['email'].toString(),
                            ),
                            trailing: CircleAvatar(
                              radius: 5,
                              backgroundColor: userData['status'] == 'online'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
