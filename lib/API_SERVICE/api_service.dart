import 'dart:convert';

import 'package:anime/UI/model_animal.dart';
import 'package:http/http.dart' as http;

class Network {
  static Future<List<Animal>> getData() async {
    var response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/animals'));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((animal) => Animal.fromJson(animal)).toList();
    } else {
      throw Exception("Somrthing wrong happened");
    }
  }

  static Future<http.Response> createPost(
      String name, String about, String image) async {
    if (name != '' || about != '' || image != '') {
      var response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/v1/animals/create'),
          headers: <String, String>{
            'Content-Type': "application/json; charset=UTF-8"
          },
          body: jsonEncode(<String, dynamic>{
            "Name": name,
            "about": about,
            "image": image,
          }));
      return response;
    } else {
      throw Exception("Something wrong happened");
    }
  }

  static Future<http.Response> deletePost(String id) async {
    var response = await http
        .delete(Uri.parse('http://127.0.0.1:8000/api/v1/animals/delete/$id'));
    return response;
  }

  static Future<http.Response> updatePost(
      String id, String name, String about, String image) async {
    try {
      var response = await http.put(
          Uri.parse('http://127.0.0.1:8000/api/v1/animals/update/$id'),
          headers: <String, String>{
            'Content-Type': "application/json; charset=UTF-8"
          },
          body: jsonEncode(<String, dynamic>{
            "Name": name,
            "about": about,
            "image": image,
          }));
      return response;
    } catch (e) {
      throw Exception("Something wrong happenned");
    }
  }
}
