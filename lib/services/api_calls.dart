import 'dart:convert';

import 'package:http/http.dart' as http;

import '../consts/uri.dart';

class ApiCalls {
  static Future<List?> getTask() async {
    final uri = Uri.https(BASE_URL, 'v1/todos', {
      "page": "1",
      "limit": "10",
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      Map jsonData = jsonDecode(response.body);
      List result = jsonData["items"];
      return result;
    }
    return null;
  }

  static Future<bool> deleteTaskbyId(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    return response.statusCode == 200;
  }

  static Future<bool> createTask(Map body) async {
    // Submit data to the server
    final uri = Uri.https(BASE_URL, 'v1/todos');
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        "Content-Type": 'application/json',
        'accept': 'application/json'
      },
    );
    return response.statusCode == 201;
  }

  static Future<bool> updateTask(String id, Map body) async {
    // Submit data to the server
    final uri = Uri.parse("https://api.nstack.in/v1/todos/$id");
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        "Content-Type": 'application/json',
        'accept': 'application/json'
      },
    );
    return response.statusCode == 200;
  }
}
