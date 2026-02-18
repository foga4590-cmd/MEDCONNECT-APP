import 'package:flutter/material.dart';

import 'chatScreen.dart';


class ChatModel {
  final String name;
  final String lastMessage;
  final String time;
  final bool isOnline;

  ChatModel({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.isOnline,
  });

  void operator [](String other) {}
}
final List<ChatModel> chats = [
    ChatModel(
      name: "Siemens Healthineers",
      lastMessage: "That sounds great, we'll get the quotation.",
      time: "10:42 AM",
      isOnline: true,
    ),
    ChatModel(
      name: "Medtronic",
      lastMessage: "The new ventilators are in stock.",
      time: "Yesterday",
      isOnline: true,
    ),
    ChatModel(
      name: "GE Healthcare",
      lastMessage: "Thanks for the information.",
      time: "3d ago",
      isOnline: false,
    ),
  ];

class MessagesScreen extends StatefulWidget {
   MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Supplier Chats"),
      ),
      body: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ListTile(
                    leading: Stack(
                      children: [
                        const CircleAvatar(radius: 25),
                        if (chat.isOnline)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          )
                      ],
                    ),
                    title: Text(chat.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(chat.lastMessage,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Text(chat.time),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(chatName: chat.name),
                        ),
                      );
                    },
                  );
                },
              ),
            
          );
          
                
          
        
      
  }

}