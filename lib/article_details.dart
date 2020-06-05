import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'constants.dart';
import 'newsfeed.dart';

class ArticleDetailsPage extends StatelessWidget {

  ArticleDetailsPage({@required this.newsItem});

  final News newsItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Image.network(Constants.image),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 15, 0, 20),
                      child: Text(newsItem.title, style: TextStyle(
                        fontSize: 25.0, color: Colors.black,
                        fontFamily: 'Playfair Display',
                        fontWeight: FontWeight.w600,
                      ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 8, 0),
                            child: Text(newsItem.source, style: TextStyle(
                              fontSize: 11.0, color: Colors.black38,
                              fontFamily: 'OpenSans',
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600,
                            ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(8, 0, 5, 0),
                            child: Text(newsItem.date.toString(), style: TextStyle(
                              fontSize: 11.0, color: Colors.black38,
                              fontFamily: 'OpenSans',
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600,
                            ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(17.0), decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0),
                    )
                ),
                  child: Text(Constants.content, style: TextStyle(
                    fontSize: 16.0, color: Colors.black54,
                    fontFamily: 'OpenSans',
                    height: 1.5,
                  )),
                ),
              ),
            ),
          ],
      )
    );
  }
}


