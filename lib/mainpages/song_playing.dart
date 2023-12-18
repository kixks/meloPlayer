import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../components/neu_box.dart';
import '../globals.dart';
import 'homepage.dart';

class SongPlaying extends StatefulWidget {
  final List<SongModel>allSongs;


  const SongPlaying({super.key, required this.allSongs});

  @override
  State<SongPlaying> createState() => _SongPlayingState();
}

class _SongPlayingState extends State<SongPlaying> {

  Duration _duration = const Duration();
  Duration _position = const Duration();
  late StreamSubscription<Duration?> _durationSubscription;
  late StreamSubscription<Duration> _positionSubscription;



  late int currentIndex;
  late SongModel currentSong;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.allSongs.indexOf(globalSong!);
    currentSong = globalSong!;
    playSong();
  }


  void playSong(){
    try{
      globalAudioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(currentSong.uri!),
            tag: MediaItem(
              id: '${currentSong.id}',
              album: "${currentSong.album}",
              title: currentSong.title,
            ),
          )
      );

      globalAudioPlayer.play();
      globalIsPlaying = true;

    }on Exception{
      log("Cannot Parse Song");
    }
    _durationSubscription = globalAudioPlayer.durationStream.listen((d) {
      if(d != null){
        setState(() {
          _duration = d!;
        });
      }
    });
    _positionSubscription = globalAudioPlayer.positionStream.listen((p) {
      if(p != null){
        setState(() {
          _position = p;
        });
      }
    });
  }

  void playNextSong() {
    if (currentIndex < widget.allSongs.length - 1) {
      currentIndex++;
      globalAudioPlayer.stop(); // Stop the current song
      setState(() {
        currentSong = widget.allSongs[currentIndex];
        globalSong = widget.allSongs[currentIndex]; // Update the song
      });
      playSong(); // Play the next song
    }
  }
  void playPreviousSong() {
    if (currentIndex > 0) {
      currentIndex--;
      globalAudioPlayer.stop(); // Stop the current song
      setState(() {
        currentSong = widget.allSongs[currentIndex];
        globalSong = widget.allSongs[currentIndex]; // Update the song
      });
      playSong(); // Play the previous song
    }
  }

  @override
  void dispose() {
    // Cancel subscriptions to prevent setState after disposal
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    super.dispose();
  }

  void _navigateToHomePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );

    if (result != null) {
      if (result != null) {
        setState(() {
          // Update the currentSong and currentIndex based on the result
          currentSong = result as SongModel;
          currentIndex = widget.allSongs.indexOf(currentSong);
        });
        playSong(); // Reinitialize the audio player with the updated currentSong
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(236, 227, 206, 1.0),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_sharp,
                color: Color.fromRGBO(58, 77, 57, 1.0), size: 29),
          ),
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 50,
                width: 50,
                child: NeuBox(
                  padds: 0,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    NeuBox(
                        padds: 12,
                        child: Container(
                            height: 300,
                            width: 400,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'asset/images/MorningCoffee.jpg',
                                  fit: BoxFit.cover,
                                )))),
                    SizedBox(height: 15),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      currentSong.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(58, 77, 57, 1.0),
                                        fontSize: 28,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    currentSong.artist! == '<unknown>' ? "Unknown Artist" : globalSong!.artist!,
                                    style: TextStyle(
                                      color: Color.fromRGBO(58, 77, 57, 1.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 50, // Set a fixed width for the IconButton
                              height: 50,
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.favorite,
                                  size: 35,
                                ),
                              ),
                            ),
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          _position.toString().split(".")[0],
                          style: TextStyle(color: Color.fromRGBO(58, 77, 57, 1.0)),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.shuffle,
                            color: Color.fromRGBO(58, 77, 57, 1.0),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.repeat,
                            color: Color.fromRGBO(58, 77, 57, 1.0),
                          ),
                        ),
                        Text(
                          _duration.toString().split(".")[0],
                          style: TextStyle(color: Color.fromRGBO(58, 77, 57, 1.0)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    NeuBox(
                        padds: 0,
                        child: Slider(
                            activeColor: Color.fromRGBO(58, 77, 57, 1.0),
                            inactiveColor: Colors.green[50],
                            min: const Duration(microseconds: 0).inSeconds.toDouble(),
                            value: _position.inSeconds.toDouble(),
                            max: _duration.inSeconds.toDouble(),
                            onChanged: (value){
                              setState(() {
                                durationSlider(value.toInt());
                                value = value;
                              });
                            })
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 70,
                      child: Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  playPreviousSong();
                                },
                                child: NeuBox(
                                  padds: 12,
                                  child: Icon(
                                    Icons.skip_previous,
                                    size: 40,
                                    color: Color.fromRGBO(58, 77, 57, 1.0),
                                  ),
                                ),
                              )),
                          Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if(globalIsPlaying){
                                        globalAudioPlayer.pause();
                                      }else{
                                        globalAudioPlayer.play();
                                      }
                                      globalIsPlaying = !globalIsPlaying;
                                    });
                                  },
                                  child: NeuBox(
                                    padds: 12,
                                    child: Icon(
                                      globalIsPlaying ? Icons.pause : Icons.play_arrow,
                                      size: 40,
                                      color: Color.fromRGBO(58, 77, 57, 1.0),
                                    ),
                                  ),
                                ),
                              )),
                          Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  playNextSong();
                                },
                                child: NeuBox(
                                  padds: 12,
                                  child: Icon(
                                    Icons.skip_next,
                                    size: 40,
                                    color: Color.fromRGBO(58, 77, 57, 1.0),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
    );
  }

  void durationSlider (int seconds){
    Duration duration = Duration(seconds: seconds);
    globalAudioPlayer.seek(duration);
  }
}

