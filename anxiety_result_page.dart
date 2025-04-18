import 'package:flutter/material.dart';
import 'anxiety_service.dart';
import 'dart:convert';

class AnxietyResultPage extends StatefulWidget {
  const AnxietyResultPage({super.key});

  @override
  State<AnxietyResultPage> createState() => _AnxietyResultPageState();
}

class _AnxietyResultPageState extends State<AnxietyResultPage> {
  String _result = "Loading...";
  
  @override
  void initState() {
    super.initState();
    _fetchAnxietyData();
  }

  Future<void> _fetchAnxietyData() async {
    try {
      final result = await AnxietyService.getAnxietyExtraction(
        "Patient is reporting symptoms of anxiety and trouble sleeping."
      );

      setState(() {
        _result = JsonEncoder.withIndent('  ').convert(result);
      });
    } catch (e) {
      setState(() {
        _result = "Error fetching anxiety data: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Anxiety Analysis")),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            _result,
            style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
          ),
        ),
      ),
    );
  }
}
