import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/lock_screen.dart';
import 'package:gallery_app/main.dart';
import 'package:local_auth/local_auth.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lock extends StatefulWidget {
  @override
  _LockState createState() => _LockState();
}

List<Album> albumlist;

class _LockState extends State<Lock> {
  bool appLock1 = false;
  @override
  void initState() {
    PhotoGallery.listAlbums(mediumType: MediumType.image).then((value) {
      setState(() {
        albumlist = value;
        appLock1 = appLock;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text("Set LockPassword"),
              subtitle: Text("By default it is 1234"),
              onTap: () {
                showConfirmPasscode(
                  context: context,
                  onCompleted: (context, verifyCode) async {
                    applockpass = verifyCode;
                    final prefs = await SharedPreferences.getInstance();
                    final key = "Password";
                    final value = applockpass;
                    prefs.setString(key, value);
                    print(verifyCode);
                    Navigator.of(context).maybePop();
                  },
                );
              },
            ),
            ListTile(
              title: Text("Lock the application"),
              trailing: Switch(
                value: appLock1,
                onChanged: (bool newappstate) async {
                  final prefs = await SharedPreferences.getInstance();
                  final key = 'lockState';
                  final value = newappstate;
                  prefs.setBool(key, value);
                  setState(() {
                    appLock = newappstate;
                    appLock1 = newappstate;
                  });
                  if (newappstate == true) {
                    buildShowLockScreen(context);
                  } else {
                    print("AppUnlocked");
                  }
                },
              ),
            ),
            Divider(
              thickness: 1,
            ),
            ListView.builder(
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: isLockedlist.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(isLockedlist[index].key),
                      trailing: Switch(
                          value: isLockedlist[index].locked,
                          onChanged: (bool newvalue) async {
                            final prefs = await SharedPreferences.getInstance();
                            final key = "lockedlist";
                            final value = isLockedlist[index].key;
                            final newlist = lockedlist.add(value);
                            prefs.setStringList(key, lockedlist);
                            setState(() {
                              isLockedlist[index].locked = newvalue;
                              if (newvalue == true) {
                                print(isLockedlist[index].key);
                                lockedlist.add(isLockedlist[index].key);
                                print(lockedlist);
                              } else {
                                isLockedlist[index].locked = newvalue;
                                if (newvalue == false) {
                                  lockedlist.remove(isLockedlist[index].key);
                                  print(lockedlist);
                                }
                              }
                              ;
                            });
                          }));
                }),
          ],
        ),
      ),
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
        final didAuthenticate = await localAuth.authenticateWithBiometrics(
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

bool value = false;
