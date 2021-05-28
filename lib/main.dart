import 'package:flutter/material.dart';
import './page/homeOverviewScreen.dart';

void main() {
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
      home: HomeOverviewScreen(),
      // initialRoute: HomeOverviewScreen.id,
      // routes: {
      //   HomeOverviewScreen.id: (context) => HomeOverviewScreen(),
      //   LyricsDetailsScreen.id: (context) => LyricsDetailsScreen(),
      // },
    );
  }
}
