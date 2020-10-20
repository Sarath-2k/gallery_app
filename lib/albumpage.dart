import 'package:flutter/material.dart';
import 'package:gallery_app/viewer.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:gallery_app/main.dart';

class AlbumPage extends StatefulWidget {
  final Album album;

  AlbumPage(Album album) : album = album;

  @override
  State<StatefulWidget> createState() => AlbumPageState();
}

class AlbumPageState extends State<AlbumPage> {
  List<Medium> _media;
  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    MediaPage mediaPage = await widget.album.listMedia();
    setState(() {
      _media = mediaPage.items;
      imagemedium = mediaPage.items;
    });
    for (int i = 0; i < _media.length; i++) {
      if (_media[i].id != null) {
        allphotos.add(_media[i].id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              for (int i = 0; i < isLockedlist.length; i++) {
                if (isLockedlist[i].key == widget.album.name) {
                  if (isLockedlist[i].locked == true) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                  }
                }
              }
            }),
        title: Text(widget.album.name),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
        children: <Widget>[
          ...?_media?.map(
            (medium) => GestureDetector(
              onTap: () {
                print(medium);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewerPage(medium)));
              },
              child: Container(
                color: Colors.grey[300],
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: MemoryImage(kTransparentImage),
                  image: ThumbnailProvider(
                    mediumId: medium.id,
                    mediumType: medium.mediumType,
                    highQuality: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<String> allphotos = [];
String albumfirst;
String albumlast;
