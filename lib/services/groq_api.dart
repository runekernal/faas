import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

const _model = "llama3-8b-8192";

Future<String> getResponse(String mode, String style, String objectName) async {
  final apiKey = dotenv.env['GROQ_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    throw Exception("Missing GROQ_API_KEY in environment.");
  }

  final uri = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

  final styles = {
    "Baby": "You are a baby trying to say something important. Use baby talk, make it super cute, and very short. Just a few silly words or gibberish, like 'sowwy widdle chairy!'",
    "Corporate": "You are a corporate professional writing a formal, buzzword-filled message. Use professional tone, vague language, and keep it concise but diplomatically cold. This is not a mail just a paragraph. It should be very short.",
    "Shakespearean": "You are a dramatic poet from the Elizabethan era. Write in old English, using 'thou,' 'thy,' and excessive drama. Make it poetic and absurd. it should be very short.",
    "Normal": "You are a kind and straightforward person. Write a simple and sincere message in under 40 words. Keep it human, neutral, and warm.",
    "Sarcastic": "You are a sarcastic genius with zero patience. Keep it snappy, mean, and full of eye-roll energy. No more than 30 words.",
    "Emotional": "You are extremely emotional and exaggerate everything. Make the message sound like it's the end of the world. Very Short, dramatic, and extra.",
  };

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final prompt = (mode == "apology")
      ? "Create an apology to a(n) $objectName"
      : "Create a complaint pretending to be a(n) $objectName";
  
  final random = Random();

  final body = jsonEncode({
    "model": _model,
    "messages": [
      {"role": "system", "content": styles[style] ?? styles.keys.elementAt(random.nextInt(styles.keys.length))},
      {"role": "user", "content": prompt},
    ],
    "temperature": 0.9,
  });

  final response = await http.post(uri, headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'].trim();
  } else {
    print('Error: ${response.statusCode} - ${response.body}');
    throw Exception('Failed to fetch response from Groq');
  }
}
