import 'dart:convert';
import 'package:http/http.dart' as http;

class AnxietyService {
  static const String _baseUrl = 'http://172.93.55.84:8073/openai/invoke'; 

  static Future<Map<String, dynamic>> getAnxietyExtraction(String inputText) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "input": inputText,
        "config": {},
        "kwargs": {}
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        "response": data['output'] ?? "No response received"
      };
    } else {
      throw Exception('Failed to fetch response: ${response.body}');
    }
  }
}
