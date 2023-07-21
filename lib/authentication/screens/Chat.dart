import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;

  ChatScreen({required this.receiverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage(String message) async {
    try {
      await _messagesCollection.add({
        'content': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to send message: $e'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var messageData =
                        documents[index].data() as Map<String, dynamic>;
                    var content = messageData['content'] ?? '';

                    return ListTile(
                      title: Text(content),
                    );
                  },
                );
              },
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        InputDecoration(labelText: 'Type your message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                    }
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

void main() {
  runApp(MaterialApp(
    home: ChatScreen(receiverId: 'Admin'),
  ));
}
