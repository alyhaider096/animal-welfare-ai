import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = "PASTE_YOUR_OPENAI_API_KEY_HERE";

  Future<String> askPetCareAI(String userMessage) async {
    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Authorization": "Bearer $_apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "system",
            "content":
            "You are an animal welfare assistant. Give safe, NGO-approved, non-medical advice for animals."
          },
          {
            "role": "user",
            "content": userMessage
          }
        ],
        "temperature": 0.4
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      throw Exception("AI error: ${response.body}");
    }
  }
}
