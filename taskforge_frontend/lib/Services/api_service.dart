import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://taskforge-backend-y3te.onrender.com';
  // Get Projects
  static Future<List<dynamic>> getProjects() async {
    final response = await http.get(Uri.parse('$baseUrl/projects'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load projects: ${response.statusCode}');
    }
  }

  // Get Tasks
  static Future<List<dynamic>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load tasks: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> createTask(
    Map<String, dynamic> task,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create task: ${response.statusCode}');
    }
  }
}
