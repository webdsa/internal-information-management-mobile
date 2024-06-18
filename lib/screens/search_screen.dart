import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove o botão de voltar padrão
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: TextStyle(color: Colors.white, fontSize: 16.0),
          cursorColor: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Search results or suggestions go here'),
      ),
    );
  }
}
