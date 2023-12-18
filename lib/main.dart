import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:melo_player/mainpages/homepage.dart';
import 'package:melo_player/mainpages/search_songs.dart';
import 'firebase_options.dart';
import 'loginregisterpages/authpage.dart';
import 'loginregisterpages/login_page.dart';
import 'loginregisterpages/register_page.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future <void> main()   async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      routes: {
        '/registerpage': (context) => RegisterPage(),
        '/loginpage': (context) => LoginPage(),
        '/speechsearchsongs' : (context) => SearchSongs(),
        '/homepage' : (context) => HomePage(),
      },
    );
  }
}
