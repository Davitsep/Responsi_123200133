import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'detail_meal.dart';

class MealList extends StatefulWidget {
  final String meals;

  const MealList({super.key, required this.meals});
  @override
  _MealList createState() => _MealList();
}

class _MealList extends State<MealList> {
  // Ganti dengan token API Anda
  List<dynamic> _meals = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.meals.toLowerCase()}",
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        _meals = json.decode(response.body)['meals'];
      });
    } else {
      throw Exception('Gagal mengambil data dari API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meals + ' Meal'),
      ),
      body: ListView.builder(
        itemCount: _meals.length,
        itemBuilder: (BuildContext context, int index) {
          final category = _meals[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FoodDetailPage(
                            foodId: category['idMeal'],
                          )));
            },
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(category['strMealThumb'].toString()),
                ),
                title: Text(category['strMeal'].toString()),
              ),
            ),
          );
        },
      ),
    );
  }
}
