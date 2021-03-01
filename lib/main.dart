import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_a/audioBookData.dart';
import 'package:flutter_a/bookItem.dart';
import 'package:flutter_a/playerComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  List<AudioBook> audioBook = AudioBook.getList();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        // bottomNavigationBar: BottomNavigationBar(items: [BottomNavigationBarItem(icon: Icon(Icons.list),backgroundColor: Colors.pink,label: "list"),
        // BottomNavigationBarItem(icon: Icon(Icons.play_arrow),backgroundColor: Colors.pink,label: "play")
        // ],
        //   fixedColor: Colors.black87,
        //
        // ),
        appBar: AppBar(title: Text("AudioBook"),backgroundColor: Colors.black87 , centerTitle: true,),
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder
                (
                  itemCount: audioBook.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new BookItem(audioData: audioBook[index],context: context,);
                  }
              ),
            ),
          ),
        )
      )
    );
  }
}


