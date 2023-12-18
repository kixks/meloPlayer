import 'package:flutter/material.dart';
import 'package:melo_player/mainpages/song_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melo_player/globals.dart';
import '../components/currently_playing.dart';

class PlayList extends StatefulWidget {
  final String? playListName;
  final String? imageAsset;

  const PlayList({super.key, this.playListName, this.imageAsset});

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  late List<SongModel> allSongs;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  late Map<String?, List<SongModel>> playlists;

   Future<void> initializeData() async {
    List<SongModel> matchedSongs = await fetchLocalSongsMatchingIds();

    // Populate playlists with fetched data
    playlists = {widget.playListName: matchedSongs};

    setState(() {
      // Set state after fetching data to trigger a rebuild with the fetched playlists
    });
  }


  void savePlaylistToDatabase() {
    playlists.forEach((playlistName, songList) async {
      List<String> songIds = songList.map((song) => song.id.toString())
          .toList();

      await FirebaseFirestore.instance
          .collection('playlists')
          .doc(playlistName)
          .set({'songs': songIds}, SetOptions(merge: true));
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Color.fromRGBO(236, 227, 206, 1.0),
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_sharp,
                color: Color.fromRGBO(58, 77, 57, 1.0), size: 29),
          ),
          title: Text(widget.playListName!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
        ),
        body: Column(
          children: [
            Container(
              height: 300,
              width: 500,
              child: Image.asset(
                widget.imageAsset ?? 'Insert Image', fit: BoxFit.cover,),
            ),

            Container(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15, 5, 5, 0),
                  child: Text('Playlist List', style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 25,),),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 15, 0),
                  child: IconButton(
                      onPressed: () {
                        _showModalAllSongs(context);
                      },
                      icon: Icon(Icons.add_box, size: 40,
                        color: Color.fromRGBO(58, 77, 57, 1.0),)),
                ),
              ],
            ),
            ),
            Expanded(
              child: FutureBuilder<List<SongModel>>(
                future: fetchLocalSongsMatchingIds(),
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
                              onPressed: () {},
                              icon: Icon(
                                Icons.more_vert,
                                color: Color.fromRGBO(58, 77, 57, 1.0),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SongPlaying(
                                        allSongs: songs,
                                      ),
                                ),
                              );
                              setState(() {
                                globalSong = song;
                                allSongs = songs;
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
      );

  }

  void _showModalAllSongs(BuildContext context) {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return Container(
        color: Color.fromRGBO(236, 227, 206, 1.0),
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
                        onPressed: () {
                          setState(() {
                            playlists.putIfAbsent(widget.playListName, () => [])
                                .add(song);
                            savePlaylistToDatabase();
                            Navigator.pop(context);
                          });
                        },
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Color.fromRGBO(58, 77, 57, 1.0),
                        ),
                      ),
                      onTap: () {},
                    ),
                  );
                },
              );
            }
          },
        ),
      );
    }
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

    mp3Songs = mp3Songs.where((song) {
      bool isInPlaylist = playlists.values.any((playlistSongs) =>
          playlistSongs.any((playlistSong) => playlistSong.id == song.id));
      return !isInPlaylist;
    }).toList();

    return mp3Songs;
  }

  Future<List<SongModel>> fetchLocalSongsMatchingIds() async {
    List<SongModel> localSongs = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    // Fetch song IDs from Firestore
    List<String> firestoreSongIds = await fetchSongIdsFromFirestore(widget.playListName!);

    // Filter local songs based on matching IDs
    List<SongModel> matchedSongs = localSongs.where((song) => firestoreSongIds.contains(song.id.toString())).toList();

    return matchedSongs;
  }

  Future<List<String>> fetchSongIdsFromFirestore(String playlistName) async {
    List<String> songIds = [];

    DocumentSnapshot<Map<String, dynamic>> playlistSnapshot = await FirebaseFirestore.instance
        .collection('playlists')
        .doc(playlistName)
        .get();

    if (playlistSnapshot.exists) {
      List<dynamic> fetchedSongIds = playlistSnapshot.get('songs');
      songIds = List<String>.from(fetchedSongIds);
    }

    return songIds;
  }

}