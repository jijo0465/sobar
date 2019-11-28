import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoGallery extends StatefulWidget{
  final List<String> urlList;
  final String source;
  final int index;
  const PhotoGallery({Key key, this.urlList, @required this.source,this.index}) : super(key: key);

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
PageController controller=PageController();  
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setPage(context));
          }
          @override
          Widget build(BuildContext context) {
            int count=widget.urlList.length;
            return Scaffold(
              body: Container(
                color: Colors.black,
                child: PhotoViewGallery.builder(
                  pageController: controller,
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: widget.source=="network"?NetworkImage(widget.urlList[index]):FileImage(File(widget.urlList[index])),
                      initialScale: PhotoViewComputedScale.contained,
                      onTapDown: (a,b,c){
                        Navigator.pop(context);
                  },
                  // heroTag: galleryItems[index].id,
                );
              },
              itemCount: count,
              loadingChild: CupertinoActivityIndicator(animating: true),
              // backgroundDecoration: widget.backgroundDecoration,
              // pageController: widget.pageController,
              // onPageChanged: onPageChanged,
            ),
              ),
            );
            
          }
        
          setPage(BuildContext context) {
            controller.animateToPage(widget.index,duration: Duration(milliseconds: 10),curve: Curves.linear);
          }
}