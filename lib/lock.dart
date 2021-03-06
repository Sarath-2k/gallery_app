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
  @override
  void initState() {
    PhotoGallery.listAlbums(mediumType: MediumType.image).then((value) {
      setState(() {
        albumlist = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
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
                    Navigator.of(context).maybePop();
                  },
                );
              },
            ),
            ListTile(
              title: Text("Lock the application"),
              trailing: Switch(
                value: appLock,
                onChanged: (bool newappstate) async {
                  final prefs = await SharedPreferences.getInstance();
                  final key = 'lockState';
                  final value = newappstate;
                  prefs.setBool(key, value);
                  setState(() {
                    appLock = newappstate;
                  });
                  if (newappstate == true) {
                    buildShowLockScreen(context);
                  } else {}
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
                            final value = isLockedlist[index].locked;
                            setState(() {
                              isLockedlist[index].locked = newvalue;
                              if (newvalue == true) {
                                lockedlist.add(isLockedlist[index].key);
                              } else {
                                isLockedlist[index].locked = newvalue;
                                if (newvalue == false) {
                                  lockedlist.remove(isLockedlist[index].key);
                                }
                              }
                              prefs.setStringList(key, lockedlist);
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
      onUnlocked: () {},
    );
  }
}

bool value = false;
