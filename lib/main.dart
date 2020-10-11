import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/lock_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class LockCheck extends StatefulWidget {
  @override
  _LockCheckState createState() => _LockCheckState();
}

class _LockCheckState extends State<LockCheck> {
  bool islockedtemp = true;

  lockScreenfn(BuildContext context) {
    if (appLock == true) {
      showLockScreen(
        context: context,
        correctString: applockpass,
        canBiometric: true,
        showBiometricFirst: true,
        biometricAuthenticate: (_) async {
          final localAuth = LocalAuthentication();
          final didAuthenticate = await localAuth.authenticateWithBiometrics(
              localizedReason: 'Please authenticate');

          if (didAuthenticate) {
            return true;
          }

          return false;
        },
        onUnlocked: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) => lockScreenfn(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // body: RaisedButton(onPressed: () => lockScreenfn(context)),
        );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      final lockState = 'lockState';
      var value1 = sharedPreferences.getBool(lockState) ?? false;
      appLock = value1;
      final password = 'Password';
      var pass = sharedPreferences.getString(password);
      applockpass = pass;
      setState(() {});
    });

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
      home: LockCheck(),
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

String applockpass = "1234";
SharedPreferences sharedPreferences;
