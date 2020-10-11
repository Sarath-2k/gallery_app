import 'package:flutter/material.dart';
import 'package:gallery_app/lock.dart';
import 'package:gallery_app/lockscreen.dart';
import 'package:photo_gallery/photo_gallery.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    PhotoGallery.listAlbums(mediumType: MediumType.image).then((value) {
      value.forEach((element) {
        isLockedlist.add(IsLocked(key: element.name, locked: false));
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: StartingScreen(),
    );
  }
}

List<Album> album_global;

class IsLocked {
  String key;
  bool locked;
  IsLocked({this.key, this.locked});
}

List<IsLocked> isLockedlist = [];

bool appLock = false;

StartingScreen() {
  if (appLock == true) {
    return LockScreen();
  } else {
    return Home();
  }
}

String applockpass = "1234";
