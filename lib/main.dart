import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_screen_lock/lock_screen.dart';
import 'package:gallery_app/lockscreen.dart';
import 'package:gallery_app/start.dart';
import 'package:local_auth/local_auth.dart';
import 'package:photo_gallery/photo_gallery.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

// void main() {
//   runApp(AppLock(
//     builder: (args) => MyApp(
//     ),
//     lockScreen: Lock,
//     enabled: appLock,
//     backgroundLockLatency: const Duration(seconds: 30),
//   ));
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
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
      home: Home(),
    );
  }
  buildShowLockScreen(BuildContext context) async {
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
  }
}

List<Album> album_global;

class IsLocked {
  String key;
  bool locked;
  IsLocked({this.key, this.locked});
}

List<IsLocked> isLockedlist = [];

bool appLock = true;

StartingScreen() {
  if (appLock == true) {
    return LockScreen();
  } else {
    return Home();
  }
}

String applockpass = "1234";
