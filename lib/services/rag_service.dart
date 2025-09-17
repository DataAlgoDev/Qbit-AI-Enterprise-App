import 'dart:convert';
import 'package:http/http.dart' as http;

class RagService {
  static const String baseUrl = 'http://localhost:8080';
  
  // Chat with RAG backend
  static Future<Map<String, dynamic>> sendMessage(String message, {String? conversationId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': message,
          if (conversationId != null) 'conversation_id': conversationId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Check backend health
  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get knowledge base info
  static Future<Map<String, dynamic>> getKnowledgeBaseInfo() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/knowledge'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get knowledge base info');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Generate AI-powered newsletters
  static Future<List<Map<String, dynamic>>> generateNewsletters({int count = 2}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/newsletters'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'count': count,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newsletters = data['newsletters'] as List;
        return newsletters.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to generate newsletters: ${response.statusCode}');
      }
    } catch (e) {
      // Return fallback newsletters if backend fails
      return [
        {
          'title': 'AI & Software Engineering Update',
          'description': 'Latest developments in AI and modern software practices.',
          'category': 'AI & Software Engineering'
        },
        {
          'title': 'Electronics & DFT Innovations',
          'description': 'Hardware design trends and Design for Testability advances.',
          'category': 'Electronics & DFT'
        }
      ];
    }
  }
}
