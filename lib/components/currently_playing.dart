import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../globals.dart';

class CurrentlyPlaying extends StatefulWidget {
  const CurrentlyPlaying({super.key});

  @override
  State<CurrentlyPlaying> createState() => _FloatingCurrentSongState();
}

class _FloatingCurrentSongState extends State<CurrentlyPlaying> with SingleTickerProviderStateMixin{
  late final AnimationController _animationController =
  AnimationController(vsync: this, duration: const Duration(seconds: 3));


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      height: screenSize.height/9,
      margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(115, 144, 114, 20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (_,child){
                if(!globalIsPlaying){
                  _animationController.stop();
                }else{
                  _animationController.forward();
                  _animationController.repeat();
                }
                return Transform.rotate(
                    angle: _animationController.value * 2 * math.pi,
                    child: child);
              },
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Color.fromRGBO(236, 227, 206, 90),
                child: CircleAvatar(
                  radius: 27,
                  backgroundImage: AssetImage('asset/images/MorningCoffee.jpg'),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(globalSong!.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                Text(globalSong!.artist!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),)
              ],
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: (){setState(() {
                if(globalIsPlaying){
                  globalAudioPlayer.pause();
                }else{
                  globalAudioPlayer.play();
                }
                globalIsPlaying = !globalIsPlaying;
              });},
              icon: Icon(globalIsPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.white70,
                  size: 50),
            ),
          ),
        ],
      ),
    );
  }
}
