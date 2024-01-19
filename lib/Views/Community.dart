import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:seizure_deck/data/comment_data.dart';
import 'package:seizure_deck/providers/user_provider.dart';

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key});

  @override
  _DiscussionScreenState createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  final TextEditingController _messageController = TextEditingController();

  
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Discussion'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final message = comments[index];
                UserProvider userProvider = Provider.of(context, listen: false);
                int? uid = userProvider.uid;
                bool isSender = int.parse(message.uid) == uid;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment:
                        isSender ? Alignment.centerRight : Alignment.centerLeft,
                    child: Card(
                      color: isSender ? Colors.blue : Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comments[index].name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSender ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              comments[index].comment,
                              style: TextStyle(
                                color: isSender ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _addMessage(_messageController.text);
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> fetchComments() async {

    final response = await http.get(Uri.parse('https://seizuredeck.000webhostapp.com/community_get.php'));

    if (response.statusCode == 200) {
      
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        comments = data.map((comment) => Comment.fromJson(comment)).toList();
      });
    } else {
      
      
      throw Exception('Failed to load comments');
    }
  }


  Future<void> _addMessage(String text) async {
    UserProvider userProvider = Provider.of(context, listen: false);
    int? uid = userProvider.uid;
    final response = await http.post(
        Uri.parse('https://seizuredeck.000webhostapp.com/community.php'),
        body:{
          'uid': uid.toString(),
          'comment': text,
          'datetime': DateTime.now().toString(),
        }
    );
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      fetchComments();
    } else {
      print('Failed to add message');
    }
  }
}
