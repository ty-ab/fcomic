import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'fcomic_android',
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
  FirebaseApp app;
  MyApp({super.key, required this.app});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
      ),
    );
  }
}
