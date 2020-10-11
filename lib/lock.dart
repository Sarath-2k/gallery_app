import 'package:flutter/material.dart';
import 'package:gallery_app/lockscreen.dart';
import 'package:gallery_app/main.dart';
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
          icon: Icon(Icons.tab),
          onPressed: () {
            print(albumlist);
          },
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Lock the application"),
            trailing: Switch(
              value: appLock,
              onChanged: (bool newappstate) {
                setState(() {
                  appLock = newappstate;
                });
                if (newappstate == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LockScreen()),
                  );
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
}

bool value = false;
