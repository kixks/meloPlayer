import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:url_launcher/url_launcher.dart';

class SearchSongs extends StatefulWidget {
  const SearchSongs({super.key});

  @override
  State<SearchSongs> createState() => _SearchSongsState();
}

class _SearchSongsState extends State<SearchSongs> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    setState(() {});
  }

  void _startListening() async {
    await _speech.listen(
      onResult: (val) {
        setState(() {
          _lastWords = val.recognizedWords;
        });
      },
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {});
  }

  void _launchYoutubeSearch(String query) async {
    query = query.replaceAll(' ', '+'); // Replace spaces in query with '+'

    String youtubeUrl = 'https://www.youtube.com/results?search_query=$query';

    if (await canLaunch(youtubeUrl)) {
      await launch(youtubeUrl);
    } else {
      throw 'Could not launch $youtubeUrl';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(236, 227, 206, 1.0),
      appBar: AppBar(
        toolbarHeight: 75,
        title: Text('Find Your Music', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Color.fromRGBO(115, 144, 114, 1.0),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              //Results here
              Container(
                padding: EdgeInsets.all(20),
                  child: Text('Sing Your Thoughts Aloud!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),)),
              //Text here
              SizedBox(height: 40,),
              Container(
                padding: EdgeInsets.fromLTRB(15,15,15,0),
                child: Text(_lastWords, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              ),

             Container(
               margin: EdgeInsets.only(top: 30),
               child: ElevatedButton(
                 style: ElevatedButton.styleFrom(
                   padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                   backgroundColor: Color.fromRGBO(70, 100, 80, 1.0),),
                   onPressed: (){
                     _stopListening();
                     _launchYoutubeSearch(_lastWords);
                   },
                   child: Text('Find Your Song', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(236, 227, 206, 1.0),),)),)
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _speech.isListening,
        glowRadiusFactor: 5.0,
        glowColor: Colors.white,
        duration: const Duration(milliseconds: 2000),
        startDelay: const Duration(milliseconds: 100),

        child: CircleAvatar(
          backgroundColor: Color.fromRGBO(150, 190, 130, 1.0),
          radius: 40,
          child: FloatingActionButton(
            backgroundColor: Color.fromRGBO(150, 190, 130, 1.0),
              onPressed:  _speech.isNotListening ? _startListening : _stopListening,
              tooltip: 'Listen',
              child: Icon(_speech.isNotListening ? Icons.mic_off : Icons.mic, size: 55),
              ),
        ),
      ),
    );
  }
}
