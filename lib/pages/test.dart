import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mainguyen/appbar/appbar.dart';
import 'package:mainguyen/widgets/bodyWidget.dart';
import 'package:mainguyen/widgets/titleAppbarWidget.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

String convertUint8ListToString(Uint8List uint8list) {
  return String.fromCharCodes(uint8list);
}

Uint8List convertStringToUint8List(String str) {
  final List<int> codeUnits = str.codeUnits;
  final Uint8List unit8List = Uint8List.fromList(codeUnits);
  return unit8List;
}

class FirebaseUser {
  FirebaseUser({required this.name, required this.image});
  String name;
  String image;
  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }

  FirebaseUser.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        image = json['image'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
      };

  Uint8List toUint8FromString() {
    return convertStringToUint8List(image);
  }

  factory FirebaseUser.fromDocument(DocumentSnapshot doc) {
    return FirebaseUser(name: doc.get('name'), image: doc.get('image'));
  }
}

class a {}

class _TestState extends State<Test> {
  @override
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            backButton: true,
            title: TitleAppbarWidget(content: "Test"),
            widgetActions: []),
        body: BodyWidget(
            bodyWidget: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  FirebaseUser users = FirebaseUser(name: 'sdqd', image: "");
                  _userCollection
                      .add(users.toJson())
                      .then((value) => print("USER ADDED"));
                },
                child: Text("TEST ADD")),
            Container(
              height: 250,
              child: StreamBuilder<QuerySnapshot>(
                  stream: users,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading...");
                    }
                    final data = snapshot.requireData;
                    return ListView.builder(
                        itemCount: data.size,
                        itemBuilder: (context, index) {
                          FirebaseUser s =
                              FirebaseUser.fromDocument(data.docs[index]);
                          // late Uint8List ss = convertStringToUint8List(
                          //     data.docs[index]['ss']);
                          return Row(
                            children: [
                              Text("USER: ${data.docs[index]['name']}",
                                  style: TextStyle(color: Colors.red)),
                              IconButton(
                                  onPressed: () async {
                                    final XFile? file = await ImagePicker()
                                        .pickImage(source: ImageSource.camera);
                                    Uint8List test = await file!.readAsBytes();
                                    FirebaseUser ss1 =
                                        FirebaseUser.fromDocument(
                                            data.docs[index]);
                                    ss1.image = convertUint8ListToString(test);
                                    ss1.name = "NGUYEN NGOC CUONG";
                                    _userCollection
                                        .doc(data.docs[index].id)
                                        .update(ss1.toJson()
                                            // "name": "dd",
                                            // "image": convertUint8ListToString(test)

                                            );
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    _userCollection
                                        .doc(data.docs[index].id)
                                        .delete();
                                  },
                                  icon: Icon(Icons.delete)),
                              // if (data.docs[index]['ss']) Text("SS")
                              Container(
                                  height: 100,
                                  width: 100,
                                  child: Image.memory(s.toUint8FromString()))
                            ],
                          );
                        });
                  }),
            )
          ],
        )));
  }
}
