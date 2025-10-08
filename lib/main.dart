import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ganjoor Reader',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('شعرهای فارسی')),
      body: Center(
        child: ElevatedButton(
          child: Text('خواندن شعر'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PoemPage()),
            );
          },
        ),
      ),
    );
  }
}

class PoemPage extends StatefulWidget {
  @override
  _PoemPageState createState() => _PoemPageState();
}

class _PoemPageState extends State<PoemPage> {
  String poemText = 'در حال بارگذاری...';
  
  @override
  void initState() {
    super.initState();
    fetchPoem();
  }
  
  Future<void> fetchPoem() async {
    try {
      var response = await http.get(Uri.parse('https://ganjoor.net/hafez/ghazal/sh1'));
      var document = parse(response.body);
      var poem = document.querySelector('.poem')?.text ?? 'شعر یافت نشد';
      setState(() {
        poemText = poem;
      });
    } catch (e) {
      setState(() {
        poemText = 'خطا در بارگذاری';
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('شعر')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade200, Colors.blue.shade200],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Text(
              poemText,
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
      ),
    );
  }
}