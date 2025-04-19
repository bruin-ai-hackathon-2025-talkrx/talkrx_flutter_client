import 'package:flutter/material.dart';
import 'anxiety_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // { role: user/ai, message: text }
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final userInput = _controller.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'message': userInput});
      _controller.clear();
      _isLoading = true;
    });

    try {
      final result = await AnxietyService.getAnxietyExtraction(userInput);
      print("👉 result = $result");
      print("👉 result['response'] runtimeType = ${result['response'].runtimeType}");

      
      // Use .toString() in case the value is not a string
      final aiMessage = result['response']?.toString() ?? 'No response received';

      setState(() {
        _messages.add({'role': 'ai', 'message': aiMessage});
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'ai', 'message': 'Error: $e'});
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['role'] == 'user';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.deepPurple : Colors.grey[800],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message['message'].toString(), // Always safely convert to string
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Anxiety Insights"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "AI Assistant is analyzing...",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Share your thoughts...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey[850],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.red),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
