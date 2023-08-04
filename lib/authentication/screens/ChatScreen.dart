import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String userId;

  ChatScreen({required this.userId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Admin'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('conversations')
                  .doc(widget.userId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final messages = snapshot.data?.docs;
                final user = FirebaseAuth.instance.currentUser;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages?.length,
                  itemBuilder: (context, index) {
                    final message = messages?[index].get('message');
                    final senderId = messages?[index].get('senderId');
                    final isUserMessage = senderId == user?.uid;

                    return MessageBubble(
                      message: message,
                      isUserMessage: isUserMessage,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _sendMessage(widget.userId),
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String userId) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('conversations')
          .doc(userId)
          .collection('messages')
          .add({
        'senderId': userId,
        'message': message,
        'timestamp': DateTime.now(),
      });
      _messageController.clear();
    }
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUserMessage;

  MessageBubble({required this.message, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isUserMessage ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            message,
            style:
                TextStyle(color: isUserMessage ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
