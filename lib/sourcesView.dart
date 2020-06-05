import 'package:flutter/material.dart';
import 'package:newsapp/main.dart';
import 'package:provider/provider.dart';

class SourcesView extends StatefulWidget {
  @override
  _SourcesViewState createState() => _SourcesViewState();
}

class _SourcesViewState extends State<SourcesView> {
  @override

  int _index = 0;

  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: PageView.builder(
          itemCount: 4,
          controller: PageController(viewportFraction: 0.3),
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_, i) {
            return Transform.scale(
                scale: i == _index ? 1 : 0.8,
                child: GestureDetector(
                  onTap: () => Provider.of<NewsSourceModel>(context, listen: false).selectedNewsSource(_index),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image(image: AssetImage('images/logo${i+1}.jpg'),
                            fit: BoxFit.fill), // card height)
                  ),
                )
            );
          },
        ),
      ),
    );
  }
}