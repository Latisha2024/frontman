import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-1.onrender.com"));
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
