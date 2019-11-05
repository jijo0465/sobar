import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoGallery extends StatelessWidget{
  final List<String> urlList;
  final String title;
  final String source;
  const PhotoGallery({Key key, this.urlList, this.title, @required this.source}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int count=urlList.length;
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: source=="network"?NetworkImage(urlList[index]):FileImage(File(urlList[index])),
              initialScale: PhotoViewComputedScale.contained,
              onTapDown: (a,b,c){
                Navigator.pop(context);
          },
          // heroTag: galleryItems[index].id,
        );
      },
      itemCount: count,
      loadingChild: Icon(Icons.local_drink),
      // backgroundDecoration: widget.backgroundDecoration,
      // pageController: widget.pageController,
      // onPageChanged: onPageChanged,
    ),
      ),
    );
  }

}