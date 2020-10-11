import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/lock_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

import 'albumpage.dart';
import 'lock.dart';
import 'main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Album> _albums;
  bool _loading = false;

  @override
  void initState() {
    _lockcheck;
    super.initState();
    _loading = true;
    initAsync();
  }

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
      List<Album> albums =
          await PhotoGallery.listAlbums(mediumType: MediumType.image);
      setState(() {
        _albums = albums;
        _loading = false;
      });
    }
    setState(() {
      _loading = false;
    });
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS &&
            await Permission.storage.request().isGranted &&
            await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.lock),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Lock()),
              );
            }),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                double gridWidth = (constraints.maxWidth - 20) / 3;
                double gridHeight = gridWidth + 33;
                double ratio = gridWidth / gridHeight;
                return Container(
                  padding: EdgeInsets.all(5),
                  child: GridView.count(
                    childAspectRatio: ratio,
                    crossAxisCount: 3,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                    children: <Widget>[
                      ...?_albums?.map(
                        (album) => GestureDetector(
                          onTap: () {
                            for (int i = 0; i < isLockedlist.length;) {
                              if (isLockedlist[i].key == album.name) {
                                if (isLockedlist[i].locked == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LockScreen()),
                                  );
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AlbumPage(album)));
                                }
                              }
                            }
                          },
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  color: Colors.grey[300],
                                  height: gridWidth,
                                  width: gridWidth,
                                  child: FadeInImage(
                                    fit: BoxFit.cover,
                                    placeholder: MemoryImage(kTransparentImage),
                                    image: AlbumThumbnailProvider(
                                      albumId: album.id,
                                      mediumType: album.mediumType,
                                      highQuality: true,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 2.0),
                                child: Text(
                                  album.name,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    height: 1.2,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 2.0),
                                child: Text(
                                  album.count.toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    height: 1.2,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
  _lockcheck(){

    if(appLock==true){
      showLockScreen(
            context: context,
            correctString: applockpass,
            showBiometricFirst: true,
            canCancel: false,
            canBiometric: true,
            biometricButton: Icon(Icons.face),
            biometricAuthenticate: (context) async {
              final localAuth = LocalAuthentication();
              final didAuthenticate =
                  await localAuth.authenticateWithBiometrics(
                      localizedReason: 'Please authenticate');

              if (didAuthenticate) {
                return true;
              }

              return false;
            },
            onUnlocked: () {
              print('Unlocked.');
            },
          );
    }else{}
  }
}
