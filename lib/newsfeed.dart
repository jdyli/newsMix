import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/article_details.dart';
import 'package:newsapp/main.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'constants.dart';
import 'sourcesView.dart';
import 'inAppBrowser.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';

class NewsFeedPage extends StatefulWidget {
  NewsFeedPage({Key key}) : super(key: key);

  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
//        backgroundColor: Color(0xffffb380),
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home, color: Color(0xFF0A0E21)),
            title: Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite, color:Colors.grey),
            title: Container(height: 0.0),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 60, 0, 20),
              child: SourcesView(),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text('News Stories', style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.w800, fontFamily: 'OpenSans',
              color: Color(0xFF0A0E21),
            )),
          ),
          Expanded(
            flex: 3,
            child: Consumer<NewsSourceModel>(
              builder: (context, newsSource, child) {
                return new FutureBuilder<List<News>>(
                future: fetchNews(http.Client(), newsSource.newsSourceId), // a Future<String> or null
                builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                ? NewsList(news: snapshot.data)
                    : Center(child: CircularProgressIndicator());
                },);
                },),
              ),
            ],
          ),
      );
  }
}

Future<List<News>> fetchNews(http.Client client, int sourceId) async {
  String url;

  if (sourceId == 0) {
    url = Constants.base_url + "everything?domains=bbc.co.uk&apiKey=" + Constants.key;
  }
  else if (sourceId == 1) {
    url = Constants.base_url + "everything?domains=rtlnieuws.nl&apiKey=" + Constants.key;
  }
  else if (sourceId == 2) {
    url = Constants.base_url + "everything?domains=techcrunch.com&apiKey=" + Constants.key;
  }
  else {
    url = Constants.base_url + "everything?domains=wired.com&apiKey=" + Constants.key;
  }

  final response = await client.get(url);
  print(url);
  return compute(parseNews, response.body);
}

List<News> parseNews(String responseBody) {
  final parsed = json.decode(responseBody);
  return (parsed["articles"] as List)
      .map<News>((json) => new News.fromJson(json))
      .toList();
}

String reformatDate(String date) {
  String newDate = DateFormat('LLL d, y  •  HH:mm')
      .format(DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(date));
  return newDate;
}

class News {
  String source;
  String title;
  String date;
  String url;
  String image;

  News({this.source, this.title, this.date,
    this.url, this.image});

  factory News.fromJson(Map<String, dynamic> json) {


    return News(
      source: json['source']['name'] as String,
      title: json['title'] as String,
      date: reformatDate(json['publishedAt']),
      url: json['url'] as String,
      image: json['urlToImage'] as String,
    );
  }
}

class NewsList extends StatelessWidget {
  final List<News> news;

  NewsList({Key key, this.news}) : super(key: key);
  final ChromeSafariBrowser browser = new MyChromeSafariBrowser(new MyInAppBrowser());

  @override
  Widget build(BuildContext context) {
    return Container(
//    height: 400.0,
//      width: 300.0,
      child: ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          return new GestureDetector(
            onTap: () async {
              await browser.open(
                  url: news[index].url,
                  options: ChromeSafariBrowserClassOptions(
                      android: AndroidChromeCustomTabsOptions(addDefaultShareMenuItem: false),
                      ios: IOSSafariOptions(barCollapsingEnabled: true)));
            },
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                Expanded(
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(news[index].image,
                          width: 100.0),),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Column(
                    // align the text to the left instead of centered
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 200,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text(news[index].title, style: TextStyle(
                            fontSize: 15, fontFamily: 'Playfair Display',
                            fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,),
                      ),
                      Container(
                        width: 200,
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text(news[index].source, style: TextStyle(
                                fontSize: 12, fontFamily: 'OpenSans', color: Colors.black38,
                                fontWeight: FontWeight.w600,
                              )),
                            ),
                            Text(news[index].date, style: TextStyle(
                              fontSize: 12, fontFamily: 'OpenSans', color: Colors.black38,
                              fontWeight: FontWeight.w600,
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ],
              )
            ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

