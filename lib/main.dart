import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'newsfeed.dart';
import 'article_details.dart';
import 'inAppBrowser.dart';

class NewsSourceModel extends ChangeNotifier {
  int _newsSourceId = 0;

  int get newsSourceId => _newsSourceId;
  void selectedNewsSource(int value) {
    _newsSourceId = value;
    notifyListeners();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => NewsSourceModel(),
      child: MyApp(),
  )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
//        primaryColor: Color(0xffffe0cc),
//        scaffoldBackgroundColor: Color(0xffffe0cc),
      ),
      home: NewsFeedPage(),
    );
  }
}