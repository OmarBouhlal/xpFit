import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;



class ExerciceAPI {
  final String targetMuscle;

  ExerciceAPI({required this.targetMuscle});


    static Future<List<dynamic>> fetchTargets() async {
    final url = Uri.parse('https://exercisedb.p.rapidapi.com/exercises/targetList');
    final response = await http.get(url, headers: {
     'X-RapidAPI-Key': dotenv.env['RAPIDAPI_KEY'] as String,
     'X-RapidAPI-Host': dotenv.env['RAPIDAPI_HOST'] as String,
    });

    if(response.statusCode == 200){
      
      final data = jsonDecode(response.body);
      return data;
      
    }else {
      throw Exception('Failed to load targets');
    }

  }
  
  static Future<List<Map<String, dynamic>>> fetchExercises(String selectedMuscle) async {
    final url = Uri.parse('https://exercisedb.p.rapidapi.com/exercises/target/$selectedMuscle');

    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': dotenv.env['RAPIDAPI_KEY'] as String,
      'X-RapidAPI-Host': dotenv.env['RAPIDAPI_HOST'] as String,
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load exercises');
    }
  }



}