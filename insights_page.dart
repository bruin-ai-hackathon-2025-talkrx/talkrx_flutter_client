import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _output;
  bool _isLoading = false;
  String? _error;

  Future<void> _analyzeText(String inputText) async {
    setState(() {
      _isLoading = true;
      _output = null;
      _error = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://172.93.55.84:8074/patient_anxiety_extractor'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "patient_id": 0,
          "conversation_input": inputText,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _output = data['output'];
        });
      } else {
        setState(() {
          _error = 'Error ${response.statusCode}: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Exception: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildList(String title, List<dynamic>? items) {
    if (items == null || items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text("• $item", style: const TextStyle(color: Colors.white70)),
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Chat Insights', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter your conversation text...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _analyzeText(_controller.text),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Analyze"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.red))
                  : _error != null
                      ? Text(_error!, style: const TextStyle(color: Colors.redAccent))
                      : _output == null
                          ? const Text("No insights yet", style: TextStyle(color: Colors.white))
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_output?['anxiety_disorder_name'] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: Text(
                                        "Disorder: ${_output!['anxiety_disorder_name']}",
                                        style: const TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                    ),
                                  _buildList("Emotions", _output?['emotions']),
                                  _buildList("Problems Identified", _output?['problems']),
                                  _buildList("Problem Evidence", _output?['problem_evidence']),
                                  _buildList("Recommendations", _output?['recommendations']),
                                ],
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
