

import 'package:flutter/cupertino.dart';

class AudioBook {
  
  String name;
  String imageurl;
  String language;
  String length;
  String url;

  AudioBook(
      this.name, this.imageurl, this.language, this.length, this.url);

 static getList(){
    List<AudioBook> audioBookList =[
      AudioBook("Beauty and the Monster","https://upload.wikimedia.org/wikipedia/commons/5/5d/Matamoros004.JPG", "English", "00.00", "http://ia800504.us.archive.org/26/items/canterburytales_librivox/canterburytales_01_chaucer.mp3"),
      AudioBook("Gods of the North","https://upload.wikimedia.org/wikipedia/commons/5/5d/Matamoros004.JPG", "English", "00.00", "http://ia800504.us.archive.org/26/items/canterburytales_librivox/canterburytales_01_chaucer.mp3"),
      AudioBook("Sonnet 130","https://upload.wikimedia.org/wikipedia/commons/5/5d/Matamoros004.JPG", "English", "00.00", "http://ia800504.us.archive.org/26/items/canterburytales_librivox/canterburytales_01_chaucer.mp3"),
      AudioBook("Shakespeare's Sonnets","https://upload.wikimedia.org/wikipedia/commons/5/5d/Matamoros004.JPG", "English", "00.00", "http://ia800504.us.archive.org/26/items/canterburytales_librivox/canterburytales_01_chaucer.mp3"),
    ];
    return audioBookList;

  }
}

