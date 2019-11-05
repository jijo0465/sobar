import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudians/bottom_sheet_title.dart';
import 'package:kudians/photo_gallery.dart';

class PhotoList extends StatelessWidget{
  final List<String> url;
  final int count;
  final String title;
  final String source;

  const PhotoList({Key key, @required this.url, this.count, this.title, @required this.source}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return url.isNotEmpty? Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 0, 0),
            child: BottomSheetTitle(title:"Photos"),
          ),
          Container(
                height: 150.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: count,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 8, 8),
                      child:GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context){
                                return PhotoGallery(urlList: url,title: title,source: source,);
                              }
                            )
                            );
                        },
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(10.0),
                          child: (source=="network")?Image.network(url[index]):
                            Image.file(File(url[index]))
                          ),
                        )
                      
                      );
                  },
                ),
              ),
        ],
      ),
    ):Container();
  }

}

