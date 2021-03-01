import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_a/audioBookData.dart';
import 'package:flutter_a/main.dart';
import 'package:flutter_a/main.dart';
import 'package:flutter_a/playerComponent.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';


class BookItem extends StatelessWidget {
  final AudioBook audioData;
  final BuildContext context;

  
  BookItem({this.audioData,this.context});

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: () {
       Navigator.push(context, MaterialPageRoute(builder: (context)=> PlayerCompomemt() ));
      },
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 26.0),
          child: Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl:
                          audioData.imageurl,
                      height: 70.0,
                      width: 70.0,
                      placeholder: (context, url) => Container(
                        width: 70.0,
                        height: 70.0,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 70.0,
                        height: 70.0,
                        child: Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 70.0,
                    height: 70.0,
                    child: Center(
                      child: Icon(Icons.play_circle_outline),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 128,
                        child: Text(
                          audioData.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    audioData.language,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    "Length - ${audioData.length}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
