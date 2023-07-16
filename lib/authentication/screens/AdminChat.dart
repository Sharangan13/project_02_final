import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Admin'),
      ),
      body: ChatList(),
    );
  }
}

class ChatList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('chats').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final chatData = documents[index].data() as Map<String, dynamic>;
            final chatName = chatData['name'] as String;

            return ListTile(
              leading: CircleAvatar(
                child: Text(chatName[0]),
              ),
              title: Text(chatName),
              subtitle: Text('Last message'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatHistoryScreen(
                      chatId: documents[index].id,
                      chatName: chatName,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class ChatHistoryScreen extends StatelessWidget {
  final String chatId;
  final String chatName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatHistoryScreen({required this.chatId, required this.chatName});

  @override
  Widget build(BuildContext context) {
    CollectionReference chatCollection =
    _firestore.collection('chats').doc(chatId).collection('messages');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(chatName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatCollection.orderBy('timestamp').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final List<QueryDocumentSnapshot> documents =
                    snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final messageData =
                    documents[index].data() as Map<String, dynamic>;
                    final message = messageData['message'] as String;
                    final isSentByMe = messageData['isSentByMe'] as bool;

                    return ChatBubble(
                      message: message,
                      isSentByMe: isSentByMe,
                    );
                  },
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (message) {
                      chatCollection.add({
                        'message': message,
                        'isSentByMe': true,
                        'timestamp': DateTime.now(),
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Send message logic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  ChatBubble({
    required this.message,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.lightGreen[100] : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2.0,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
