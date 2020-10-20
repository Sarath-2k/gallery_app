import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_app/albumpage.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class ViewerPage extends StatefulWidget {
  final Medium medium;
  ViewerPage(Medium medium) : medium = medium;

  @override
  _ViewerPageState createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  PhotoProvider pic;
  @override
  void initState() {
    pic = PhotoProvider(mediumId: widget.medium.id);
    for (int i = 0; i < allphotos.length; i++) {
      if (widget.medium.id == allphotos[i]) {
        current = i;
      }
    }
    widget.medium.getFile().then((value) => {path = value.path.toString()});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = widget.medium.creationDate ?? widget.medium.modifiedDate;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                File file = await widget.medium.getFile();
                Uint8List imagebytes = await file.readAsBytes().then((value) {
                  Share.file('image', 'image.jpg', value, 'image/jpg',
                      text: 'My optional text.');
                });
              },
            )
          ],
        ),
        body: SwipeDetector(
          onSwipeLeft: () {
            setState(() {
              pathget();
              if (current != allphotos.length - 1) {
                pic = PhotoProvider(mediumId: allphotos[current + 1]);
                current = current + 1;
                pathget();
              } else {
                pic = PhotoProvider(mediumId: allphotos[0]);
                current = 0;
                pathget();
              }
            });
          },
          onSwipeRight: () {
            setState(() {
              pathget();
              if (current != 0) {
                pic = PhotoProvider(mediumId: allphotos[current - 1]);
                current = current - 1;
                pathget();
              } else {
                pic = PhotoProvider(mediumId: allphotos[allphotos.length - 1]);
                current = allphotos.length - 1;
                pathget();
              }
            });
          },
          child: Container(
            alignment: Alignment.center,
            child: widget.medium.mediumType == MediumType.image
                ? FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: MemoryImage(kTransparentImage),
                    image: pic,
                  )
                : VideoProvider(
                    mediumId: widget.medium.id,
                  ),
          ),
        ),
        floatingActionButton: SpeedDial(
            marginRight: 18,
            marginBottom: 20,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            visible: true,
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 8.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                  child: Icon(Icons.wallpaper),
                  backgroundColor: Colors.red,
                  label: "Set as Wallpaper",
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  labelBackgroundColor: Colors.black45,
                  onTap: () {
                    WallpaperManager.setWallpaperFromFile(
                        path, WallpaperManager.HOME_SCREEN);
                  }),
              SpeedDialChild(
                child: Icon(Icons.lock),
                backgroundColor: Colors.green,
                label: "Set as LockScreen",
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                labelBackgroundColor: Colors.black45,
                onTap: () {
                  WallpaperManager.setWallpaperFromFile(
                      path, WallpaperManager.LOCK_SCREEN);
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.panorama),
                backgroundColor: Colors.blue,
                label: "BOTH",
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                labelBackgroundColor: Colors.black45,
                onTap: () {
                  WallpaperManager.setWallpaperFromFile(
                      path, WallpaperManager.BOTH_SCREENS);
                },
              ),
            ]));
  }

  pathget() {
    medlist[current].getFile().then((value) => {path = value.path.toString()});
  }
}

class VideoProvider extends StatefulWidget {
  final String mediumId;

  const VideoProvider({
    @required this.mediumId,
  });

  @override
  _VideoProviderState createState() => _VideoProviderState();
}

class _VideoProviderState extends State<VideoProvider> {
  VideoPlayerController _controller;
  File _file;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAsync();
    });
    super.initState();
  }

  Future<void> initAsync() async {
    try {
      _file = await PhotoGallery.getFile(mediumId: widget.mediumId);
      _controller = VideoPlayerController.file(_file);
      _controller.initialize().then((_) {
        setState(() {});
      });
    } catch (e) {
      print("Failed : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller == null || !_controller.value.initialized
        ? Container()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
            ],
          );
  }
}

int current;

String path = "";
