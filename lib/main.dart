import 'dart:async';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_to_text/a_main_pages/home_page.dart';

import 'model/item_details.dart';

AppBar defAppBar = new AppBar();
List<CameraDescription> cameras = [];

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  await Hive.initFlutter();

  Hive.registerAdapter(ItemDetailsAdapter());

  await Hive.openBox<ItemDetails>('items');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashActivity(),
    );
  }
}

class SplashActivity extends StatefulWidget {
  const SplashActivity({Key? key}) : super(key: key);

  @override
  _SplashActivityState createState() => _SplashActivityState();
}

class _SplashActivityState extends State<SplashActivity> {

  int a = 0;
  var connectivityResult;
  bool selected = false;

  @override
  void initState() {
    super.initState();

    startTime();
    startAnim();
  }

  void startAnim() async {
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      selected = true;
    });
  }

  startTime() async {
    return Timer(Duration(milliseconds: 100), navigationPage);
  }

  void navigationPage() {

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
            (Route<dynamic> route) => false,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          width: selected ? 180 : 0,
          height: selected ? 180 : 0,
          //color: selected ? Colors.red : Colors.blue,
          alignment:
          selected ? Alignment.center : AlignmentDirectional.topCenter,
          duration: const Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          child: Center(
            child: Icon(Icons.email),
          ),
        ),
      ),
    );
  }
}
