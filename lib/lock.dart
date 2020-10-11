import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/lock_screen.dart';
import 'package:gallery_app/lockscreen.dart';
import 'package:gallery_app/main.dart';
import 'package:local_auth/local_auth.dart';
import 'package:photo_gallery/photo_gallery.dart';

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
        title: Text(""),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Set LockPassword"),
            subtitle: Text("By default it is 1234"),
            onTap: (){
              showConfirmPasscode(
            context: context,
            onCompleted: (context, verifyCode) {
              applockpass=verifyCode;
              print(verifyCode);
              Navigator.of(context).maybePop();
            },
          );
            },
        ),
          ListTile(
            title: Text("Lock the application"),
            trailing: Switch(
              value: appLock,
              onChanged: (bool newappstate) {
                setState(() {
                  appLock = newappstate;
                });
                if (newappstate == true) {
                  buildShowLockScreen(context);
    }
                 else {
                  print("AppUnlocked");
                }
              },
            ),
          ),
          Divider(
            thickness: 1,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: isLockedlist.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(isLockedlist[index].key),
                    trailing: Switch(
                        value: isLockedlist[index].locked,
                        onChanged: (bool newvalue) {
                          setState(() {
                            isLockedlist[index].locked = newvalue;
                          });
                        }));
              }),
        ],
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

bool value = false;
