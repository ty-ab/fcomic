import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fcomic/rounded_row.dart';
import 'package:fcomic/skeleton-image-widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ds_imageloder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'fcomic',
    options:
        Platform.isMacOS || Platform.isIOS
            ? FirebaseOptions(
              apiKey: 'AIzaSyDaw3Ld3ggaGfp2HBVuxgmlcMCDdYkzc2U',
              appId: 'IOS KEY',
              messagingSenderId: '99064353723',
              projectId: 'fcomic-3fc3e',
              databaseURL:
                  'https://fcomic-3fc3e-default-rtdb.europe-west1.firebasedatabase.app',
            )
            : FirebaseOptions(
              apiKey: 'AIzaSyDaw3Ld3ggaGfp2HBVuxgmlcMCDdYkzc2U',
              appId: '1:99064353723:android:bcdbc670acb27a5cfe6a9e',
              messagingSenderId: '99064353723',
              projectId: 'fcomic-3fc3e',
              databaseURL:
                  'https://fcomic-3fc3e-default-rtdb.europe-west1.firebasedatabase.app',
            ),
  );
  runApp(ProviderScope(child: MyApp(app: app)));
}

class MyApp extends StatelessWidget {
  final FirebaseApp app;
  const MyApp({super.key, required this.app});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Comic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: 'Comic Reader', app: app),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.app});

  final String title;

  final FirebaseApp app;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DatabaseReference bannerRef;
  late DatabaseReference comicRef;

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase _db = FirebaseDatabase.instance;
    bannerRef = _db.ref('Banners');
    comicRef = _db.ref('Comic');
    getBanner(bannerRef).then((bannerList) {
      print("Banner List: $bannerList");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: FutureBuilder<List<String>>(
        future: getBanner(bannerRef),
        builder: (context, snapshot) {
          // snapshot.data?.map((e)=>{debugPrint("LOG:${(e)}")});
          if (snapshot.hasData) {
            // debugPrint("LOG:${snapshot.data?.last}");
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CarouselSlider(
                  items:
                      snapshot.data
                          ?.map(
                            (element) => Builder(
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.all(5),
                                  child: CustomImage(
                                    imageUrl: element,
                                    fit: BoxFit.cover,
                                    borderRadius: 12,
                                    skeletonBaseColor: Colors.blueGrey[100]!,
                                    skeletonHighlightColor:
                                        Colors.blueGrey[50]!,
                                    fadeInDuration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    animateToClosest: true,
                    initialPage: 0,
                    height: MediaQuery.of(context).size.height / 4,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFA89ACF),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                        ),
                        margin: EdgeInsets.only(left: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text("New Comics"),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0x34252533),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                        margin: EdgeInsets.only(right: 5),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(''),
                        ),
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: getComic(comicRef),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Text('data:${snapshot.data?.first}'),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('data has error:${snapshot.hasError}'),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: SkeletonImageLoader(
                imageUrl:
                    'https://tinypng.com/static/images/george-anim/large_george_x2.webp',
                fit: BoxFit.cover,
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<List<String>> getBanner(DatabaseReference bannerRef) async {
    debugPrint("LOG:HEY");

    final event = await bannerRef.once();
    final snapshot = event.snapshot;
    final data = snapshot.value;

    if (data is List) {
      data.map((e) => debugPrint("LOG:$e"));
      return data.cast<String>().toList();
    }
    debugPrint("LOG:${data is List}");

    return [];
    // return bannerRef.once().then((snapshot)=>snapshot.value.cast<String>().toList());
  }

  Future<List<String>> getComic(DatabaseReference comicRef) async {
    debugPrint("LOG:HEY");

    final event = await comicRef.once();
    final snapshot = event.snapshot;
    final data = snapshot.value;

    if (data is List) {
      data.map((e) => debugPrint("LOG:$e"));
      return data.cast<String>().toList();
    }
    debugPrint("LOG:${data is List}");

    return [];
    // return bannerRef.once().then((snapshot)=>snapshot.value.cast<String>().toList());
  }
}
