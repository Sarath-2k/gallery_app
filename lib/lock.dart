import 'package:flutter/material.dart';
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
        // body: GridView.count(
        //   // childAspectRatio: 10,
        //   crossAxisCount: 1,
        //   mainAxisSpacing: 0.2,
        //   // crossAxisSpacing: 5.0,
        //   children: <Widget>[
        //     ...?albumlist?.map(
        //       (album) => GestureDetector(
        //         onTap: () {},
        //         child: Column(
        //           children: <Widget>[
        //             SizedBox(
        //               height: 20,
        //             ),
        //             Container(
        //               // alignment: Alignment.center,
        //               padding: EdgeInsets.only(left: 2.0),
        //               child: Row(
        //                 children: [
        //                   Text(
        //                     album.name,
        //                     maxLines: 1,
        //                     textAlign: TextAlign.start,
        //                     style: TextStyle(
        //                       height: 1.2,
        //                       fontSize: 16,
        //                     ),
        //                   ),
        //                   ToggleButtons(
        //                     isSelected: [true, false],
        //                     borderColor: Colors.black,
        //                     fillColor: Colors.grey,
        //                     borderWidth: 2,
        //                     selectedBorderColor: Colors.black,
        //                     selectedColor: Colors.white,
        //                     borderRadius: BorderRadius.circular(0),
        //                     children: <Widget>[
        //                       Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Text(
        //                           'Unlocked',
        //                           style: TextStyle(fontSize: 16),
        //                         ),
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Text(
        //                           'Locked',
        //                           style: TextStyle(fontSize: 16),
        //                         ),
        //                       ),
        //                     ],
        //                     onPressed: (int index) {
        //                       setState(() {
        //                         // for (int i = 0; i < isSelected.length; i++) {
        //                         //     isSelected[i] = i == index
        //                         // }
        //                       });
        //                     },
        //                     // isSelected: isSelected,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // )
        body: ListView.builder(
            itemCount: isLockedlist.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(isLockedlist[index].key),
                trailing: ToggleButtons(
                  isSelected: [true, false],
                  borderColor: Colors.black,
                  fillColor: Colors.grey,
                  borderWidth: 2,
                  selectedBorderColor: Colors.black,
                  selectedColor: Colors.white,
                  borderRadius: BorderRadius.circular(0),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Unlocked',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Locked',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index
                      }
                    });
                  },
                  // isSelected: isSelected,
                ),
              );
            }));
  }
}
