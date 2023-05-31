import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MealDetail extends StatefulWidget {
  final String meals;

  const MealDetail({Key? key, required this.meals}) : super(key: key);

  @override
  _MealDetailState createState() => _MealDetailState();
}

class _MealDetailState extends State<MealDetail> {
  List _meals = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.meals.toLowerCase()}",
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
        title: Text('Meal Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Category: ' + _meals['strMealThumb'].toString(),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Category: ' + _meals['strArea'].toString(),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Category: ' + _meals['strInstructions'].toString(),
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(80, 10, 80, 0),
              child: ElevatedButton(
                onPressed: () {
                  _launchInBrowser(_meals['strYoutube'].toString());
                },
                child: Text('See Details !'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
