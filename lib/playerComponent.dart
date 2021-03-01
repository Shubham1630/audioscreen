import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PlayerCompomemt extends StatefulWidget {

  @override
  _PlayerCompomemtState createState() => _PlayerCompomemtState();
}

class _PlayerCompomemtState extends State<PlayerCompomemt> {
  AudioPlayer audioPlayer = AudioPlayer();

  bool isPlaying = false;
  bool complete = false;
  int currentSection = 0;
  Duration duration ;
  Duration position;
  bool firstLoad = true;
  bool requiresSeek = false;
  Duration seekTo;

  StreamSubscription durationSubscription;
  StreamSubscription positionSubscription;
  StreamSubscription completionSubscription;
  StreamSubscription stateSubscription;
  StreamSubscription errorSubscription;

  SharedPreferences preferences;

  @override
  void initState() {
    super.initState();

    errorSubscription = audioPlayer.onPlayerError.listen(print);

    stateSubscription =
        audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) {
          setState(() {
            isPlaying = state == AudioPlayerState.PLAYING;
          });

          print(state);
        });

    durationSubscription = audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
      });

      seekToSaved();
      seekIfRequired();
    });

    completionSubscription = audioPlayer.onPlayerCompletion.listen((e) {
      if (currentSection + 1 == 5) {
        audioPlayer.stop();
        setState(() {
          complete = true;
        });
      } else {
        audioPlayer.stop();
        setState(() {
          currentSection++;
        });

        play();
      }
    });

    positionSubscription =
        audioPlayer.onAudioPositionChanged.listen((Duration p) {
          setState(() {
            position = p;
          });

          updateSharedPrefs();

          if (firstLoad) {
            setState(() {
              firstLoad = false;
            });
          }
        });

    initPrefs();
  }

  seekIfRequired() {
    if (requiresSeek) {
      print(seekTo.toString());
      audioPlayer.seek(seekTo);

      setState(() {
        requiresSeek = false;
      });
    }
  }

  play() async {
    await audioPlayer.play("http://ia800504.us.archive.org/26/items/canterburytales_librivox/canterburytales_01_chaucer.mp3");
  }

  seekToSaved() {
    if (firstLoad) {
      List<String> data = preferences.getStringList("savedData");

      if (data != null) {
        audioPlayer.seek(
          Duration(
            seconds: int.parse(data[1]),
            minutes: int.parse(data[2]),
            hours: int.parse(data[3]),
          ),
        );
      }
    }
  }

  initPrefs() async {
    preferences = await SharedPreferences.getInstance();

    List<String> data = preferences.getStringList("savedData");

    if (data != null) {
      setState(() {
        currentSection = int.parse(data[0]);
      });
    }

    play();
  }

  updateSharedPrefs() async {
    if (duration != null && position != null) {
      await preferences.setStringList("savedData", [
        currentSection.toString(),
        position.inSeconds.toString(),
        position.inMinutes.toString(),
        position.inHours.toString(),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AudioBook"),),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl:
                    "https://upload.wikimedia.org/wikipedia/commons/5/5d/Matamoros004.JPG",
                    height: 350,
                    width: 320,
                    placeholder: (context, url) =>
                        CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              position != null && duration !=null?
              Flexible(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Slider(
                      onChanged: (val) => audioPlayer.seek(
                        Duration(
                            milliseconds:
                            (val * duration.inMilliseconds)
                                .round()),
                      ),
                      value: position.inMilliseconds /
                          duration.inMilliseconds,
                      activeColor: Colors.blueAccent,
                      inactiveColor: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            position.toString().substring(0,
                                position.toString().length - 7),
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 14.0,
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            duration.toString().substring(0,
                                duration.toString().length - 7),
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24,),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_left ,size: 34 ,),
                            onPressed: currentSection == 0
                                ? null
                                : () {
                              setState(() {
                                currentSection--;
                              });

                              play();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.rotate_left,size: 30,),
                            onPressed: () => audioPlayer.seek(
                              Duration(
                                milliseconds: (position
                                    .inMilliseconds <
                                    (5 * 1000)
                                    ? 0
                                    : position.inMilliseconds -
                                    (5 * 1000)),
                              ),
                            ),
                          ),
                          AnimatedCrossFade(
                            crossFadeState: isPlaying
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: Duration(milliseconds: 150),
                            firstChild: IconButton(
                              icon: Icon(Icons.play_arrow , size: 34
                                ,),
                              onPressed: () =>
                                  audioPlayer.resume(),
                            ),
                            secondChild: IconButton(
                              icon: Icon(Icons.pause ,size: 34,),
                              onPressed: () =>
                                  audioPlayer.pause(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.rotate_right,size: 30 ,),
                            onPressed: () => audioPlayer.seek(
                              Duration(
                                milliseconds: (duration
                                    .inMilliseconds -
                                    position
                                        .inMilliseconds <
                                    (5 * 1000)
                                    ? duration.inMilliseconds
                                    : position.inMilliseconds +
                                    (5 * 1000)),
                              ),
                            ),
                          ),
                          IconButton(
                            icon:
                            Icon(Icons.keyboard_arrow_right,size: 34,),
                            onPressed: currentSection + 1 ==
                                5
                                ? null
                                : () {
                              setState(() {
                                currentSection++;
                              });

                              play();
                            },
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ):Center(
                child: CircularProgressIndicator(),
              ),


            ],
          ),
        ),
      ),
    );


  }

  @override
  void dispose() {
    super.dispose();

    stopPlayer();
    durationSubscription?.cancel();
    positionSubscription?.cancel();
    completionSubscription?.cancel();
    stateSubscription?.cancel();
    errorSubscription?.cancel();
  }

  stopPlayer() async {
    await audioPlayer.release();
  }
}