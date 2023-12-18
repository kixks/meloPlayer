import 'package:flutter/material.dart';
import 'package:melo_player/components/my_textboxes.dart';
import 'package:melo_player/components/neu_box.dart';
import 'package:melo_player/mainpages/playlist.dart';
import 'package:melo_player/mainpages/song_playing.dart';
import '../components/currently_playing.dart';
import '../components/mydrawer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../components/play_list_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:melo_player/globals.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final playlistTitleController = TextEditingController();
  late List<SongModel> allSongs;

  @override
  void initState() {
    super.initState();
  }

  void requestPermission() {
    Permission.storage.request();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(236, 227, 206, 1.0),
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Color.fromRGBO(115, 144, 114, 1.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Library',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/speechsearchsongs');
              },
              icon: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(115, 144, 114, 1.0),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(70, 100, 80, 1.0),
                        blurRadius: 15,
                        offset: Offset(5, 5),
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(150, 190, 130, 1.0),
                        blurRadius: 10,
                        offset: Offset(-4, -4),
                      ),
                    ]),
                child: Icon(
                  Icons.settings_voice_rounded,
                  size: 30,
                  color: Color.fromRGBO(58, 77, 57, 1.0),
                ),
              ),
            )
          ],
        ),
      ),
      drawer: MyDrawer(),
      body: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Container(
                padding: EdgeInsets.fromLTRB(25, 20, 0, 15),
                child: Text(
                  'Playlists',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 25),
                child: IconButton(
                    onPressed: (){
                      _showModalBottomPlaylist(context);
                    },
                    icon: Icon(Icons.add, size: 40,)),
              )
            ]
            ),
            Container(
              height: 205,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  PlayListList(
                      playlistTitle: 'Chiill Lungs',
                      imageAsset: 'asset/images/MorningCoffee.jpg'),
                  PlayListList(
                      playlistTitle: 'Cant Feel',
                      imageAsset: 'asset/images/eccentricKollector.jpg'),
                  PlayListList(
                      playlistTitle: 'Acoustics',
                      imageAsset: 'asset/images/acoustics.jpg'),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 20, 25, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Song List',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(236, 227, 206, 1.0),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(190, 190, 180, 1.0),
                            blurRadius: 15,
                            offset: Offset(5, 5),
                          ),
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 10,
                            offset: Offset(-4, -4),
                          ),
                        ]),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Favourites',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(58, 77, 57, 1.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<SongModel>>(
                future: getDeviceSongs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No Songs Found'));
                  } else {
                    final songs = snapshot.data!;
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(236, 227, 206, 1.0),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(190, 190, 180, 1.0),
                                blurRadius: 15,
                                offset: Offset(5, 5),
                              ),
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 10,
                                offset: Offset(-4, -4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            title: Text(
                              song.title ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(58, 77, 57, 1.0),
                              ),
                            ),
                            subtitle: Text(song.artist == "<unknown>"
                                ? "Unknown Artist"
                                : song.artist!),
                            leading: Icon(
                              Icons.music_note,
                              size: 30,
                              color: Color.fromRGBO(58, 77, 57, 1.0),
                            ),
                            trailing: IconButton(
                              onPressed: (){_showModalBottomSong(context);},
                              icon: Icon(
                                Icons.more_vert,
                                color: Color.fromRGBO(58, 77, 57, 1.0),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SongPlaying(
                                    allSongs: songs,
                                  ),
                                ),
                              );
                              setState(() {
                                allSongs = songs;
                                globalSong = song;
                              });
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ]),
      floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SongPlaying(
                  allSongs: allSongs,
                ),
              ),
            ).then((result) {
              if (result != null) {
                // Pass the updated currentSong as the result
                Navigator.pop(context, result);
              }
            });
          },
          child: globalSong != null
              ? CurrentlyPlaying()
              : SizedBox()),
    );
  }

  Future<List<SongModel>> getDeviceSongs() async {
    List<SongModel> allSongs = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    // Filter only MP3 files
    List<SongModel> mp3Songs = allSongs.where((song) {
      bool hasRecording = song.displayName.toLowerCase().contains('recording');
      return !hasRecording && song.size >= 1 * 1024 * 1024;
    }).toList();

    return mp3Songs;
  }
  void _showModalBottomSong(BuildContext context){
    showModalBottomSheet(context: context, builder:(BuildContext context){
      return Container(
        color: Color.fromRGBO(236, 227, 206, 1.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 15),
            GestureDetector(
              child: NeuBox(
                padds: 15,
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Queue Song', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      Icon(Icons.queue_play_next),
                    ],
                  ),),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: NeuBox(
                padds: 15,
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sleep Timer',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      Icon(Icons.access_time_outlined)
                    ],
                  ),),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: NeuBox(
                padds: 15,
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delete Song',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      Icon(Icons.delete_outline)
                    ],
                  ),),
              ),
            ),
          ],
        ),
      );
    }
    );
  }

  void _showModalBottomPlaylist(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return KeyboardDismisser(
          child: SingleChildScrollView(
            child: Container(
              color: Color.fromRGBO(28, 103, 86, 1.0),
              padding: EdgeInsets.fromLTRB(0,20,0,MediaQuery.of(context).viewInsets.bottom,),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyTextBoxes(iconIn: Icons.create, name: 'Enter Playlist Name', controller: playlistTitleController, obscureText: false),

                  SizedBox(height: 20),

                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Color.fromRGBO(61, 131, 97,1.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayList(
                              playListName: playlistTitleController.toString(),
                            ),
                          ),
                        );
                      },
                      child: Text('Create Playlist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color.fromRGBO(236, 227, 206, 1.0),),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
