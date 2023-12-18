import 'dart:ui';
import 'package:flutter/material.dart';
import '../mainpages/playlist.dart';

class PlayListList extends StatelessWidget {
  final String playlistTitle;
  final String imageAsset;
  const PlayListList({super.key, required this.playlistTitle, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayList(
              playListName: playlistTitle,
              imageAsset: imageAsset,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        width: 150,
        decoration: BoxDecoration(
            color: Color.fromRGBO(236, 227, 206, 1.0),
            borderRadius: BorderRadius.circular(20),
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
            ]
        ),
        child: Column(
          children: [
            Container(
              width: 115, height: 115,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(imageAsset),
                    fit: BoxFit.cover),
                shape: BoxShape.circle,
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(100 / 2),
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12),
                      ),
                    ),

                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(imageAsset),
                      ),
                    )
                  ],
                ),
              ),
            ),
         Container(
              padding: EdgeInsets.all(12),
              child: Text(playlistTitle,
                style: TextStyle(
                  color: Color.fromRGBO(58, 77, 57, 1.0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),),
            )
          ],
        ),
      ),
    );
  }
}