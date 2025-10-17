// // import 'package:flutter/material.dart';
// // import '../../constants/colors.dart'; // Ensure AppColors.primaryBlue is defined here

// // class ChatPage extends StatefulWidget {
// //   const ChatPage({super.key});

// //   @override
// //   State<ChatPage> createState() => _ChatPageState();
// // }

// // class _ChatPageState extends State<ChatPage> {
// //   final TextEditingController _messageController = TextEditingController();

// //   // Demo chat data
// //   List<Map<String, String>> messages = [
// //     {"sender": "other", "text": "Hi there! How can I help you today?"},
// //     {"sender": "me", "text": "I need to check stock availability."},
// //     {"sender": "other", "text": "Sure! Which product are you referring to?"},
// //   ];

// //   void sendMessage() {
// //     final text = _messageController.text.trim();
// //     if (text.isEmpty) return;

// //     setState(() {
// //       messages.add({"sender": "me", "text": text});
// //       _messageController.clear();
// //     });

// //     // You can call an API here to send the message
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Chat"),
// //         backgroundColor: AppColors.primaryBlue,
// //         foregroundColor: Colors.white,
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: ListView.builder(
// //               padding: const EdgeInsets.all(16),
// //               itemCount: messages.length,
// //               itemBuilder: (context, index) {
// //                 final msg = messages[index];
// //                 final isMe = msg["sender"] == "me";
// //                 return Align(
// //                   alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
// //                   child: Container(
// //                     margin: const EdgeInsets.symmetric(vertical: 6),
// //                     padding: const EdgeInsets.all(12),
// //                     decoration: BoxDecoration(
// //                       color: isMe ? AppColors.primaryBlue : Colors.grey.shade300,
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     child: Text(
// //                       msg["text"] ?? '',
// //                       style: TextStyle(
// //                         color: isMe ? Colors.white : Colors.black,
// //                         fontSize: 16,
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //           const Divider(height: 1),
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //             color: Colors.white,
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _messageController,
// //                     decoration: const InputDecoration(
// //                       hintText: "Type a message...",
// //                       border: InputBorder.none,
// //                     ),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: const Icon(Icons.send, color: Colors.blue),
// //                   onPressed: sendMessage,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../../authpage/pages/auth_services.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController messageController = TextEditingController();
//   final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
//   final ScrollController scrollController = ScrollController();

//   bool loading = false;
//   String? message;
//   List<dynamic> chatMessages = [];
//   String? token;
//   String? userId;

//   @override
//   void initState() {
//     super.initState();
//     _initializeChat();
//   }

//   /// 🔹 Initialize: get token + user info, then fetch messages
//   Future<void> _initializeChat() async {
//     setState(() {
//       loading = true;
//       message = null;
//     });

//     try {
//       final authService = AuthService();
//       final Map<String, dynamic>? user = await authService.getUser();
//       final String? fetchedToken = await authService.getToken();

//       if (user == null || fetchedToken == null) {
//         setState(() {
//           message = "⚠️ Please login again.";
//           loading = false;
//         });
//         return;
//       }

//       setState(() {
//         userId = user['_id'] ?? '';
//         token = fetchedToken;
//       });

//       await fetchMessages();
//     } catch (e) {
//       setState(() => message = "❌ Error initializing chat: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   /// 🔹 Fetch all messages from backend
//   Future<void> fetchMessages() async {
//     setState(() {
//       loading = true;
//       message = null;
//     });

//     try {
//       final response = await dio.get(
//         "/fieldExecutive/chat/messages",
//         options: Options(
//           headers: {"Authorization": "Bearer $token"},
//         ),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           chatMessages = response.data['messages'] ?? [];
//         });

//         // Scroll to bottom
//         Future.delayed(const Duration(milliseconds: 300), () {
//           scrollController.jumpTo(scrollController.position.maxScrollExtent);
//         });
//       } else {
//         setState(() => message = "❌ Failed to fetch messages");
//       }
//     } catch (e) {
//       setState(() => message = "❌ Error fetching messages: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   /// 🔹 Send a new message
//   Future<void> sendMessage() async {
//     final content = messageController.text.trim();
//     if (content.isEmpty) return;

//     setState(() {
//       loading = true;
//       message = null;
//     });

//     try {
//       final response = await dio.post(
//         "/fieldExecutive/chat/send",
//         data: {
//           "content": content,
//           // "recipientId": null // optional if you want to broadcast
//         },
//         options: Options(
//           headers: {"Authorization": "Bearer $token"},
//         ),
//       );

//       if (response.statusCode == 201) {
//         final newMessage = response.data['data'];
//         setState(() {
//           chatMessages.add(newMessage);
//           messageController.clear();
//         });

//         // Scroll to bottom
//         Future.delayed(const Duration(milliseconds: 300), () {
//           scrollController.jumpTo(scrollController.position.maxScrollExtent);
//         });

//         setState(() => message = "✅ Message sent successfully!");
//       } else {
//         setState(() => message = "❌ Failed to send message");
//       }
//     } catch (e) {
//       setState(() => message = "❌ Error sending message: $e");
//     } finally {
//       setState(() {
//         loading = false;
//       });
//     }
//   }

//   /// 🔹 Chat bubble UI
//   Widget buildChatBubble(Map<String, dynamic> msg) {
//     final isMine = msg['senderId'] == userId;
//     final timestamp = msg['createdAt'] ?? msg['timestamp'] ?? '';

//     return Align(
//       alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isMine ? Colors.blue[100] : Colors.grey[200],
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment:
//               isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Text(
//               msg['content'] ?? '',
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               timestamp.toString().split('.')[0].replaceAll('T', ' '),
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 🔹 Main UI
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Field Executive Chat")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             if (loading) const LinearProgressIndicator(),
//             if (message != null)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   message!,
//                   style: TextStyle(
//                     color: message!.contains("❌") ? Colors.red : Colors.green,
//                   ),
//                 ),
//               ),
//             Expanded(
//               child: RefreshIndicator(
//                 onRefresh: fetchMessages,
//                 child: ListView.builder(
//                   controller: scrollController,
//                   itemCount: chatMessages.length,
//                   itemBuilder: (context, index) =>
//                       buildChatBubble(chatMessages[index]),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: const InputDecoration(
//                       hintText: "Type your message...",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: loading ? null : sendMessage,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 16),
//                   ),
//                   child: const Icon(Icons.send),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
  final TextEditingController messageController = TextEditingController();
  final TextEditingController receiverIdController = TextEditingController();

  List<dynamic> messages = [];
  bool loading = false;

  Future<void> getMessages() async {
    setState(() => loading = true);
    try {
      final authService = AuthService();
      final token = await authService.getToken();

      final response = await dio.get(
        "/fieldExecutive/chat/messages",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        setState(() => messages = response.data);
      }
    } catch (e) {
      debugPrint("Error fetching messages: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> sendMessage() async {
    final content = messageController.text.trim();
    if (content.isEmpty) return;

    try {
      final authService = AuthService();
      final token = await authService.getToken();

      await dio.post(
        "/fieldExecutive/chat/send",
        data: {
          "content": content,
          "receiverId": receiverIdController.text.trim().isEmpty
              ? null
              : receiverIdController.text.trim(),
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      messageController.clear();
      await getMessages();
    } catch (e) {
      debugPrint("Send error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return ListTile(
                        title: Text(msg['content'] ?? ''),
                        subtitle: Text(
                          "From: ${msg['senderId'] ?? 'Unknown'}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: receiverIdController,
                  decoration: const InputDecoration(
                    labelText: "Receiver ID (optional)",
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration:
                            const InputDecoration(hintText: "Type a message"),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: sendMessage,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
