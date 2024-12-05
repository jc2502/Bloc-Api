import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiRepository {
  final String _baseUrl = "https://674869495801f5153590c2a3.mockapi.io/api/v1/pokemon";

  Future<List<dynamic>> fetchActions() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load actions');
    }
  }

  Future<void> deleteAction(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete action');
    }
  }

  Future<void> createAction(Map<String, dynamic> newAction) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(newAction),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create action');
    }
  }

  Future<void> editAction(String id, Map<String, dynamic> updatedAction) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updatedAction),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update action');
    }
  }
}
