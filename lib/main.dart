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
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      final lockState = 'lockState';
      var value1 = sharedPreferences.getBool(lockState);
      if (value1 == true) {
        appLock = value1;
      } else {
        appLock = false;
      }
      final password = 'Password';
      var pass = sharedPreferences.getString(password);
      if (pass != null) {
        applockpass = pass;
      } else {
        applockpass = "1234";
      }
      final listkey = "lockedlist";
      var list = sharedPreferences.getStringList(listkey);
      templockedlist = list;
      if (templockedlist.length != lockedlist.length) {
        lockedlist = templockedlist;
      } else {}
      setState(() {});
    });

    // lock();
    PhotoGallery.listAlbums(mediumType: MediumType.image).then((value) {
      value.forEach((element) {
        isLockedlist.add(IsLocked(key: element.name, locked: false));
        // print(element.name);
        allalbumlist.add(element.name);
      });

      lockScreenfn(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
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

bool appLock;

String applockpass = "1234";
SharedPreferences sharedPreferences;
List<Medium> imagemedium;
List<String> lockedlist = ['application'];
List<String> templockedlist = ['application'];
List<String> allalbumlist = [];
// lock() {
//   print("THODANGI");
//   if (isLockedlist.length != lockedlist) {
//     print("ULLIL KERI0");
//     for (int i = 0; i < lockedlist.length; i++) {
//       print("ULLIL KERI1");
//       for (String name in lockedlist) {
//         print("ULLIL KERI2");
//         if (isLockedlist[i].key == name) {
//           print("ULLIL KERI3");
//           isLockedlist[i].locked = true;
//         }
//       }
//     }
//   }
// }
