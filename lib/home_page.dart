import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List itemGetter = <dynamic>[];

  Future<void> getData() async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.get(uri);
    final json = jsonDecode(response.body) as List;

    setState(() {
      itemGetter = json;
    });
  }

  Future <void> deleteData(String id) async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');
    final response = await http.delete(uri);
    print(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View To Do'),
        ),
        body: ListView.builder(
            itemCount: itemGetter.length,
            itemBuilder: (context, index) {
              final valueGetter = itemGetter[index] as Map;
              final id = valueGetter['id'].toString();
              final nameGetter = valueGetter['title'] as String;
              final bodyGetter = valueGetter['body'] as String;
              return Dismissible(
                direction: DismissDirection.endToStart,
                key: UniqueKey(),
                onDismissed: (direction) {
                  setState((){
                    itemGetter.removeAt(index);
                    deleteData(id);
                  });
                },
                child: ListTile(
                  title: Text(nameGetter),
                  subtitle: Text(bodyGetter),
                ),
              );
            }
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          getData();
        },
        child: const Icon(Icons.refresh_rounded),
        ),
    );
  }
}
